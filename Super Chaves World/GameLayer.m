//
//  GameLayer.m
//  Super Chaves World
//
//  Created by Superstar on 10/16/15.
//  Copyright 2015 Superstar. All rights reserved.
//

#import "GameLayer.h"
	
#import "AppDelegate.h"
#import "SelectPage.h"
#import "Define.h"


@implementation GameLayer

+(CCScene *) scene
{
    CCScene *scene = [CCScene node];
    
    GameLayer *gameLayer = [GameLayer node];
    
    [scene addChild:gameLayer];
    
    return scene;	
}

-(void)setViewpointCenter:(CGPoint) position {
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    int x = MAX(position.x, winSize.width / 2);
    int y = MAX(position.y, winSize.height / 2);
    x = MIN(x, (_tileMap.mapSize.width * _tileMap.tileSize.width)
            - winSize.width / 2);
    y = MIN(y, (_tileMap.mapSize.height * _tileMap.tileSize.height)
            - winSize.height/2);
    CGPoint actualPosition = ccp(x, y);
    
    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    self.position = viewPoint;
    
}

-(id) init
{
    if (self = [super init]) {
        
        self.isTouchEnabled = YES;
        	
        size = [CCDirector sharedDirector].winSize;
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth_);
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight_);

        CCLOG(@"windows size : %d x %d", (int)backingWidth_, (int)backingHeight_);
        
        AppController *delegate = [[UIApplication sharedApplication] delegate];
        NSLog(@"level Mode = %d", delegate.levelMode);
        NSLog(@"Level = %d", delegate.level);
        NSLog(@"gameMusic = %d", delegate.gameMusic);
        
        _levelMode = delegate.levelMode;
        _level = delegate.level;
			
        // set the main background
        CCSprite *backgroundSpr = [CCSprite spriteWithFile:[NSString stringWithFormat:@"game_bg%d.png", _levelMode]];
        backgroundSpr.scaleX = size.width / [backgroundSpr boundingBox].size.width;
        backgroundSpr.scaleY = size.height / [backgroundSpr boundingBox].size.height;
        backgroundSpr.position = ccp(size.width/2, size.height/2);
//        backgroundSpr.position = ccp(backingWidth_/2, backingHeight_/2);
        
        [self addChild:backgroundSpr];
        
        // map
        NSLog(@"tile map");
        self.isTouchEnabled = YES;
        
        delegate.tmxFile = @"level0_1.tmx";
        NSLog(@"delegate.tmxfile = %@", delegate.tmxFile);

        [self createBird];
        
        // Add the tile map
        self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"level0_1.tmx"];
        
        _layer = [_tileMap layerNamed:@"Level"];
        _mapSize = _layer.layerSize;
        _tileSize = _layer.mapTileSize;
        
        _tileMap.anchorPoint = ccp(0, 0);
        
