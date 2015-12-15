//
//  AppDelegate.h
//  TileMap
//
//  Created by Ricky on 11/7/12.
//  Copyright meetgame 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

// Added only for iOS 6 support
@interface MyNavigationController : UINavigationController <CCDirectorDelegate>
@end

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate>
{
	UIWindow *window_;
	UINavigationController *navController_;

	CCDirectorIOS	*director_;							// weak ref
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;
@property (assign, nonatomic) NSInteger levelMode;
@property (assign, nonatomic) NSInteger level;
@property (readwrite) Boolean gameMusic;
@property (assign, nonatomic) NSString *tmxFile;

@end
