//
//  Spaceship.m
//  Asteroid Quest
//
//  Created by Matt on 2/08/15.
//  Copyright (c) 2015 Matthew Brooker. All rights reserved.
//

#import "Spaceship.h"
#import "Bitmasks.h"

@implementation Spaceship

-(id) init {

    if (self == [super init]){
        
        SKTexture * spaceshipTexture = [SKTexture textureWithImageNamed:@"Spaceship!.png"];
        spaceshipTexture.filteringMode = SKTextureFilteringNearest;
        
        self = [Spaceship spriteNodeWithTexture:spaceshipTexture];
        
        [self setScale:0.05];
    
    }
    
    return self;
    
}

-(void) startPlaying
{
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.dynamic = YES;
    self.physicsBody.categoryBitMask = spaceshipBitMask;
    self.physicsBody.contactTestBitMask = asteroidBitMask;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.usesPreciseCollisionDetection = YES;
}

@end
