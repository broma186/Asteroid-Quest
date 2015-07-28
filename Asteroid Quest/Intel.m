//
//  Intel.m
//  Asteroid Quest
//
//  Created by Matt on 28/07/15.
//  Copyright (c) 2015 Matthew Brooker. All rights reserved.
//

#import "Intel.h"
#import "Bitmasks.h"
#import "ParallaxScrolling.h"


@implementation Intel

-(id) init {
    
    if (self == [super init]) {
        
        SKTexture * intelTexture = [SKTexture textureWithImageNamed:@"intel.png"];
        intelTexture.filteringMode = SKTextureFilteringNearest;
        
        self = [Intel spriteNodeWithTexture:intelTexture];
        
        [self setScale:0.05];
        
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.height / 2];
        self.physicsBody.dynamic = YES;
        self.physicsBody.categoryBitMask = intelBitMask;
        self.physicsBody.contactTestBitMask = spaceshipBitMask;
        self.physicsBody.collisionBitMask = 0;
        self.physicsBody.usesPreciseCollisionDetection = YES;
        
        
        // The intelligence pickups must move at the same speed as the scrolling background.
        SKAction *moveIntel = [SKAction moveToY:0 duration:kParallaxBackgroundDefaultSpeed];
        
        SKAction *remove = [SKAction removeFromParent];
        [self runAction:[SKAction sequence:@[moveIntel,remove]]];
        
    }
    return self;
    
}

@end
