//
//  GameScene.h
//  Asteroid Quest
//

//  Copyright (c) 2015 Matthew Brooker. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>



@protocol SceneDelegate <NSObject>
- (void) gameStart;
- (void) gamePlay;
- (void) spaceshipDestroyed;
@end

@interface SpaceScene : SKScene<SKPhysicsContactDelegate>

@property (unsafe_unretained,nonatomic) id<SceneDelegate> delegate;
@property (nonatomic) NSInteger score;

- (void) startGame;

@end
