//
//  SelectPage.h
//  Super Chaves World
//
//  Created by Superstar on 10/12/15.
//  Copyright 2015 Superstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SelectPage : CCLayer {
    
    CCLabelAtlas *levelLabel;
    CCMenuItemImage *decrease;
    CCMenuItemImage *increase;
    CCSprite *levelSpr;
    CCSprite *levelSpr10;
    
    CGSize size;
    int currentStage;
    int maxStage;
}


@property (assign, nonatomic) NSInteger *interage;

+(CCScene *) scene;
-(void) setLevel:(int) stage;

@end
