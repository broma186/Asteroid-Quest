//
//
//
// PBParallaxBackground.m (was called PBParallaxBackground.m before reuse).
//
// The MIT License (MIT)
//
// Copyright (c) 2013 Ignacio Nieto Carvajal
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so.


#import "ParallaxScrolling.h"

#define kParallaxBackgroundAntiFlickeringAdjustment 0.05

static inline CGFloat roundFloatToTwoDecimalPlaces(CGFloat num) { return floorf(num * 100 + 0.5) / 100; }

@interface ParallaxScrolling ()

/** The array containing the set of SKSpriteNode nodes representing the different backgrounds */
@property (nonatomic, strong) NSArray * backgrounds;

/** The array containing the set of duplicated background nodes that will appear when the background starts sliding out of the screen */
@property (nonatomic, strong) NSArray * clonedBackgrounds;

/** The array of speeds for every background */
@property (nonatomic, strong) NSArray * speeds;

/** Number of backgrounds in this parallax background set */
@property (nonatomic) NSUInteger numberOfBackgrounds;

/** The movement direction of the parallax backgrounds */
@property (nonatomic) ParallaxBackgroundDirection direction;

/** The size of the parallax background set */
@property (nonatomic) CGSize size;

@end

@implementation ParallaxScrolling
- (id) initWithBackgrounds: (NSArray *) backgrounds size: (CGSize) size direction: (ParallaxBackgroundDirection) direction fastestSpeed: (CGFloat) speed andSpeedDecrease: (CGFloat) differential {
    self = [super init];
    if (self) {
        // initialization
        self.numberOfBackgrounds = 0;
        self.direction = direction;
        self.position = CGPointMake(size.width / 2, size.height / 2);
        self.zPosition = -100;
        // sanity checks
        if (speed < 0) speed = -speed;
        if (differential < 0 || differential > 1) differential = kParallaxBackgroundDefaultSpeedDifferential; // sanity check
        // initialize backgrounds
        CGFloat zPos = 1.0f / backgrounds.count;
        NSUInteger bgNumber = 0;
        NSMutableArray * bgs = [NSMutableArray array];
        NSMutableArray * cBgs = [NSMutableArray array];
        NSMutableArray * spds = [NSMutableArray array];
        CGFloat currentSpeed = roundFloatToTwoDecimalPlaces(speed);
        
        for (id obj in backgrounds) {
            // determine the type of background
            SKSpriteNode * node = nil;
            if ([obj isKindOfClass:[UIImage class]]) {
                node = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImage:(UIImage *) obj]];
            } else if ([obj isKindOfClass:[NSString class]]) {
                node = [[SKSpriteNode alloc] initWithImageNamed:(NSString *) obj];
            } else if ([obj isKindOfClass:[SKTexture class]]) {
                node = [[SKSpriteNode alloc] initWithTexture:(SKTexture *) obj];
            } else if ([obj isKindOfClass:[SKSpriteNode class]]) {
                node = (SKSpriteNode *) obj;
            } else continue;
            // create the duplicate and insert both at their proper locations.
            node.zPosition = self.zPosition - (zPos + (zPos * bgNumber));
            node.position = CGPointMake(0, self.size.height);
            SKSpriteNode * clonedNode = [node copy];
            CGFloat clonedPosX = node.position.x, clonedPosY = node.position.y;
            switch (direction) { // calculate clone's position
                case kParallaxBackgroundDirectionUp:
                    clonedPosY = - node.size.height;
                    break;
                case kParallaxBackgroundDirectionDown:
                    clonedPosY = node.size.height;
                    break;
                case kParallaxBackgroundDirectionRight:
                    clonedPosX = - node.size.width;
                    break;
                case kParallaxBackgroundDirectionLeft:
                    clonedPosX = node.size.width;
                    break;
                default:
                    break;
            }
            clonedNode.position = CGPointMake(clonedPosX, clonedPosY);
            // add nodes to their arrays
            [bgs addObject:node];
            [cBgs addObject:clonedNode];
            // add the velocity for this node and adjust the next current velocity.
            [spds addObject:[NSNumber numberWithFloat:currentSpeed]];
            currentSpeed = roundFloatToTwoDecimalPlaces(currentSpeed / (1 + differential));
            // add to the scene
            [self addChild:node];
            [self addChild:clonedNode];
            // next background
            bgNumber++;
        }
        // did we find some valid backgrounds?
        if (bgNumber > 0) {
            self.numberOfBackgrounds = bgNumber;
            self.backgrounds = [bgs copy];
            self.clonedBackgrounds = [cBgs copy];
            self.speeds = [spds copy];
        } else { NSLog(@"Unable to find any valid backgrounds for parallax scrolling."); return nil; }
    }
    return self;
}
- (void) update:(NSTimeInterval)currentTime {
    for (NSUInteger i = 0; i < self.numberOfBackgrounds; i++) {
        // determine the speed of each node
        CGFloat speed = [[self.speeds objectAtIndex:i] floatValue];
        // adjust positions
        SKSpriteNode * bg = [self.backgrounds objectAtIndex:i];
        SKSpriteNode * cBg = [self.clonedBackgrounds objectAtIndex:i];
        CGFloat newBgX = bg.position.x, newBgY = bg.position.y, newCbgX = cBg.position.x, newCbgY = cBg.position.y;
        // position depends on direction.
        switch (self.direction) {
            case kParallaxBackgroundDirectionUp:
                newBgY += speed;
                newCbgY += speed;
                if (newBgY >= bg.size.height) newBgY = newCbgY - cBg.size.height + kParallaxBackgroundAntiFlickeringAdjustment;
                if (newCbgY >= cBg.size.height) newCbgY = newBgY - bg.size.height + kParallaxBackgroundAntiFlickeringAdjustment;
                break;
            case kParallaxBackgroundDirectionDown:
                newBgY -= speed;
                newCbgY -= speed;
                if (newBgY <= -bg.size.height) newBgY = newCbgY + cBg.size.height - kParallaxBackgroundAntiFlickeringAdjustment;
                if (newCbgY <= -bg.size.height) newCbgY = newBgY + bg.size.height - kParallaxBackgroundAntiFlickeringAdjustment;
                break;
            case kParallaxBackgroundDirectionRight:
                newBgX += speed;
                newCbgX += speed;
                if (newBgX >= bg.size.width) newBgX = newCbgX - cBg.size.width + kParallaxBackgroundAntiFlickeringAdjustment;
                if (newCbgX >= cBg.size.width) newCbgX = newBgX - bg.size.width + kParallaxBackgroundAntiFlickeringAdjustment;
                break;
            case kParallaxBackgroundDirectionLeft:
                newBgX = newBgX - speed;
                newCbgX = newCbgX - speed;
                if (newBgX <= -bg.size.width) newBgX = newCbgX + cBg.size.width - kParallaxBackgroundAntiFlickeringAdjustment;
                if (newCbgX <= -cBg.size.width) newCbgX = newBgX + bg.size.width - kParallaxBackgroundAntiFlickeringAdjustment;
                break;
            default:
                break;
        }
        // update positions with the right coordinates.
        bg.position = CGPointMake(newBgX, newBgY);
        cBg.position = CGPointMake(newCbgX, newCbgY);
    }
}


- (void) showBackgroundPositions {
    NSLog(@"Parallax background state:");
    for (unsigned int i = 0; i < self.numberOfBackgrounds; i++) {
        // determine the speed of each node
        CGFloat speed = [[self.speeds objectAtIndex:i] floatValue];
        // adjust positions
        SKSpriteNode * bg = [self.backgrounds objectAtIndex:i];
        SKSpriteNode * cBg = [self.clonedBackgrounds objectAtIndex:i];
        NSLog(@"Layer %ul: background1 at (%f, %f), background2 at (%f, %f), speed: %f", i, bg.position.x,bg.position.y, cBg.position.x, cBg.position.y, speed);
    }
}
@end