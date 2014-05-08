//
//  MainGameActivity.h
//  FlowerSwipe
//
//  Created by Luke Switzer on 5/7/14.
//  Copyright com.lukeswitzer.ninjastrike 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Importing cocos2d.h and cocos2d-ui.h, will import anything you need to start using Cocos2D v3
#import "cocos2d.h"
#import "cocos2d-ui.h"

// -----------------------------------------------------------------------

/**
 *  The main scene
 */
@interface MainGameActivity : CCScene <CCPhysicsCollisionDelegate>{
    
    CCSprite *redFlower;
    CCSprite *blueFlower;
    CCLabelTTF *scoreLabel;

    CCSprite *_sprite;
    CGPoint touchedPoint;
    int score;
    NSString *scoreString;
    NSMutableArray * _baconArray;
    NSMutableArray * _flowerArray;
    CCPhysicsNode *_physicsWorld;
}

// -----------------------------------------------------------------------

+ (MainGameActivity *)scene;
- (id)init;

// -----------------------------------------------------------------------
@end