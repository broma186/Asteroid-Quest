//
//  GameScene.h
//  Asteroid Quest
//

//  Copyright (c) 2015 Matthew Brooker. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ParallaxScrolling.h"

@protocol SceneDelegate <NSObject>
- (void) eventStart;
- (void) eventPlay;
- (void) eventDestroyed;
@end

@interface SpaceScene : SKScene<SKPhysicsContactDelegate>


@property (nonatomic) ParallaxBackgroundDirection direction;
@property (nonatomic) NSInteger score;

- (void) startGame;

@end
