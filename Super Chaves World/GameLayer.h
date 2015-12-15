//
//  GameLayer.h
//  Super Chaves World
//
//  Created by Superstar on 10/16/15.
//  Copyright 2015 Superstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameLayer : CCLayer {
    
    NSInteger _levelMode;
    NSInteger _level;
    Boolean _playMusic;
    
    CCTMXTiledMap *_tileMap;
    CCTMXLayer *_layer;
    CCSprite *_msg;
    CCSprite *_player;

    CGSize _mapSize;
    CGSize _tileSize;

    CCSprite *_bird;
    int _birdDir;

    CCLayerColor *_mask;
    CGSize size;
    int state;
    BOOL _touched;
    BOOL _isJumping;
    float _birdVx;
    float _birdVy;
    float _birdGravity;
    int _birdVxSp;
    int _mapVxSp, _mapVySp, _mapMoveFlag;
    CGPoint birdPos;
    int tileKinds[33];
    NSMutableArray *flyAnimFrames;
    NSMutableArray *walkAnimFrames;
//    NSArray* tileKinds;
    
    // The pixel dimensions of the CAEAGLLayer
    GLint backingWidth_;
    GLint backingHeight_;

}

@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic, retain) CCTMXLayer *background;
@property (nonatomic, strong) CCSprite *player;
@property (nonatomic, strong) CCSprite *bird;
@property (nonatomic, strong) CCAction *runAction;
@property (nonatomic, strong) CCAction *flyAction;
//@property (readwrite) int *tileKinds;


+(CCScene *)scene;

@end
