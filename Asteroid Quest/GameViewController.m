//
//  GameViewController.m
//  Asteroid Quest
//
//  Created by Matt on 28/07/15.
//  Copyright (c) 2015 Matthew Brooker. All rights reserved.
//

#import "GameViewController.h"


@interface GameViewController ()

@property (strong, nonatomic) IBOutlet SKView *gameView;
@property (strong, nonatomic) UIImageView *destroyedView;
@property (strong, nonatomic) UIImageView *startGameView;
@property (strong, nonatomic) UILabel *yourScore;
@property (strong, nonatomic) UILabel *topScore;



@end

@implementation GameViewController
{
    SpaceScene * scene;
    Sound *_spaceshipSound;
  

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
     _destroyedView.alpha = 0;
    [self.gameView presentScene:scene];
    
    # pragma mark - Sound
    
    _spaceshipSound = [Sound soundNamed:[NSString stringWithFormat:@"%@/Sound/spaceship_loop.caf", [[NSBundle mainBundle] resourcePath]]];
    _spaceshipSound.looping = YES;
    
    // Start view
    
    _startGameView =  [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    [_startGameView setImage:[UIImage imageNamed:@"startGameView.png"]];
    [_startGameView setUserInteractionEnabled:NO];
     _startGameView.translatesAutoresizingMaskIntoConstraints = NO;
    [_gameView addSubview: _startGameView];
    
    // Constraints for start game view.
    
    // Equal heights and width for start view, so box is the same size regardless of device.
    [_startGameView addConstraint:[NSLayoutConstraint constraintWithItem:_startGameView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:300]];
    [_startGameView addConstraint:[NSLayoutConstraint constraintWithItem:_startGameView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:300]];
    
    // Center start view in main game view.
    [self.gameView addConstraint:[NSLayoutConstraint constraintWithItem:_startGameView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.gameView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self.gameView addConstraint:[NSLayoutConstraint constraintWithItem:_startGameView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.gameView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    // Game over/destroyed view.
    _destroyedView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    [_destroyedView setImage:[UIImage imageNamed:@"destroyedView.png"]];
    [_destroyedView setUserInteractionEnabled:NO];
    _destroyedView.translatesAutoresizingMaskIntoConstraints = NO;
    [_gameView addSubview: _destroyedView];
    _destroyedView.alpha = 0;
    
    // Constraints for game over view.
    
    // Equal heights and width for game over view, so box is the same size regardless of device.
    [_destroyedView addConstraint:[NSLayoutConstraint constraintWithItem:_destroyedView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:300]];
    [_destroyedView addConstraint:[NSLayoutConstraint constraintWithItem:_destroyedView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:300]];
    
      // Center game over view in main game view.
    [self.gameView addConstraint:[NSLayoutConstraint constraintWithItem:_destroyedView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.gameView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self.gameView addConstraint:[NSLayoutConstraint constraintWithItem:_destroyedView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.gameView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];


     UIFont * customFont = [UIFont fontWithName:@"Cubellan" size:20];

    
    _yourScore = [[UILabel alloc] initWithFrame: CGRectMake(_destroyedView.frame.size.width/2 + 40, _destroyedView.frame.size.height/2 - 13, 0, 0)];
    _yourScore.text =  @"0000";
     _yourScore.font = customFont;
    [_yourScore sizeToFit];
    _yourScore.backgroundColor = [UIColor clearColor];
    _yourScore.textColor = [UIColor whiteColor];
    _yourScore.userInteractionEnabled = NO;
   
    [_destroyedView addSubview:_yourScore];
    
   
    
    _topScore = [[UILabel alloc] initWithFrame:CGRectMake(_yourScore.frame.origin.x, _yourScore.frame.origin.y + 37, 0, 0)];
     _topScore.text = @"0000";
     _topScore.font = customFont;
    [_topScore sizeToFit];
    _topScore.backgroundColor = [UIColor clearColor];
    _topScore.textColor = [UIColor whiteColor];
    _topScore.userInteractionEnabled = NO;
    
    [_destroyedView addSubview:_topScore];
    
}



- (void) gameStart
{
    [UIView animateWithDuration:.2 animations:^{
        
        _destroyedView.alpha = 0;
        _destroyedView.transform = CGAffineTransformMakeScale(.8, .8);
        
        _startGameView.alpha = 1;
    }];
}

- (void) gamePlay
{
    [_spaceshipSound play];
    [_spaceshipSound fadeIn:1.0];
   
    [UIView animateWithDuration:.5 animations:^{
        _startGameView.alpha = 0;
    }];
}

- (void) spaceshipDestroyed
{
    // Fade out sound
    
    [_spaceshipSound fadeOut:1.0];
    
    [UIView animateWithDuration:.9 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
       
     _destroyedView.alpha = 1;
     _destroyedView.transform = CGAffineTransformMakeScale(1, 1);
        
    _yourScore.text = [NSString stringWithFormat:@"%d",(int)scene.score];
    _topScore.text = [NSString stringWithFormat:@"%d",(int)[Score bestScore]];

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
