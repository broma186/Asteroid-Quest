//
//  destroyedView.h
//  Asteroid Quest
//
//  Created by Matt on 22/08/15.
//  Copyright © 2015 Matthew Brooker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Score.h"
#import "SpaceScene.h"

@interface DestroyedView : UIImageView

- (void) setYourScoreLabel: (NSString*) yourScore topScoreLabel:(NSString*) topScore;


@end
