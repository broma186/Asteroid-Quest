//
// ParallaxScrolling.h
//
// Asteroid Quest
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


#import <SpriteKit/SpriteKit.h>

#define kParallaxBackgroundDefaultSpeedDifferential 0.90
#define kParallaxBackgroundDefaultSpeed 2

typedef enum {
    kParallaxBackgroundDirectionUp = 0,
    kParallaxBackgroundDirectionDown,
    kParallaxBackgroundDirectionRight,
    kParallaxBackgroundDirectionLeft
} ParallaxBackgroundDirection;

@interface ParallaxScrolling : SKSpriteNode


- (id) initWithBackgrounds: (NSArray *) backgrounds size: (CGSize) size direction: (ParallaxBackgroundDirection) direction fastestSpeed: (CGFloat) speed andSpeedDecrease: (CGFloat) differential;

/** This method, called once in every game loop, will adjust the relative position of the nodes in the parallax background set */
- (void) update: (NSTimeInterval) currentTime;


/** Debug method for watching the positions of the backgrounds at a given time. */
- (void) showBackgroundPositions;

@end