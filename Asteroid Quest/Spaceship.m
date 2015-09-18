//
//  Spaceship.m
//  Asteroid Quest
//
//  Created by Matt on 2/08/15.
//  Copyright (c) 2015 Matthew Brooker. All rights reserved.
//

#import "Spaceship.h"
#import "Bitmasks.h"
#import "SoundManager.h"
#import "Constants.h"

@implementation Spaceship

-(id) init {

    if (self == [super init]){
        
        SKTexture *spaceshipTexture = [SKTexture textureWithImageNamed:@"Spaceship!.png"];
        spaceshipTexture.filteringMode = SKTextureFilteringNearest;
        
        self = [Spaceship spriteNodeWithTexture:spaceshipTexture];
        
        [self setScale:IMAGE_SCALE];
    
    }
    return self;
}

-(void) startPlaying
{
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width / 2];
    self.physicsBody.dynamic = YES;
    self.physicsBody.categoryBitMask = spaceshipBitMask;
    self.physicsBody.contactTestBitMask = asteroidBitMask;
    self.physicsBody.collisionBitMask = COLLISION_BITMASK_ZERO;
    self.physicsBody.usesPreciseCollisionDetection = YES;
}

@end