//        int tileKind[16] = {tkNone, tkBird, tkBlock, trCherry, tkObstacle, tkJump, tkSplinter, tkLeft, tkRight, tkNormalR, tkFastR, tkNormalL, tkFastL, tkTarget, tkOutX, tkOutY};
//        tkNone,
//        tkBird, tkBlock, trCherry, tkObstacle, tkObstacle, tkObstacle, tkObstacle, tkJump,
//        tkJump, tkJump, tkSplinter, tkSplinter, tkSplinter, tkSplinter, tkSplinter, tkSplinter,
//        tkNone, tkLeft, tkRight, tkNone, tkNormalR, tkFastR, tkNormalL, tkFastL,
//        tkNone, tkLeft, tkRight, tkNone, tkNormalR, tkFastR, tkNormalL, tkFastL
//        
        for (int i = 0; i < 5; i++) {
            tileKinds[i] = i;
        }
        for (int i = 5; i < 8; i++) {
            tileKinds[i] = tkObstacle;
        }
        for (int i = 8; i < 11; i++) {
            tileKinds[i] = tkJump;
        }
        for (int i = 11; i < 17; i++) {
            tileKinds[i] = tkSplinter;
        }
        for (int j = 0; j < 2; j++) {
            for (int i = 17; i < 25; i++) {
                
                tileKinds[i+j*8] = tkNone;
                tileKinds[i+j*8] = tkLeft;
                tileKinds[i+j*8] = tkRight;
                tileKinds[i+j*8] = tkNone;
                tileKinds[i+j*8] = tkNormalR;
                tileKinds[i+j*8] = tkFastR;
                tileKinds[i+j*8] = tkNormalL;
                tileKinds[i+j*8] = tkFastL;
                
            }
        }

        
        [self addChild:_tileMap z:1];
        NSLog(@"tilemap pos : %f %f", _tileMap.position.x, _tileMap.position.y);
        
        for (int y = 0; y < _mapSize.height; y++) {
            NSLog(@"mapsize = %f %f", _mapSize.width, _mapSize.height);

            for (int x = 0; x < _mapSize.width; x++) {
                
                int gid = [_layer tileGIDAt:ccp((float)x, (float)y)];
                int kind = tileKinds[gid];
                
                NSLog(@"gid = %d, kind = %d", gid, kind);
                if (gid > 10) {
                    NSLog(@"Stop : Stop");
                }
                
                if (kind == trCherry) {
                    
                    CCSprite *star = [_layer tileAt:ccp(x, y)];
                    star.anchorPoint = ccp(0.5f, 0.5f);
                    star.position = ccp(star.position.x + _tileSize.width*0.5f, star.position.y + _tileSize.height*0.5f);
                    
                    [star runAction:[CCRepeatForever actionWithAction:
                                     [CCSequence actions:[CCScaleTo actionWithDuration:0.5f scale:1.2f],
                                      [CCScaleTo actionWithDuration:0.5f scale:1], nil]]];
                    continue;
                }
                
                if (kind == tkSplinter) {
                    continue;
                }
                
                if (kind == tkJump) {
                    continue;
                }
                
                if (kind == tkBird) {
                    [_layer removeTileAt:ccp(x, y)];
                    
                    // get the properties of the tile map image.
//                    CCTMXMapInfo *mapInfo = [CCTMXMapInfo formatWithTMXFile:@"level0_1.tmx"];
//                    NSDictionary *properties = [mapInfo.tileProperties objectForKey:[NSNumber numberWithInt:gid]];
//                    NSString *str = [properties objectForKey:@"StartDirection"];
                    NSObject *str = [_tileMap propertyNamed:@"StartDirection"];
                    
                    [self setBirdDir:((str != NULL && [str isEqual:(@"1")]) ? -1 : 1)];

                    NSLog(@"gid = %d %d  %d", gid, x, y);
                    [_bird setPosition:ccp((x+0.5f-_birdDir*1.3f) * _tileSize.width/2, (_mapSize.height-y-3.8f) * _tileSize.height)];
                    NSLog(@"_bird setosition = %f %f", _bird.position.x, _bird.position.y);
                    
                    _mapVySp = 0;
                    _mapMoveFlag = 0;
                    
//                    [_bird setPosition:ccp(size.width/2, size.height/2)];
                    
                    NSLog(@"bird position %f %f", _bird.position.x, _bird.position.y);
                    
                    continue;
                    
                }
            }
        }
        
        // Map position.
        [self updatePosition];


        
        // score mark
        CCSprite *scoreMark = [CCSprite spriteWithFile:@"score.png"];
        scoreMark.scaleX = backgroundSpr.scaleX;
        scoreMark.scaleY = backgroundSpr.scaleY;
        scoreMark.anchorPoint = ccp(1, 0.5f);
        scoreMark.position = ccp([scoreMark boundingBox].size.width * 2, size.height - [scoreMark boundingBox].size.height*1.2);
        
        [self addChild:scoreMark];
        
        // Score Label
        
        
        // level mark
        CCSprite *levelMark = [CCSprite spriteWithFile:@"level.png"];
        levelMark.scaleX = backgroundSpr.scaleX;
        levelMark.scaleY = backgroundSpr.scaleY;
        levelMark.anchorPoint = ccp(1, 0.5f);
        levelMark.position = ccp(size.width/2 - [levelMark boundingBox].size.width, scoreMark.position.y);
        
        [self addChild:levelMark];
        
        CCSprite *levelCount = [CCSprite spriteWithFile:@"1.png"];
        levelCount.scaleX = backgroundSpr.scaleX;
        levelCount.scaleY = backgroundSpr.scaleY;
        levelCount.position = ccp(levelMark.position.x + [levelMark boundingBox].size.width/2, levelMark.position.y);
        
        [self addChild:levelCount];
        
        // pause button.
        CCMenuItemImage *pause = [CCMenuItemImage itemWithNormalImage:@"back1.png" selectedImage:@"back2.png" target:self selector:@selector(gamePause)];
        pause.scaleX = -backgroundSpr.scaleX;
        pause.scaleY = -backgroundSpr.scaleY;
        pause.position = ccp(size.width - [pause boundingBox].size.width/2, levelMark.position.y);
        
        CCMenu *menu = [CCMenu menuWithItems:pause, nil];
        menu.position = CGPointZero;
        [self addChild:menu];
        
        // mask
        _mask = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 255) width:size.width height:size.height];

