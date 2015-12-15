//
//  PackPage.h
//  Super Chaves World
//
//  Created by Superstar on 10/12/15.
//  Copyright 2015 Superstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface PackPage : CCLayer {
    CCSprite *bgSpr;
}

// returns a CCScene that contains the MainMenu as the only child
+(CCScene *) scene;

-(void) setScaleOfNode:(CCNode *) spr;


@end
