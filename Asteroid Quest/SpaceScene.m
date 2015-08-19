//
//  GameScene.m
//  Asteroid Quest
//
//  Created by Matt on 28/07/15.
//  Copyright (c) 2015 Matthew Brooker. All rights reserved.
//

#import "SpaceScene.h"
#import "Spaceship.h"
#import "Score.h"
#import "Asteroid.h"
#import "Explosion.h"
#import "Math.h"
#import "Bitmasks.h"
#import "Intel.h"
#import "SoundManager.h"





@implementation SpaceScene {
    
    Spaceship *ship;
    SKLabelNode * scoreLabel;
    Math *math;
    SKAction *generateAsteroids;
    SKAction *wait;
    Sound *laserSound;
    Sound *explosionSound;
    Sound *explosionShipSound;
    Sound *pickupSound;
    
   
}

static bool destroyed = NO;


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
        [self startGame];
        
    }
    return self;
}


-(void) startGame
{
    destroyed = NO;
    
    [self removeAllChildren];
    [self createBackground];
    [self createScore];
    [self createShip];
    [self initializeSound];
    
    if([self.delegate respondsToSelector:@selector(gameStart)]){
        [self.delegate gameStart];
    }
    
}


-(SKEmitterNode*) starFieldEmitterWithPath:(NSString*)path  starSpeedY:(CGFloat)starSpeedY starsPerSecond:(CGFloat)starsPerSecond starScaleFactor:(CGFloat)starScaleFactor {
    
     SKEmitterNode *starField =  [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:path ofType:@"sks"]];
    
    
    // Determine the time a star is visible on screen.
    CGFloat lifetime =  self.frame.size.height * [UIScreen mainScreen].scale / starSpeedY;
    
    [starField setPosition: CGPointMake(self.frame.size.width / 2,self.frame.size.height)];
    [starField setName:@"starField"];
    [starField setParticleBirthRate: starsPerSecond];

    [starField setParticleSpeed: starSpeedY];
    [starField setParticleScale: starScaleFactor];
    [starField setParticlePositionRange: CGVectorMake(self.frame.size.width, self.frame.size.height)];
    [starField setParticleLifetime: lifetime];
    
    
    /* Fast forward the effect to start with a filled screen.
       The time interval will allow the stars to jump forward and
      fill the screen with stars immediately.*/

    NSTimeInterval interval = lifetime;
    [starField advanceSimulationTime: interval];
    
    return starField;
}

-(void) createBackground
{

    self.backgroundColor = [SKColor blackColor];
    
    SKEmitterNode *starField1 = [self starFieldEmitterWithPath:@"starField1"  starSpeedY:50 starsPerSecond:1 starScaleFactor:0.2];
    starField1.zPosition = -10;
    [self addChild:starField1];
    
    SKEmitterNode *starField2 = [self starFieldEmitterWithPath:@"starField2"  starSpeedY:30 starsPerSecond:2 starScaleFactor:0.1];
    starField2.zPosition = -11;
    [self addChild:starField2];
    
    SKEmitterNode *starField3 = [self starFieldEmitterWithPath:@"starField3"  starSpeedY:15 starsPerSecond:4 starScaleFactor:0.05];
    starField3.zPosition = -12;
    [self addChild:starField3];
    
   
    
  
}


-(void) createAsteroids
{
    math = [Math new];
    
    CGFloat randSize = [math randFloatValBetweenMin:0 Max:0.5];
    CGFloat randX = [math randFloatValBetweenMin:0 Max:self.size.width];
    int randAstType = [math randIntValBetweenMin:1 Max: 4];
    
    Asteroid *asteroid = [[Asteroid alloc] initWithType:randAstType];
    [asteroid setName: @"asteroid"];
    [asteroid setScale:randSize];
    [asteroid setPosition:CGPointMake(randX, self.size.height)];
   
    [self addChild: asteroid];
    
}


-(void) createScore
{
    self.score = 0;
    scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica-Bold"];
    scoreLabel.text = @"0";
    scoreLabel.fontSize = 20;
    scoreLabel.position = CGPointMake(20, 20);
    scoreLabel.alpha = 0.2;
    [self addChild:scoreLabel];
    
}