//        [self setViewpointCenter:ccp(size.width/2, size.height/2)];

        [self addChild:_mask z:2];
        
        // message
        _msg = [CCSprite spriteWithFile:@"get_ready_logo.png"];
        _msg.scaleX = backgroundSpr.scaleX;
        _msg.scaleY = backgroundSpr.scaleY;
        _msg.position = ccp(-1 * size.width*0.5, size.height/2);
        [self addChild:_msg z:3];
        
        // ready
        state = GSREADY;
        [_mask runAction:[CCFadeOut actionWithDuration:0.6f]];
        [_msg runAction:[CCSequence actions:
                        [CCEaseElasticOut actionWithAction:[CCMoveTo actionWithDuration:0.6f position:ccp(size.width/2, size.height/2)] period:0.5f],
                        [CCCallFunc actionWithTarget:self selector:@selector(gameReady)], nil]];
        
        // Game schedule
        [self schedule:@selector(update:)];
        
    }
    
    return self;
}

-(void) gameReady
{
    state = GSREADY;
}

-(void) gameRun
{
    state = GSRUN;
}

-(void) showFullAdmobForComplete
{
    
}

-(void) nextLevel
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.7f scene:[GameLayer scene]]];
}

-(void) gameRestart
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.7f scene:[GameLayer scene]]];
}

-(void) gamePause
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.7f scene:[SelectPage scene]]];
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _touched = true;
    
    if (state == GSREADY) {
        NSLog(@"game ready");
        [_msg runAction:[CCSequence actions:
                         [CCEaseElasticIn actionWithAction:[CCMoveTo actionWithDuration:0.6f position:ccp(size.width*1.5f, size.height*0.5f)] period:0.5f],
                         [CCCallFunc actionWithTarget:self selector:@selector(gameRun)], nil]];
    }

    if (state == GSPAUSE) {
        NSLog(@"game puase");
        [_msg runAction:[CCSequence actions:
//                         [CCCallFunc actionWithTarget:self selector:@selector(showFullAdmobForComplete)],
                         [CCEaseElasticIn actionWithAction:[CCMoveTo actionWithDuration:0.6f position:ccp(-1*size.width/2, size.height/2)] period:0.5f],
                         [CCCallFunc actionWithTarget:self selector:@selector(nextLevel)], nil]];
    }
    
    if (state == GSOVER) {
        NSLog(@"gane over");
        [_msg runAction:[CCSequence actions:
//                         [CCCallFunc actionWithTarget:self selector:@selector(showFullAdmobForGameover)],
                         [CCEaseElasticIn actionWithAction:[CCMoveTo actionWithDuration:0.6f position:ccp(-1*size.width/2, size.height/2)] period:0.5f],
                         [CCCallFunc actionWithTarget:self selector:@selector(gameRestart)], nil]];
    }
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    _touched = false;

