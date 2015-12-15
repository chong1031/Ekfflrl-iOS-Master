//
//  PackPage.m
//  Super Chaves World
//
//  Created by Superstar on 10/12/15.
//  Copyright 2015 Superstar. All rights reserved.
//

#import "PackPage.h"

#import "SelectPage.h"
#import "MainMenu.h"


@implementation PackPage

// Helper class method that creates a Scene with the SelectLayer as the only child.
+(CCScene *) scene
{
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];
    
    // 'layer' is an autorelease object.
    PackPage *layer = [PackPage node];
    
    // add layer as a child to scene
    [scene addChild: layer];
    
    // return the scene
    return scene;
}

-(id) init
{
    if (self = [super init]) {
        
        CGSize size = [CCDirector sharedDirector].winSize;
        
        bgSpr = [CCSprite spriteWithFile:@"game_bg0.png"];
        bgSpr.scaleX = size.width / [bgSpr boundingBox].size.width;
        bgSpr.scaleY = size.height / [bgSpr boundingBox].size.height;
        bgSpr.position = ccp(size.width / 2, size.height / 2);
        
        [self addChild:bgSpr];
        
        // create and initialize the title sprite
        CCSprite *title = [CCSprite spriteWithFile:@"level_pack.png"];
        title.anchorPoint = ccp(0.5f, 1);
        [self setScaleOfNode:title];
        title.position = ccp(size.width / 2, size.height * 0.9f);
        
        [self addChild:title];
        
        // create and initialzie the level items.
        CCMenuItem *level1 = [CCMenuItemImage itemWithNormalImage:@"beginning1.png" selectedImage:@"beginning2.png" target:self selector:@selector(playBeginning)];
        level1.position = ccp(size.width*0.2, size.height*0.5);
        
        CCMenuItem *level2 = [CCMenuItemImage itemWithNormalImage:@"evolution1.png" selectedImage:@"evolution2.png" disabledImage:@"evolution_disable.png" target:self selector:@selector(playEvolution)];
        level2.position = ccp(size.width*0.5, size.height*0.5);
        
        CCMenuItem *level3 = [CCMenuItemImage itemWithNormalImage:@"experience1.png" selectedImage:@"experience2.png" disabledImage:@"experience_disable.png" target:self selector:@selector(playExperiene)];
        level3.position = ccp(size.width*0.8, size.height*0.5);
        
        CCMenuItem *level4 = [CCMenuItemImage itemWithNormalImage:@"expert1.png" selectedImage:@"expert2.png" disabledImage:@"expert_disable.png" target:self selector:@selector(playExpert)];
        level4.position = ccp(size.width*0.3, size.height*0.25);
        
        CCMenuItem *level5 = [CCMenuItemImage itemWithNormalImage:@"professional1.png" selectedImage:@"professional2.png" disabledImage:@"professional_disable.png" target:self selector:@selector(playProfessional)];
        level5.position = ccp(size.width*0.7, size.height*0.25);
        
        CCMenuItemImage *back = [CCMenuItemImage itemWithNormalImage:@"back1.png" selectedImage:@"back2.png" target:self selector:@selector(goBack)];
        back.position = ccp(size.width*0.09, size.height*0.06);
        
        [self setScaleOfNode:level1];
        [self setScaleOfNode:level2];
        [self setScaleOfNode:level3];
        [self setScaleOfNode:level4];
        [self setScaleOfNode:level5];
        [self setScaleOfNode:back];
        
        CCMenu *menu = [CCMenu menuWithItems:level1, level2, level3, level4, level5, back, nil];
        menu.position = CGPointZero;
        [self addChild:menu];
        
        int current_level = 0;
        
        switch (current_level) {
            case 0:
                [level2 setIsEnabled:FALSE];
                [level3 setIsEnabled:FALSE];
                [level4 setIsEnabled:FALSE];
                [level5 setIsEnabled:FALSE];
                break;
                
            default:
                break;
        }
    }
    
    return self;
}

-(void) playBeginning
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0f scene:[SelectPage scene]]];
}

-(void) playEvolution
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0f scene:[SelectPage scene]]];
}

-(void) playExperiene
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0f scene:[SelectPage scene]]];
}

-(void) playExpert
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0f scene:[SelectPage scene]]];
}

-(void) playProfessional
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0f scene:[SelectPage scene]]];
}

-(void) goBack
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0f scene:[MainMenu scene]]];
}

-(void) setScaleOfNode:(CCNode *)spr
{
    spr.scaleX = bgSpr.scaleX;
    spr.scaleY = bgSpr.scaleY;
}

@end
