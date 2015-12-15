//
//  MainMenu.m
//  Super Chaves World
//
//  Created by Superstar on 10/10/15.
//  Copyright Superstar 2015. All rights reserved.
//


// Import the interfaces
#import "MainMenu.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "PackPage.h"
#import "Define.h"

#pragma mark - MainMenu

// MainMenu implementation
@implementation MainMenu

// Helper class method that creates a Scene with the MainMenu as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainMenu *layer = [MainMenu node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
	
        // get the window size.
        CGSize size = [CCDirector sharedDirector].winSize;
        
        sound_flag = true;
        music_flag = true;
        
        // create and initialize the main background.
        CCSprite *main_back = [CCSprite spriteWithFile:@"game_bg0.png"];
        main_back.scaleX = size.width / [main_back boundingBox].size.width;
        main_back.scaleY = size.height / [main_back boundingBox].size.height;
        main_back.position = ccp(size.width / 2, size.height / 2);
        
        [self addChild:main_back];
        
        // create and initialize the titel sprite.
        CCSprite *title_spr = [CCSprite spriteWithFile:@"title.png"];
        title_spr.scale = main_back.scaleY;
        title_spr.position = ccp(size.width*0.47f, size.height*0.83f);
        
        [self addChild:title_spr];

        CCSprite *bird_spr = [CCSprite spriteWithFile:@"bird.png"];
        bird_spr.scaleX= main_back.scaleX;
        bird_spr.scaleY= main_back.scaleY;
        bird_spr.anchorPoint = ccp(0, 0);
        
        [self addChild:bird_spr];
        
        // Create and initialize the buttoms.
        //  ----- MoreGame Button ----------
        CCMenuItem *moreItem1 = [CCMenuItemImage itemWithNormalImage:@"more.png" selectedImage:@"more1.png" target:self selector:@selector(goMoreGame)];
        moreItem1.scale = main_back.scaleY;
        moreItem1.anchorPoint = ccp(0.5f, 0);
        moreItem1.position = ccp(size.width*0.4f, size.height*0.18f);

        //  ----- Leaderboard Button ----------
        CCMenuItemImage *leaderboardItem = [CCMenuItemImage itemWithNormalImage:@"leaderboard.png"
                                                                  selectedImage:@"leaderboard_clicked.png"
                                                                         target:self
                                                                       selector:@selector(goLeaderboard)];
        leaderboardItem.scale = main_back.scaleY;
        leaderboardItem.anchorPoint = ccp(0.5f, 0);
        leaderboardItem.position = ccp(size.width*0.5f, size.height*0.18f);
        
        //  ----- Sound Button ----------
        soundItem = [CCMenuItemImage itemWithNormalImage:@"sound_on.png"
                                           selectedImage:@"sound_on.png"
                                                  target:self
                                                selector:@selector(onSound)];
        soundItem.scale = main_back.scaleY;
        soundItem.position = ccp(size.width*0.4f, size.height*0.09f);
        
        //  ----- Music Button ----------
        musicItem = [CCMenuItemImage itemWithNormalImage:@"music_on.png"
                                           selectedImage:@"music_on.png"
                                                  target:self
                                                selector:@selector(onMusic)];
        musicItem.scale = main_back.scaleY;
        musicItem.position = ccp(size.width*0.5f, size.height*0.09f);
        
        //  ----- MoreGame2 Button ----------
        CCMenuItem *moreItem2 = [CCMenuItemImage itemWithNormalImage:@"more2.png"
                                                       selectedImage:@"more2.png"
                                                              target:self
                                                            selector:@selector(goLeaderboard)];
        moreItem2.scale = main_back.scaleY;
        moreItem2.anchorPoint = ccp(0.5f, 0);
        moreItem2.position = ccp(size.width*0.6f, size.height*0.18f);

        //  ----- Play Button ----------
        CCMenuItem *playItem = [CCMenuItemImage itemWithNormalImage:@"play1.png"
                                                      selectedImage:@"play2.png"
                                                             target:self
                                                           selector:@selector(gamePlay)];
        playItem.scale = main_back.scaleY;
        playItem.anchorPoint = ccp(1, 0);
        playItem.position = ccp(size.width, 0);
        
        CCMenu *buttonMenu = [CCMenu menuWithItems:moreItem1,
                              leaderboardItem,
                              soundItem,
                              musicItem,
                              moreItem2,
                              playItem,
                              nil];
        buttonMenu.position = CGPointZero;
        
        [self addChild:buttonMenu];
        
	}
    
	return self;
}

-(void) gamePlay
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.7f scene:[PackPage scene]]];
}

-(void) goMoreGame
{
    
}

-(void) goLeaderboard
{
    
}

-(void) onSound
{
    if (sound_flag) {
        [soundItem setNormalImage:[CCSprite spriteWithFile:@"sound_off.png"]];
        sound_flag = FALSE;
        
    } else {
        [soundItem setNormalImage:[CCSprite spriteWithFile:@"sound_on.png"]];
        sound_flag = TRUE;
        
    }
}

-(void) onMusic
{
    if (music_flag) {
        [musicItem setNormalImage:[CCSprite spriteWithFile:@"music_off.png"]];
        music_flag = FALSE;
        
    } else {
        [musicItem setNormalImage:[CCSprite spriteWithFile:@"music_on.png"]];
        music_flag = TRUE;
    }
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
