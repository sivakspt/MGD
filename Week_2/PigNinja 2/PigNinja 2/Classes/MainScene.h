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
    Boolean didScoreEnough;
    Boolean didHitFlower;
    Boolean didHitBacon;
    Boolean pigMoving;
    CGPoint _velocity;
    CCButton *pauseBtn;
    CCLabelTTF *scoreLabel;
    NSMutableArray *animationFramesRun;
//    CCSprite *_pigPlayer;
    CGPoint touchedPoint;
    CGPoint currentPoint;
    CCActionMoveTo *actionMove;
    int frameCount;
    int fpsNow;
    int fpsTarget;
    int score;
    CCAnimation *pigAnim;
    float deltaCurrent;
    float _pigX;
    float _pigY;
    CCPhysicsNode *_physicsWorld;
    CCActionRepeatForever *pigCycles;
    CCActionRepeatForever *runCycles;
    CCActionRepeatForever *deadCycles;

    CCActionAnimate *pigMove;
    NSMutableArray *animFrames;
    
    NSString *scoreString;
}

// -----------------------------------------------------------------------

+ (MainScene *)scene;
- (id)init;

@property (nonatomic, assign) float pigX;
@property (nonatomic, assign) float pigY;
@property (nonatomic, strong) CCSprite *bear;
@property (nonatomic, strong) CCSprite *pigNinja;
@property (nonatomic, strong) CCAction *walkAction;
@property (nonatomic, strong) CCAction *moveAction;
@property OALSimpleAudio *whipSound;
@property OALSimpleAudio *boingSound;
@property OALSimpleAudio *crunchSound;



// -----------------------------------------------------------------------
@end