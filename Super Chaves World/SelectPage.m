//
//  SelectPage.m
//  Super Chaves World
//
//  Created by Superstar on 10/12/15.
//  Copyright 2015 Superstar. All rights reserved.
//

#import "SelectPage.h"

#import "PackPage.h"
#import "GameLayer.h"
#import "AppDelegate.h"

#import "test/GameLevelLayer.h"

@implementation SelectPage

// Helper class method that creates a Scene with the SelectLayer as the only child.
+(CCScene *) scene
{
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];
    
    // 'layer' is an autorelease object.
    SelectPage *layer = [SelectPage node];
    
    // add layer as a child to scene
    [scene addChild: layer];
    
    // return the scene
    return scene;
}

-(id) init
{
    if (self = [super init]) {
        
        size = [CCDirector sharedDirector].winSize;
        
        CCSprite *bgSpr = [CCSprite spriteWithFile:@"game_bg0.png"];
        bgSpr.scaleX = size.width / [bgSpr boundingBox].size.width;
        bgSpr.scaleY = size.height / [bgSpr boundingBox].size.height;
        bgSpr.position = ccp(size.width / 2, size.height / 2);
        
        [self addChild:bgSpr];
        

        // create and initialize the title spite.
        CCSprite *title = [CCSprite spriteWithFile:@"level_select.png"];
        title.scaleX = bgSpr.scaleX;
        title.scaleY = bgSpr.scaleY;
        title.anchorPoint = ccp(0.5f, 1);
        title.position = ccp(size.width*0.5, size.height * 0.9);
        
        [self addChild:title];
        
        currentStage = 1;
        maxStage = 20;
        
        levelSpr = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%d.png", currentStage%10]];
        [self addChild:levelSpr];

        levelSpr10 = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%d.png", currentStage/10]];
        levelSpr10.position = ccp(size.width/2 - [levelSpr10 boundingBox].size.width/2, size.height / 2);
        [self addChild:levelSpr10];

        if (currentStage > 10) {
            levelSpr.position = ccp(size.width / 2 + [levelSpr boundingBox].size.width/2, size.height / 2);
            levelSpr10.position = ccp(size.width/2 - [levelSpr10 boundingBox].size.width/2, size.height / 2);
        } else {
            levelSpr.position = ccp(size.width / 2, size.height / 2);
            levelSpr10.visible = NO;
        }
        
        decrease = [CCMenuItemImage itemWithNormalImage:@"arrow1.png" selectedImage:@"arrow2.png" target:self selector:@selector(onDecrease)];
        decrease.position = ccp(size.width / 2 - [decrease boundingBox].size.width/3*4, size.height / 2);
        decrease.scaleX = bgSpr.scaleX;
        decrease.scaleY = bgSpr.scaleY;
        
        increase = [CCMenuItemImage itemWithNormalImage:@"arrow1.png" selectedImage:@"arrow2.png" target:self selector:@selector(onIncrease)];
        increase.position = ccp(size.width / 2 + [increase boundingBox].size.width/3*4, size.height / 2);
        increase.scaleX = -1 * bgSpr.scaleX;
        increase.scaleY = -1 * bgSpr.scaleY;
        
        CCMenuItemImage *startItem = [CCMenuItemImage itemWithNormalImage:@"start1.png" selectedImage:@"start2.png" target:self selector:@selector(startGame)];
        startItem.position = ccp(size.width * 0.5f, size.height * 0.3f);
        startItem.scaleX = bgSpr.scaleX;
        startItem.scaleY = bgSpr.scaleY;
        
        CCMenuItem *backItem = [CCMenuItemImage itemWithNormalImage:@"back1.png" selectedImage:@"back2.png" target:self selector:@selector(backPackPage)];
        backItem.position = ccp(size.width * 0.09, size.height * 0.06);
        
        CCMenu *menu = [CCMenu menuWithItems:decrease, increase, startItem, backItem, nil];
        menu.position = CGPointZero;
        [self addChild:menu];
    }
    
    return self;
}

-(void) onDecrease
{
    if (currentStage > 1) {
        [self setLevel:(currentStage-1)];
    }
}

-(void) onIncrease
{
    if (currentStage < maxStage) {
        [self setLevel:(currentStage+1)];
    }
}

-(void) startGame
{
//    GameLayer *gameLayer = [GameLayer initWithInfo:3 LevelInfo:3 MusicSelect:FALSE];
    AppController *delegate = [[UIApplication sharedApplication] delegate];
    delegate.levelMode = 0;
    delegate.level = 1;
    delegate.gameMusic = FALSE;
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.7f scene:[GameLayer scene]]];
//    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.7f scene:[GameLevelLayer scene]]];
}

-(void) backPackPage
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[PackPage scene]]];
}

-(void) setLevel:(int)stage
{
    currentStage = stage;
    if (currentStage >= 10) {
        levelSpr10.visible = YES;
        levelSpr.position = ccp(size.width / 2 + [levelSpr boundingBox].size.width/2, size.height / 2);
    } else if (currentStage < 10) {
        levelSpr10.visible = NO;
    }
    [decrease setOpacity:(currentStage > 1 ? 255:128)];
    [decrease setIsEnabled:(currentStage > 1)];
    [increase setOpacity:(currentStage < maxStage ? 255:128)];
    [increase setIsEnabled:(currentStage < maxStage)];
    [levelSpr setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%d.png", stage%10]]];
    [levelSpr10 setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%d.png", stage/10]]];
}

@end
