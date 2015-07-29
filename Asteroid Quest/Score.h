//
//  Score.h
//  SpaceMission
//
//  Created by Matt on 3/06/15.
//  Copyright (c) 2015 Matthew Brooker. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBestScoreKey @"BestScore"

@interface Score : NSObject

+ (void) registerScore:(NSInteger) score;
+ (void) setBestScore:(NSInteger) bestScore;
+ (NSInteger) bestScore;

@end