-(void) createShip
{
    
    ship = [Spaceship new];
    [ship setName:@"spaceship"];
    [ship setPosition: CGPointMake(self.size.width / 2, 20)];
    [self addChild:ship];
    
 
}

# pragma mark - Initialize Sound.

- (void) initializeSound {
    
    // Laser
    laserSound = [Sound soundNamed:[NSString stringWithFormat:@"%@/Sound/ship_fire.caf", [[NSBundle mainBundle] resourcePath]]];
    
    // Asteroid - Laser explosion
    explosionSound = [Sound soundNamed:[NSString stringWithFormat:@"%@/Sound/explosion.caf", [[NSBundle mainBundle] resourcePath]]];
    
    // Pickup intel sound.
    pickupSound = [Sound soundNamed:[NSString stringWithFormat:@"%@/Sound/pickup.caf", [[NSBundle mainBundle] resourcePath]]];
    
    
}

# pragma mark - Create new missile.

- (SKSpriteNode *)newMissile
{
    SKSpriteNode *missile = [SKSpriteNode spriteNodeWithImageNamed:@"Brown-Bullet.png"];
    
    missile.name = @"missile";
    
    // A spaceship reference.
    SKNode *spaceship = [self childNodeWithName:@"spaceship"];
    
    [missile setScale:0.01];
    
    // Position missile at end of spaceship gun.
    missile.position = CGPointMake(spaceship.position.x, spaceship.position.y + 20);
    
    missile.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:missile.size];
    missile.physicsBody.dynamic = YES;
    missile.physicsBody.categoryBitMask = missileBitMask;
    missile.physicsBody.contactTestBitMask = asteroidBitMask;
    missile.physicsBody.collisionBitMask = 0;
    missile.physicsBody.usesPreciseCollisionDetection = YES;
    
    [self addChild:missile];
    
    return missile;
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (destroyed) {
        [self startGame];
    }else {
        if (!ship.physicsBody) {
            
            /* started playing so add physics body to spaceship, remove ready menu,
            and create the asteroids. */
            
            [ship startPlaying];
            if([self.delegate respondsToSelector:@selector(gamePlay)]){
                [self.delegate gamePlay];
            }
            
            // Make the asteroids move.
            generateAsteroids = [SKAction performSelector:@selector(createAsteroids) onTarget:self];
            wait = [SKAction waitForDuration:0 withRange:2];
            [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[generateAsteroids, wait]]] withKey:@"asteroidGen"];
            
        }
    }
    
    for (UITouch *touch in touches) {
        CGPoint touchPoint = [touch locationInNode:self];
        
        NSArray *nodes = [self nodesAtPoint:touchPoint];
        
        SKNode *spaceship = [self childNodeWithName:@"spaceship"];
        CGPoint shipPos = spaceship.position;
        
        /* Distance between touchPoint and spaceship location. Needed to maintain
        constant speed regardless of distance. */
        CGFloat distance = sqrtf((touchPoint.x-shipPos.x)*(touchPoint.x-shipPos.x)+
                                 (touchPoint.y-shipPos.y)*(touchPoint.y-shipPos.y));
        
        SKAction *moveToClick = [SKAction moveTo:touchPoint duration:distance /300];
        [spaceship runAction:moveToClick withKey:@"moveToClick"];
        
        
        
        if([nodes containsObject:[self childNodeWithName:@"spaceship"]]){
            
            // Touched the spaceship, so shoot missiles.
            
            SKNode *missile = [self newMissile];
            
            /* The distance between the y coordinate of the missile to the top of view.
               Calculated to make missile animation the same speed regardless of distance.*/
            
            CGFloat missileDistance = sqrtf((self.frame.size.height - missile.position.y)*(self.frame.size.height - missile.position.y));
            
            SKAction *fireMissile = [SKAction moveToY:self.frame.size.height duration:missileDistance / 300];
            
            SKAction *remove = [SKAction removeFromParent];
            [missile runAction:[SKAction sequence:@[fireMissile,remove]]];
            
            // Play laser sound
            
            [laserSound play];
            
        }
    }
}



#pragma mark - Collision detection


