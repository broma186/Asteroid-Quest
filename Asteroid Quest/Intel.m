//
//  Intel.m
//  Asteroid Quest
//
//  Created by Matt on 28/07/15.
//  Copyright (c) 2015 Matthew Brooker. All rights reserved.
//

#import "Intel.h"
#import "ParallaxScrolling.h"
#import "Constants.h"


@implementation Intel

-(id) init {
    
    if (self == [super init]) {
        
        SKTexture * intelTexture = [SKTexture textureWithImageNamed:@"intel.png"];
        intelTexture.filteringMode = SKTextureFilteringNearest;
        
        self = [Intel spriteNodeWithTexture:intelTexture];
        
        [self setScale:IMAGE_SCALE];
        
        // The intelligence pickups must move at the same speed as the scrolling background.
        SKAction *moveIntel = [SKAction moveToY:INTEL_MOVE_X duration:INTEL_MOVE_Y];
        moveIntel.speed = kParallaxBackgroundDefaultSpeed;
        
        SKAction *remove = [SKAction removeFromParent];
        [self runAction:[SKAction sequence:@[moveIntel,remove]]];
        
    }
    return self;
    
}

@end
