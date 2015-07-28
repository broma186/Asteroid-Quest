//
//  Asteroid.h
//  SpaceMission
//
//  Created by Matt on 3/06/15.
//  Copyright (c) 2015 Matthew Brooker. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>


@interface Asteroid : SKSpriteNode {
    int randDuration;
    CGFloat randSpin;
}


-(id) initWithType: (int) type;


@end