- (void)ship:(SKPhysicsBody *)spaceship didCollideWithAsteroid:(SKPhysicsBody *)asteroid
{
    destroyed = true;
    
    Explosion *explosion = [[Explosion alloc] init];
    explosion.name = @"explosion";
    explosion.position = CGPointMake(spaceship.node.position.x, spaceship.node.position.y);
    [self addChild: explosion];
    
    [explosionSound play];
    
    [asteroid.node removeFromParent];
    [spaceship.node removeFromParent];
    
    [Score registerScore:self.score];
    
    if([self.delegate respondsToSelector:@selector(spaceshipDestroyed)]){
        [self.delegate spaceshipDestroyed];
    }
    // Cease asteroid flow.
    [self removeActionForKey:@"asteroidGen"];
   
}


-(void) hitAsteroid:(SKPhysicsBody*) asteroid withMissile:(SKPhysicsBody*)missile
{
    
    // Trigger explosion.
    
    Explosion *explosion = [[Explosion alloc] init];
    explosion.name = @"explosion";
    explosion.position = CGPointMake(asteroid.node.position.x, asteroid.node.position.y);
    [self addChild: explosion];
    
    [explosionSound play];
   
    // Add intelligence drop?
    
    math = [Math new];
    int randIntelChance = [math randIntValBetweenMin:1 Max: 3];
    
    
    if (randIntelChance == 2) {
        
         Intel *intel = [[Intel alloc] init];
         intel.name = @"intel";
         intel.position = CGPointMake(asteroid.node.position.x, asteroid.node.position.y);
    
         intel.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:intel.size.height / 2];
         intel.physicsBody.dynamic = YES;
         intel.physicsBody.categoryBitMask = intelBitMask;
         intel.physicsBody.contactTestBitMask = spaceshipBitMask;
         intel.physicsBody.collisionBitMask = 0;
         intel.physicsBody.usesPreciseCollisionDetection = YES;
    
         [self addChild:intel];
        
    }
    
    [asteroid.node removeFromParent];
    [missile.node removeFromParent];
    
    // Add to the score.
    
    self.score += 1;
    scoreLabel.text = [NSString stringWithFormat:@"%d",(int)self.score];
}


// For when the player (ship) picks up intelligence. Player earns another 2 points.

- (void)ship:(SKPhysicsBody *)spaceship pickedUpIntel:(SKPhysicsBody *)intel
{
    self.score += 2;
    scoreLabel.text = [NSString stringWithFormat:@"%d",(int)self.score];
    [intel.node removeFromParent];
    
    [pickupSound play];
}



- (void)didBeginContact:(SKPhysicsContact *)contact
{
    
    
    if (contact.bodyA.node == nil || contact.bodyB.node == nil || destroyed)
    {
        return;
    }
    
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
        
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    // When a missile hits asteroid.
    
    if ((firstBody.categoryBitMask & missileBitMask) != 0)
    {
        
        if (secondBody.node.position.y < self.frame.size.height) {
            [self hitAsteroid:secondBody withMissile:firstBody];
        }
     }
    
    
    // Ship colliding with asteroid.
    
     if ((firstBody.categoryBitMask & spaceshipBitMask) != 0)
     {
         if ((secondBody.categoryBitMask & asteroidBitMask) != 0) {
            [self ship:firstBody didCollideWithAsteroid:secondBody];
         }
         
        // For when ship picks up intelligence.
         
         if ((secondBody.categoryBitMask & intelBitMask) != 0)
         {
             [self ship:firstBody pickedUpIntel:secondBody];
         }
    }
}



-(void)didSimulatePhysics
{
    [self enumerateChildNodesWithName:@"missile" usingBlock:^(SKNode *node, BOOL *stop) {
        
        if (node.position.y > self.frame.size.height)
            
            [node removeFromParent];
    }];
    
    [self enumerateChildNodesWithName:@"asteroid" usingBlock:^(SKNode *node, BOOL *stop) {
        
        if (node.position.y < 0 - node.frame.size.height)
            
            [node removeFromParent];
    }];
    
    [self enumerateChildNodesWithName:@"intel" usingBlock:^(SKNode *node, BOOL *stop) {
        
        if (node.position.y < 0 - node.frame.size.height)
            
            [node removeFromParent];
    }];
}



# pragma mark - Update scene contents.

-(void)update:(CFTimeInterval)currentTime {
    
}


@end