//    [self.bird runAction:self.flyAction];
    
}

-(void) update:(float) dt
{
    if (state == GSRUN) {
        if (_touched) {
            [self birdJump];
        }
        [self updateLevelMap:dt];
    }
}

-(void) gameCompleted
{
    state = GSPAUSE;
    [_mask runAction:[CCFadeIn actionWithDuration:0.6f]];
    [_msg setTexture:[[CCTextureCache sharedTextureCache] addImage:@"level_completed_logo.png"]];
    [_msg runAction:[CCSequence actions:
                    [CCEaseElasticOut actionWithAction:[CCMoveTo actionWithDuration:0.6f position:ccp(size.width/2, size.height/2)] period:0.5f],
                     [CCDelayTime actionWithDuration:0.5f], nil]];
}


-(void) gameOver
{
    [_bird stopAllActions];
    
    NSLog(@"#shared info : ");
    
    // save score.
    
    state = GSOVER;
    [_mask runAction:[CCFadeIn actionWithDuration:0.6f]];
    [_msg setTexture:[[CCTextureCache sharedTextureCache] addImage:@"failed_logo.png"]];
    [_msg runAction:[CCSequence actions:[CCEaseElasticOut actionWithAction:[CCMoveTo actionWithDuration:0.6f position:ccp(size.width/2, size.height/2)] period:0.5f],
                     [CCDelayTime actionWithDuration:0.5f], nil]];
    
}


///////////// ---------- Level Map ----------   /////////////////////

-(void) createBird
{
    // Run animation
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"run.plist"];
    
    walkAnimFrames = [NSMutableArray array];
    for (int i=0; i<16; i++) {
        [walkAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"run%d.png",i]]];
    }
    
    CCAnimation *walkAnim = [CCAnimation animationWithSpriteFrames:walkAnimFrames delay:0.02f];
    
    self.bird = [CCSprite spriteWithSpriteFrameName:@"run0.png"];
    self.bird.anchorPoint = ccp(0.5f, 0.46f);
    self.runAction = [CCRepeatForever actionWithAction:
                       [CCAnimate actionWithAnimation:walkAnim]];
    [self addChild:self.bird z:2];
    [self.bird runAction:self.runAction];
    
    // Fly animation.
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"fly.plist"];
    
    flyAnimFrames = [NSMutableArray array];
    for (int i=0; i<4; i++) {
        [flyAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"fly%d.png",i]]];
    }
    
    CCAnimation *flyAnim = [CCAnimation animationWithSpriteFrames:flyAnimFrames delay:0.02f];
    
    self.flyAction = [CCRepeatForever actionWithAction:
                      [CCAnimate actionWithAnimation:flyAnim]];
    
    _isJumping = false;
    
    _birdVx = normalVx/1.5;
    _birdGravity = gravity;
    _birdVy = 0;
    
}

-(void) setBirdDir:(int) dir
{
    _birdDir = dir;
    [_bird setScaleX:_birdDir];
}

