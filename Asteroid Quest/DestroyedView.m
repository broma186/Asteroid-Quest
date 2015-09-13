//
//  destroyedView.m
//  Asteroid Quest
//
//  Created by Matt on 22/08/15.
//  Copyright © 2015 Matthew Brooker. All rights reserved.
//


#import "DestroyedView.h"

@interface DestroyedView()

@property (strong, nonatomic) UILabel *yourScore;
@property (strong, nonatomic) UILabel *topScore;


@end


@implementation DestroyedView {
    
    SpaceScene *scene;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
     
    }
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    

    // Score achieved after destruction.
    
    _yourScore = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 70, self.frame.size.height - 170, 30, 30)];
   
    _yourScore.font = [UIFont fontWithName:@"Charlie_Brown_M54" size:20];
    _yourScore.text = @"0";
    _yourScore.textColor = [UIColor whiteColor];
    _yourScore.userInteractionEnabled = NO;
    [self addSubview:_yourScore];
    
    // Top score this session.
    
    _topScore = [[UILabel alloc] initWithFrame:CGRectMake(_yourScore.frame.origin.x, _yourScore.frame.origin.y + 45, 30, 30)];
    _topScore.font = [UIFont fontWithName:@"Charlie_Brown_M54" size:20];
    _topScore.text = @"0";
    _topScore.textColor = [UIColor whiteColor];
    _topScore.userInteractionEnabled = NO;
    [self addSubview:_topScore];
    
    
}


- (void)setYourScoreLabel:(NSString *)yourScore topScoreLabel:(NSString *)topScore {
    _yourScore.text = yourScore;
    _topScore.text = topScore;
}




@end
