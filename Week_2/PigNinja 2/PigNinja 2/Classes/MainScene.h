//
//  MainScene.h
//  PigNinja 2
//
//  Created by Luke Switzer on 5/14/14.
//  Copyright com.lukeswitzer.pigninja 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Importing cocos2d.h and cocos2d-ui.h, will import anything you need to start using Cocos2D v3
#import "cocos2d.h"
#import "cocos2d-ui.h"

// -----------------------------------------------------------------------

/**
 *  The main scene
 */
@interface MainScene : CCScene<CCPhysicsCollisionDelegate>{
    
    CCSprite *redFlower;
    CCSprite *blueFlower;
    CGPoint _velocity;
    CCLabelTTF *scoreLabel;

    //    CCSprite *_sprite;
    CGPoint touchedPoint;
    CGPoint currentPoint;
    int frameCount;
    int fpsNow;
    int fpsTarget;
    int score;
    
    float deltaCurrent;
    float _pigX;
    float _pigY;
    
    
    
    NSString *scoreString;
}

// -----------------------------------------------------------------------

+ (MainScene *)scene;
- (id)init;

@property (nonatomic, assign) float pigX;
@property (nonatomic, assign) float pigY;

@property OALSimpleAudio *whipSound;
@property OALSimpleAudio *boingSound;
@property OALSimpleAudio *crunchSound;



// -----------------------------------------------------------------------
@end