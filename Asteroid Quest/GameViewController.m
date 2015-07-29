//
//  GameViewController.m
//  Asteroid Quest
//
//  Created by Matt on 28/07/15.
//  Copyright (c) 2015 Matthew Brooker. All rights reserved.
//

#import "GameViewController.h"
#import "SpaceScene.h"
#import "Score.h"

@interface GameViewController ()

@end

@implementation GameViewController
{
    SpaceScene * scene;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *) self.view;
    if ([skView.scene isKindOfClass:[SpaceScene class]]) {
        SpaceScene *spaceScene = (SpaceScene *) skView.scene;
        spaceScene.direction = self.direction;
    }
}

- (void)viewWillLayoutSubviews
{
    
    [super viewWillLayoutSubviews];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    
    if (!skView.scene) {
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        
        // Create and configure the scene.
        SKScene * spaceScene = [[SpaceScene alloc] initWithSize:skView.bounds.size];
        spaceScene.scaleMode = SKSceneScaleModeAspectFill;
        spaceScene.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:scene.frame];
        
        // Present the scene.
        [skView presentScene:spaceScene];
    }
}

- (void) eventStart
{
    
}

- (void) eventPlay
{
    
}

- (void) eventDestroyed
{
    
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
