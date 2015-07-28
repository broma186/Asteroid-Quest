//
//  ParallaxScrolling.h
//
//  SpaceMission
//


#import <SpriteKit/SpriteKit.h>

#define kParallaxBackgroundDefaultSpeedDifferential 0.90
#define kParallaxBackgroundDefaultSpeed 2

typedef enum {
    kParallaxBackgroundDirectionUp = 0,
    kParallaxBackgroundDirectionDown,
    kParallaxBackgroundDirectionRight,
    kParallaxBackgroundDirectionLeft
} ParallaxBackgroundDirection;

@interface ParallaxScrolling : SKSpriteNode


- (id) initWithBackgrounds: (NSArray *) backgrounds size: (CGSize) size direction: (ParallaxBackgroundDirection) direction fastestSpeed: (CGFloat) speed andSpeedDecrease: (CGFloat) differential;

/** This method, called once in every game loop, will adjust the relative position of the nodes in the parallax background set */
- (void) update: (NSTimeInterval) currentTime;

/** reverse the direction of the movement, left->right, right->left, up->down, down->up */
- (void) reverseMovementDirection;

/** Debug method for watching the positions of the backgrounds at a given time. */
- (void) showBackgroundPositions;

@end