-(void) updatePosition
{
    float x = size.width * (0.5f - _birdDir*0.25f) - _bird.position.x;
    
    if (_mapVxSp != 0) {
        x += _birdVx * _mapVxSp;
    }

    if (x > 0) {
        x = 0;
        _mapMoveFlag = 0;
        _birdVxSp = 1;
        _mapVxSp = 0;
    } else if (x*2+_tileSize.width*_mapSize.width < size.width*2) {
//        x = size.width*2 - _tileSize.width*_mapSize.width;
        x = _tileMap.position.x;
        _birdVxSp = 1;
        _mapVxSp = 0;
        _mapMoveFlag = 1;
    } else {
        _birdVxSp = 0;
        _mapVxSp--;
    }
    
    if (_mapMoveFlag == 1) {
        _birdVxSp = 1;
    }
    
    float y;
    if (!_isJumping) {
        y = size.height*0.5f - _tileSize.height*0.45*(backingHeight_/800.0f) - _bird.position.y;
    }
    
    if (_isJumping) {
        y = _tileMap.position.y - _birdVy;
    }
    
    if (_mapMoveFlag == 0) {
        [_tileMap setPosition:ccp(x, y)];
    }
    
    if (_mapMoveFlag == 1) {
        [_tileMap setPosition:ccp(_tileMap.position.x, y)];
    }
    
    NSLog(@"tile map position : %f %f", _tileMap.position.x, _tileMap.position.y);
}

-(CGPoint) getTilePos:(CGPoint) pos
{
    int x = (int)(pos.x / _tileSize.width);
    int y = (int)(_mapSize.height - (int)(pos.y/_tileSize.height) - 1);
    return ccp(x, y);
}

-(int) getTileKind:(CGPoint) pos
{
    if (pos.x < 0 || pos.x >= _mapSize.width) {
        return (pos.x < -1 || pos.x > _mapSize.width) ? tkTarget : tkOutX;
    }
    
    if (pos.y < 0) {
        return tkNone;
    }
    
    if (pos.y >= _mapSize.height) {
        return tkOutY;
    }
    
    NSLog(@"tileGIDAt : %d", [_layer tileGIDAt:pos]);
    return tileKinds[[_layer tileGIDAt:pos]];
}

-(void) gotCherry:(CGPoint) pos
{
    NSLog(@"sound here");
    CGPoint cherryPos = [_layer tileAt:pos].position;
    CCSprite *cherry = [CCSprite spriteWithFile:@"cherry.png"];
    cherry.position = [self convertToNodeSpace:[self convertToWorldSpace:ccp(cherryPos.x + _tileMap.position.x, cherryPos.y)]];
    [cherry runAction:[CCFadeOut actionWithDuration:0.99f]];
    [cherry runAction:[CCSequence actions:
                      [CCMoveTo actionWithDuration:1 position:ccp(60, size.height-50)],
                       [CCCallFunc actionWithTarget:cherry selector:@selector(removeFromParentAndCleanup:)], nil]];
    [self addChild:cherry];
    
    [_layer removeTileAt:pos];
    NSLog(@"game score here");
}

-(void) birdJump
{
    if (_birdVy == 0) {
        CGPoint topTilePos = [self getTilePos:ccp(_bird.position.x*2 - _tileMap.position.x*2, _bird.position.y+_tileSize.height*3.8f)];
        
        if ([_layer tileGIDAt:topTilePos] != tkBlock) {
            _birdVy = jumpVy/1.5;
            if (!_isJumping) {
                _isJumping = true;
                NSLog(@"sound here");
                [_bird stopAction:self.runAction];
                [_bird runAction:self.flyAction];
            }
        }
    }
}


