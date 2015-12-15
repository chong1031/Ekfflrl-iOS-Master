//
//  Define.h
//  Super Chaves World
//
//  Created by Superstar on 10/10/15.
//  Copyright (c) 2015 Superstar. All rights reserved.
//

#ifndef Super_Chaves_World_Define_h
#define Super_Chaves_World_Define_h


#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define SCALE (max(SCREEN_WIDTH/1280.0f, SCREEN_HEIGHT/800.0f))

#define GSPAUSE 0
#define GSREADY 1
#define GSRUN 2
#define GSOVER 3

#define normalVx 7
#define fastVx 2*normalVx
#define gravity 432.0f*normalVx*normalVx/180.0f/180.0f
#define jumpVy (180.0f*gravity+0.1f)/normalVx



#define tkNone 0
#define tkBird 1
#define tkBlock 2
#define trCherry 3
#define tkObstacle 4
#define tkJump 5
#define tkSplinter 6
#define tkLeft 7
#define tkRight 8
#define tkNormalR 9
#define tkFastR 10
#define tkNormalL 11
#define tkFastL 12
#define tkTarget 13
#define tkOutX 14
#define tkOutY 15


#endif
