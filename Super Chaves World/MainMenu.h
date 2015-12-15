//
//  MainMenu.h
//  Super Chaves World
//
//  Created by Superstar on 10/10/15.
//  Copyright Superstar 2015. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// MainMenu
@interface MainMenu : CCLayer
{
    CCMenuItemImage *soundItem;
    CCMenuItemImage *musicItem;
    BOOL sound_flag;
    BOOL music_flag;
}

// returns a CCScene that contains the MainMenu as the only child
+(CCScene *) scene;

@end