// Game schedule.
-(void) updateLevelMap:(float)dt
{
    _birdVy -= _birdGravity;
    NSLog(@"_bird vertical speed : %f %f", _birdVx, _birdVy);
    birdPos = ccp(_bird.position.x + _birdVx * _birdVxSp, _bird.position.y + _birdVy);
    CGPoint bottomTilePos = [self getTilePos:ccp(birdPos.x*2 - _tileMap.position.x*2 + _tileSize.width/3, birdPos.y*2 + _tileSize.height*0.1f + (birdPos.y - _tileMap.position.y-200)*2)];
    int bottomKind = [self getTileKind:bottomTilePos];

    NSLog(@"_tileMap position %f %f", _tileMap.position.x, _tileMap.position.y);
    NSLog(@"Real _bird position %f %f", _bird.position.x, _bird.position.y);
    
    // check bottom (block)
    if (bottomKind == tkBlock || bottomKind == tkOutX || bottomKind == tkJump) {
//        birdPos.y = (_mapSize.height - bottomTilePos.y + 0.5f) * size.height/10;
        _bird.position = ccp(birdPos.x, _bird.position.y);
        
        if (bottomKind == tkJump) {
            NSLog(@"sound here");
            _birdVy = 2*jumpVy/1.5;
            _birdGravity = 2*gravity/1.2;
            
            if (!_isJumping) {
                _isJumping = true;
                [_bird stopAction:self.runAction];
                [_bird runAction:self.flyAction];
            }
        }
        else {
            if (_isJumping) {
                _isJumping = false;
                [_bird stopAction:self.flyAction];
                [_bird runAction:self.runAction];
                _birdGravity = gravity;
            }
            
            _birdVy = 0;
        }
        
        // check center star.
        CGPoint centerTilePos = [self getTilePos:ccp(birdPos.x*2 - _tileMap.position.x*2 - _tileSize.width/2, birdPos.y*2 + _tileSize.height/2+(birdPos.y - _tileMap.position.y-200))];
        NSLog(@"centerTilePos %d", [self getTileKind:centerTilePos]);
        if ([self getTileKind:centerTilePos] == trCherry) {
            [self gotCherry:centerTilePos];
        }
    }
    else {
        _bird.position = ccp(birdPos.x, _bird.position.y);
        
//         check gameover.
        if (bottomKind == tkSplinter || bottomKind == tkObstacle || bottomKind == tkOutY) {
            [self gameOver];
            return;
        }
        
        // check target.
        if (bottomKind == tkTarget) {
            [self gameCompleted];
            return;
        }
        
        // check star
        if (bottomKind == trCherry) {
            [self gotCherry:bottomTilePos];
        }
    }
    
    // check front (block, obstacle)
    CGPoint frontTilePos = [self getTilePos:ccp(birdPos.x*2 - _tileMap.position.x*2 + _birdDir*_tileSize.width*0.3f, birdPos.y*2 + _tileSize.height*1.0f +  (birdPos.y - _tileMap.position.y-200))];
    int frontKind = [self getTileKind:frontTilePos];
    NSLog(@"frontKind = %d %f %f", frontKind, frontTilePos.x, frontTilePos.y);
    
    if (frontKind == tkBlock || frontKind == tkObstacle) {
        [self gameOver];
        return;
    }
    
    // check (speed, direction)
    CGPoint tilePos = [self getTilePos:birdPos];
    int kind;
    while (true) {
        kind = [self getTileKind:tilePos];
        if (kind != tkNone) {
            break;
        }
        tilePos.y++;
    }
    
    switch (kind) {
        case tkLeft:
            if (_birdDir != -1) {
                NSLog(@"sound here");
                [self setBirdDir:-1];
            }
            break;
        
        case tkRight:
            if (_birdDir != 1) {
                NSLog(@"sound here.");
                [self setBirdDir:1];
            }
            break;
            
        case tkNormalR:
            if (_birdDir == 1) {
                NSLog(@"sound here");
                _birdVx = normalVx/1.5;
            }
            break;
            
        case tkNormalL:
            if (_birdDir == -1) {
                NSLog(@"sound here");
                _birdVx = normalVx/1.5;
            }
            break;
            
        case tkFastR:
            if (_birdDir == 1) {
                NSLog(@"sound here");
                _birdVx = fastVx/1.5;
            }
            break;
            
        case tkFastL:
            if (_birdDir == -1) {
                NSLog(@"sound here");
                _birdVx = fastVx/1.5;
            }
            break;
            
            
        default:
            break;
    }
    
    // map position
    [self updatePosition];
}

@end
