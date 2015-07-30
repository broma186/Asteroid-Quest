//
//  GameViewController.h
//  Asteroid Quest
//

//  Copyright (c) 2015 Matthew Brooker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "SpaceScene.h"

@interface GameViewController : UIViewController<SceneDelegate>

@property (nonatomic) ParallaxBackgroundDirection direction;

@end