//
//  Explosion.m
//  SpaceMission
//
//  Created by Matt on 3/06/15.
//  Copyright (c) 2015 Matthew Brooker. All rights reserved.
//

#import "Explosion.h"

@implementation Explosion

-(id) init {
    
    if (self == [super init]) {
        
        SKTexture * explosion1 = [SKTexture textureWithImageNamed:@"explosion1"];
        explosion1.filteringMode = SKTextureFilteringNearest;
        
        SKTexture * explosion2 = [SKTexture textureWithImageNamed:@"explosion2"];
        explosion2.filteringMode = SKTextureFilteringNearest;
        
        SKTexture * explosion3 = [SKTexture textureWithImageNamed:@"explosion3"];
        explosion3.filteringMode = SKTextureFilteringNearest;
        
        SKTexture * explosion4 = [SKTexture textureWithImageNamed:@"explosion4"];
        explosion4.filteringMode = SKTextureFilteringNearest;
        
        SKTexture * explosion5 = [SKTexture textureWithImageNamed:@"explosion5"];
        explosion5.filteringMode = SKTextureFilteringNearest;
        
        SKTexture * explosion6 = [SKTexture textureWithImageNamed:@"explosion6"];
        explosion6.filteringMode = SKTextureFilteringNearest;
        
        SKTexture * explosion7 = [SKTexture textureWithImageNamed:@"explosion7"];
        explosion7.filteringMode = SKTextureFilteringNearest;
        
        SKTexture * explosion8 = [SKTexture textureWithImageNamed:@"explosion8"];
        explosion8.filteringMode = SKTextureFilteringNearest;
        
        SKTexture * explosion9 = [SKTexture textureWithImageNamed:@"explosion9"];
        explosion9.filteringMode = SKTextureFilteringNearest;
        
        SKTexture * explosion10 = [SKTexture textureWithImageNamed:@"explosion10"];
        explosion10.filteringMode = SKTextureFilteringNearest;
        
        SKTexture * explosion11 = [SKTexture textureWithImageNamed:@"explosion11"];
        explosion11.filteringMode = SKTextureFilteringNearest;
        
        SKTexture * explosion12 = [SKTexture textureWithImageNamed:@"explosion12"];
        explosion12.filteringMode = SKTextureFilteringNearest;
        
        SKTexture * explosion13 = [SKTexture textureWithImageNamed:@"explosion13"];
        explosion13.filteringMode = SKTextureFilteringNearest;
        
        self = [Explosion spriteNodeWithTexture:explosion1];
        
        SKAction *explode = [SKAction animateWithTextures:@[explosion1, explosion2,
                                                            explosion3, explosion4, explosion5, explosion6, explosion7, explosion8,explosion9, explosion10, explosion11, explosion12, explosion13] timePerFrame:0.05];
        
        SKAction *remove = [SKAction removeFromParent];
        [self runAction:[SKAction sequence:@[explode,remove]]];
        
      
       
    }
    
    return self;
}



@end
