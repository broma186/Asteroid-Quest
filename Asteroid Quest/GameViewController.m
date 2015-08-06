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

@property (strong, nonatomic) IBOutlet SKView *gameView;
@property (strong, nonatomic) IBOutlet UIView *startGameView;
@property (strong, nonatomic) IBOutlet UILabel *startDescription;

@property (strong, nonatomic) IBOutlet UIView *destroyedView;
@property (strong, nonatomic) IBOutlet UILabel *yourScore;
@property (strong, nonatomic) IBOutlet UILabel *topScore;




@end

@implementation GameViewController
{
    SpaceScene * scene;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    // Create and configure the scene.
    scene = [SpaceScene sceneWithSize:self.gameView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.delegate = self;
    
    // Present the scene
    self.destroyedView.alpha = 0;
    self.destroyedView.transform = CGAffineTransformMakeScale(.9, .9);
    [self.gameView presentScene:scene];
    
}

/* This method is implemented to customize the start game description label
   programmatically. */

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.startDescription.text = @"Shoot the asteroids and collect intel to score!\nAvoid the asteroids or be destroyed.\n\nShoot asteroid - 1 Point\n\nCollect intel - 2 Points";
    
    self.startDescription.font = [UIFont systemFontOfSize:14];
    
    self.startDescription.lineBreakMode = NSLineBreakByWordWrapping;
    self.startDescription.numberOfLines = 0;
}


- (void) gameStart
{
    [UIView animateWithDuration:.2 animations:^{
        
        self.destroyedView.alpha = 0;
        self.destroyedView.transform = CGAffineTransformMakeScale(.8, .8);
        
        self.startGameView.alpha = 1;
       
    }completion:^(BOOL finished) {
           NSLog(@"game started");
    }];
}

- (void) gamePlay
{
    [UIView animateWithDuration:.5 animations:^{
        self.startGameView.alpha = 0;
   
    }];
}

- (void) spaceshipDestroyed
{

    
    [UIView animateWithDuration:.9 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
     self.destroyedView.alpha = 1;
     self.destroyedView.transform = CGAffineTransformMakeScale(1, 1);
     
     self.yourScore.text = [NSString stringWithFormat:@"%d",(int)scene.score];
     self.topScore.text = [NSString stringWithFormat:@"%d",(int)[Score bestScore]];
     
    }
     
    completion:^(BOOL finished) {
        NSLog(@"Game over menu reached");
    }];
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
