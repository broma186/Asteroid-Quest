//
//  Asteroid.m
//  SpaceMission
//
//  Created by Matt on 3/06/15.
//  Copyright (c) 2015 Matthew Brooker. All rights reserved.
//

#import "Asteroid.h"
#import "Math.h"
#import "Bitmasks.h"
#import "Constants.h"

@implementation Asteroid

- (id)initWithType: (int) type
{
    if(self = [super init]){
        
        Math *math = [Math new];
        
        if (type == 1){
          
            SKTexture * ast1Texture1 = [SKTexture textureWithImageNamed:@"asteroid1.1"];
            ast1Texture1.filteringMode = SKTextureFilteringNearest;
            
            SKTexture* ast1Texture2 = [SKTexture textureWithImageNamed:@"asteroid1.2"];
            ast1Texture2.filteringMode = SKTextureFilteringNearest;
    
            SKTexture* ast1Texture3 = [SKTexture textureWithImageNamed:@"asteroid1.3"];
            ast1Texture3.filteringMode = SKTextureFilteringNearest;
            
            SKTexture* ast1Texture4 = [SKTexture textureWithImageNamed:@"asteroid1.4"];
            ast1Texture4.filteringMode = SKTextureFilteringNearest;
            
            self = [Asteroid spriteNodeWithTexture: ast1Texture1];
            
            self.physicsBody = [SKPhysicsBody bodyWithTexture:self.texture size:self.size];
            self.physicsBody.dynamic = YES;
            self.physicsBody.categoryBitMask = asteroidBitMask;
            self.physicsBody.contactTestBitMask = spaceshipBitMask | missileBitMask;
            self.physicsBody.collisionBitMask = COLLISION_BITMASK_ZERO;
            self.physicsBody.usesPreciseCollisionDetection = YES;
            
            
            SKAction *move= [SKAction moveByX:ASTEROID_MOVE_X y:ASTEROID_MOVE_Y duration:5.0];
            move.speed = [math randFloatValBetweenMin:ASTEROID_MIN_MOVE_SPEED Max:ASTEROID_MAX_MOVE_SPEED];
            
            SKAction *rotate = [SKAction repeatActionForever:[SKAction animateWithTextures:@[ast1Texture1, ast1Texture2,
                                                                                             ast1Texture3, ast1Texture4] timePerFrame:TIME_BETWEEN_SPIN_FRAME1]];
            
            SKAction *group = [SKAction group:@[rotate, move]];
            [self runAction:group withKey:@"group"];

        }
        
        
        else if (type == 2){
        
            
            SKTexture * ast2Texture1 = [SKTexture textureWithImageNamed:@"asteroid2.1"];
            ast2Texture1.filteringMode = SKTextureFilteringNearest;
            
            SKTexture* ast2Texture2 = [SKTexture textureWithImageNamed:@"asteroid2.2"];
            ast2Texture2.filteringMode = SKTextureFilteringNearest;
            
            SKTexture* ast2Texture3 = [SKTexture textureWithImageNamed:@"asteroid2.3"];
            ast2Texture3.filteringMode = SKTextureFilteringNearest;
            
            SKTexture* ast2Texture4 = [SKTexture textureWithImageNamed:@"asteroid2.4"];
            ast2Texture4.filteringMode = SKTextureFilteringNearest;
            
            self = [Asteroid spriteNodeWithTexture: ast2Texture1];
            
            self.physicsBody = [SKPhysicsBody bodyWithTexture:self.texture size:self.size];
            self.physicsBody.dynamic = YES;
            self.physicsBody.categoryBitMask = asteroidBitMask;
            self.physicsBody.contactTestBitMask = spaceshipBitMask | missileBitMask;
            self.physicsBody.collisionBitMask = COLLISION_BITMASK_ZERO;
            self.physicsBody.usesPreciseCollisionDetection = YES;
            
            SKAction *move= [SKAction moveByX:ASTEROID_MOVE_X y:ASTEROID_MOVE_Y duration:5.0];
            move.speed = [math randFloatValBetweenMin:ASTEROID_MIN_MOVE_SPEED Max:ASTEROID_MAX_MOVE_SPEED];
            
            SKAction *rotate = [SKAction repeatActionForever:[SKAction animateWithTextures:@[ast2Texture1, ast2Texture2,
                                                                                             ast2Texture3, ast2Texture4] timePerFrame:TIME_BETWEEN_SPIN_FRAME2]];
            
            SKAction *group = [SKAction group:@[rotate, move]];
            [self runAction:group withKey:@"group"];
            
        }
        
        else if (type == 3){
            
      
            SKTexture * ast3Texture1 = [SKTexture textureWithImageNamed:@"asteroid3.1"];
            ast3Texture1.filteringMode = SKTextureFilteringNearest;
            
            SKTexture* ast3Texture2 = [SKTexture textureWithImageNamed:@"asteroid3.2"];
            ast3Texture2.filteringMode = SKTextureFilteringNearest;
            
            SKTexture* ast3Texture3 = [SKTexture textureWithImageNamed:@"asteroid3.3"];
            ast3Texture3.filteringMode = SKTextureFilteringNearest;
            
            SKTexture* ast3Texture4 = [SKTexture textureWithImageNamed:@"asteroid3.4"];
            ast3Texture4.filteringMode = SKTextureFilteringNearest;
            
             self = [Asteroid spriteNodeWithTexture: ast3Texture1];
            
            self.physicsBody = [SKPhysicsBody bodyWithTexture:self.texture size:self.size];
            self.physicsBody.dynamic = YES;
            self.physicsBody.categoryBitMask = asteroidBitMask;
            self.physicsBody.contactTestBitMask = spaceshipBitMask | missileBitMask;
            self.physicsBody.collisionBitMask = COLLISION_BITMASK_ZERO;
            self.physicsBody.usesPreciseCollisionDetection = YES;
            
            SKAction *move= [SKAction moveByX:ASTEROID_MOVE_X y:ASTEROID_MOVE_Y duration:5.0];
            move.speed = [math randFloatValBetweenMin:ASTEROID_MIN_MOVE_SPEED Max:ASTEROID_MAX_MOVE_SPEED];
            
            SKAction *rotate = [SKAction repeatActionForever:[SKAction animateWithTextures:@[ast3Texture1, ast3Texture2,
                                                                                             ast3Texture3, ast3Texture4] timePerFrame:TIME_BETWEEN_SPIN_FRAME3]];
            
            
            SKAction *group = [SKAction group:@[rotate, move]];
            [self runAction:group withKey:@"group"];
            
        }
        
        else if (type == 4){
            
       
            SKTexture* ast4Texture1 = [SKTexture textureWithImageNamed:@"asteroid4.1"];
            ast4Texture1.filteringMode = SKTextureFilteringNearest;
            
            SKTexture* ast4Texture2 = [SKTexture textureWithImageNamed:@"asteroid4.2"];
            ast4Texture2.filteringMode = SKTextureFilteringNearest;
            
            SKTexture* ast4Texture3 = [SKTexture textureWithImageNamed:@"asteroid4.3"];
            ast4Texture3.filteringMode = SKTextureFilteringNearest;
            
            SKTexture* ast4Texture4 = [SKTexture textureWithImageNamed:@"asteroid4.4"];
            ast4Texture4.filteringMode = SKTextureFilteringNearest;
            
            
            self = [Asteroid spriteNodeWithTexture: ast4Texture1];
            
            self.physicsBody = [SKPhysicsBody bodyWithTexture:self.texture size:self.size];
            self.physicsBody.dynamic = YES;
            self.physicsBody.categoryBitMask = asteroidBitMask;
            self.physicsBody.contactTestBitMask = spaceshipBitMask;
            self.physicsBody.collisionBitMask = COLLISION_BITMASK_ZERO;
            self.physicsBody.usesPreciseCollisionDetection = YES;
            
            SKAction *move= [SKAction moveByX:ASTEROID_MOVE_X y:ASTEROID_MOVE_Y duration:5.0];
            move.speed = [math randFloatValBetweenMin:ASTEROID_MIN_MOVE_SPEED Max:ASTEROID_MAX_MOVE_SPEED];
            
            SKAction *rotate = [SKAction repeatActionForever:[SKAction animateWithTextures:@[ast4Texture1, ast4Texture2,
                                                                                             ast4Texture3, ast4Texture4] timePerFrame:TIME_BETWEEN_SPIN_FRAME4]];
            
            SKAction *group = [SKAction group:@[rotate, move]];
            [self runAction:group withKey:@"group"];
        }
        
    }
    return self;
}


@end
