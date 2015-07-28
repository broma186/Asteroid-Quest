//
//  Math.m
//  SpaceMission
//
//  Created by Matt on 3/06/15.
//  Copyright (c) 2015 Matthew Brooker. All rights reserved.
//

#import "Math.h"

@implementation Math


- (int)randIntValBetweenMin:(int) min Max:(int) max
{
     return ((arc4random() % (max-min+1)) + min);
}

- (CGFloat)randFloatValBetweenMin:(CGFloat)min Max:(CGFloat)max
{
    CGFloat diff = max - min;
    return (((CGFloat) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + min;
}

@end
