//
//  GameScene.m
//  Asteroid Quest
//
//  Created by Matt on 28/07/15.
//  Copyright (c) 2015 Matthew Brooker. All rights reserved.
//

#import "SpaceScene.h"
#import "Score.h"
#import "Asteroid.h"
#import "Explosion.h"
#import "Math.h"
#import "Bitmasks.h"
#import "Intelligence.h"

@interface SpaceScene ()

@property (nonatomic, strong) ParallaxScrolling * parallaxBackground;

@end


@implementation SpaceScene {
    
    SKLabelNode * scoreLabel;
    Math *math;
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
    
    // Asteroids.
    SKAction *generateAsteroids = [SKAction performSelector:@selector(createAsteroids) onTarget:self];
    SKAction *wait = [SKAction waitForDuration:0 withRange:2];
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[generateAsteroids, wait]]]];
    
}


-(void) createBackground
{
    // Set parallax scrolling background
    
    self.direction = _direction;
    
    NSArray * imageNames = @[@"bg_planetsunrise", @"bg_galaxy", @"bg_front_spacedust"];
    
    
    ParallaxScrolling *parallax = [[ParallaxScrolling alloc] initWithBackgrounds:imageNames size:self.size direction:kParallaxBackgroundDirectionDown fastestSpeed:kParallaxBackgroundDefaultSpeed andSpeedDecrease:kParallaxBackgroundDefaultSpeedDifferential];
    
    self.parallaxBackground = parallax;
    [self addChild:parallax];
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
    
    SKSpriteNode *spaceship = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship!"];
    spaceship.name = @"spaceship";
    spaceship.position = CGPointMake(self.size.width / 2, 20);
    [spaceship setScale:0.05];
    
    spaceship.physicsBody = [SKPhysicsBody bodyWithTexture:spaceship.texture size:spaceship.size];
    spaceship.physicsBody.dynamic = YES;
    spaceship.physicsBody.categoryBitMask = spaceshipBitMask;
    spaceship.physicsBody.contactTestBitMask = asteroidBitMask;
    spaceship.physicsBody.collisionBitMask = 0;
    spaceship.physicsBody.usesPreciseCollisionDetection = YES;
    
    [self addChild:spaceship];
    
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
    
    
    for (UITouch *touch in touches) {
        CGPoint touchPoint = [touch locationInNode:self];
        
        NSArray *nodes = [self nodesAtPoint:touchPoint];
        
# pragma mark - Move spaceship on click.
        
        // Since reference is unavailable from initWithSize method.
        SKNode *spaceship = [self childNodeWithName:@"spaceship"];
        
        CGPoint shipPos = spaceship.position;
        
        // Distance between touchPoint and spaceship location.
        CGFloat distance = sqrtf((touchPoint.x-shipPos.x)*(touchPoint.x-shipPos.x)+
                                 (touchPoint.y-shipPos.y)*(touchPoint.y-shipPos.y));
        
        SKAction *moveToClick = [SKAction moveTo:touchPoint duration: distance /300];
        [spaceship runAction:moveToClick withKey:@"moveToClick"];
        
        
# pragma mark - Fire missile on Spaceship click.
        
        if([nodes containsObject: [self childNodeWithName:@"spaceship"]]){
            
            // Touched the spaceship, so shoot missiles.
            
            
            SKNode *missile = [self newMissile];
            
            CGFloat missileDistance = sqrtf((self.frame.size.height -250 - missile.position.y)*(self.frame.size.height - 250 - missile.position.y));
            
            SKAction *fireMissile = [SKAction moveToY:self.frame.size.height - 250 duration:missileDistance / 300];
            
            SKAction *remove = [SKAction removeFromParent];
            [missile runAction:[SKAction sequence:@[fireMissile,remove]]];
            
        }
    }
}


-(void)didSimulatePhysics

{
    [self enumerateChildNodesWithName:@"missile" usingBlock:^(SKNode *node, BOOL *stop) {
        
        if (node.position.y > self.size.height)
            
            [node removeFromParent];
        
    }];
    
    [self enumerateChildNodesWithName:@"asteroid" usingBlock:^(SKNode *node, BOOL *stop) {
        
        if (node.position.y < 0- node.frame.size.height)
            
            [node removeFromParent];
        
    }];
    
}

#pragma mark - Collision detection


- (void)ship:(SKPhysicsBody *)spaceship didCollideWithAsteroid:(SKPhysicsBody *)asteroid
{
    Explosion *explosion = [[Explosion alloc] init];
    explosion.name = @"explosion";
    explosion.position = CGPointMake(spaceship.node.position.x, spaceship.node.position.y);
    [self addChild: explosion];
    
    [asteroid.node removeFromParent];
    [spaceship.node removeFromParent];
}


-(void) hitAsteroid:(SKPhysicsBody*) asteroid withMissile:(SKPhysicsBody*)missile
{
    // Trigger explosion.
    
    Explosion *explosion = [[Explosion alloc] init];
    explosion.name = @"explosion";
    explosion.position = CGPointMake(asteroid.node.position.x, asteroid.node.position.y);
    [self addChild: explosion];
    
    // Add intelligence drop?
    
    math = [Math new];
    int randIntelChance = [math randIntValBetweenMin:1 Max: 3];
    
    if (randIntelChance == 2) {
         Intelligence *intel = [[Intelligence alloc] init];
         intel.name = @"intel";
         intel.position = CGPointMake(asteroid.node.position.x, asteroid.node.position.y);
         [self addChild:intel];
    }
    
    // Destroy asteroid and missile.
    
    [asteroid.node removeFromParent];
    [missile.node removeFromParent];
    
    // Add to the score.
    
    self.score += 1;
    scoreLabel.text = [NSString stringWithFormat:@"%lu",self.score];
}

// For when the player (ship) picks up intelligence.

- (void)ship:(SKPhysicsBody *)spaceship pickedUpIntel:(SKPhysicsBody *)intel
{
    // Player earns another 2 points.
    
    self.score += 2;
    [intel.node removeFromParent];
    
    
}



- (void)didBeginContact:(SKPhysicsContact *)contact
{
    if(contact.bodyA.node == nil ||
       contact.bodyB.node == nil){return;}
    
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
        NSLog(@"missile - ast");
        [self hitAsteroid:secondBody withMissile:firstBody];
        
        
    }
    
    // Ship colliding with asteroid.
    /*
     if ((firstBody.categoryBitMask & spaceshipBitMask) != 0)
     
     {
     NSLog(@"spaceship - asteroid");
     [self ship:firstBody didCollideWithAsteroid:secondBody];
     }
     */
    
    // Ship obtaining intelligence pickup.
    
    if ((firstBody.categoryBitMask & intelBitMask) != 0)
        
    {
        [self ship:firstBody pickedUpIntel:secondBody];
    }
    
    
}



# pragma mark - Update scene contents.

-(void)update:(CFTimeInterval)currentTime {
    
    [self.parallaxBackground update:currentTime];
    
    
}


@end