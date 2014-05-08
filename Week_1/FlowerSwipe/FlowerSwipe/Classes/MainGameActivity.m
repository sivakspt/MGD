//
//  MainGameActivity.m
//  FlowerSwipe
//
//  Created by Luke Switzer on 5/7/14.
//  Copyright com.lukeswitzer.ninjastrike 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "MainGameActivity.h"
#import "IntroScene.h"

// -----------------------------------------------------------------------
#pragma mark - HelloWorldScene
// -----------------------------------------------------------------------

@implementation MainGameActivity
{
    
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (MainGameActivity *)scene
{
    return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    score = 0;
    redFlower = [CCSprite spriteWithImageNamed:@"redFlower.png"];
    
    blueFlower = [CCSprite spriteWithImageNamed:@"blueFlower.png"];
    
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    
    CCPhysicsNode *_physicsWorld;
    _physicsWorld = [CCPhysicsNode node];
    _physicsWorld.gravity = ccp(0,0);
    // _physicsWorld.debugDraw = YES;
    _physicsWorld.collisionDelegate = self;
    [self addChild:_physicsWorld];
    
    // Add a sprite
    _sprite = [CCSprite spriteWithImageNamed:@"pig.png"];
    _sprite.position  = ccp(self.contentSize.width/2,self.contentSize.height/2);
    _sprite.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _sprite.contentSize} cornerRadius:0]; // 1
    _sprite.physicsBody.collisionGroup = @"usergroup";
    _sprite.physicsBody.collisionType  = @"userCollision";
   // [_physicsWorld addChild:_sprite];
    
    //Score label
    
    scoreString = [NSString stringWithFormat: @"Score: %d", score];
    
    
    scoreLabel = [CCLabelTTF labelWithString:scoreString fontName:@"Verdana-Bold" fontSize:18.0f];
    scoreLabel.positionType = CCPositionTypeNormalized;
    scoreLabel.color = [CCColor whiteColor];
    
    //Center
    scoreLabel.position = ccp(0.89f, 0.95f);
    [self addChild:scoreLabel];
    
    
    // Create a back button
    CCButton *backButton = [CCButton buttonWithTitle:@" Exit " fontName:@"Verdana" fontSize:16.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.07f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];
    
    [self flowerBomb:.05f];
    
    // done
	return self;
}

// -----------------------------------------------------------------------

- (void)dealloc
{
    // clean up code goes here
}
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair monsterCollision:(CCNode *)monster projectileCollision:(CCNode *)projectile {
    [monster removeFromParent];
    [projectile removeFromParent];
    
    return YES;
}

// -----------------------------------------------------------------------
#pragma mark - Enter & Exit
// -----------------------------------------------------------------------

- (void)onEnter
{
    // always call super onEnter first
    [super onEnter];
    
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInterActionEnabled for the individual nodes
    // Per frame update is automatically enabled, if update is overridden
    
}

// -----------------------------------------------------------------------

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLoc = [touch locationInNode:self];
    
    [[OALSimpleAudio sharedInstance] playBg:@"background-music-aac.caf" loop:YES];
    
    
    CCPhysicsNode *_physicsWorld;
    _physicsWorld = [CCPhysicsNode node];
    _physicsWorld.gravity = ccp(0,0);
    //    _physicsWorld.debugDraw = YES;
    _physicsWorld.collisionDelegate = self;
    
    //Play sound on movement
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio playEffect:@"whip.mp3"];
    
    
    // Log touch location
    CCLOG(@"Move sprite to @ %@",NSStringFromCGPoint(touchLoc));
    
    [_sprite removeFromParent];
    [redFlower removeFromParent];
    
    
    
    [self flowerBomb:1.5f];
    
    // Move our sprite to touch location
    CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:1.0f position:touchLoc];
    [_sprite runAction:actionMove];
    
    
    
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair userCollision:(CCNode *)_sprite redCollision:(CCNode *)redFlower {
    [redFlower removeFromParent];
    NSLog(@"COLLISION DETECTED:  RED FLOWER HIT, REMOVING FROM VIEW AND ADDING TO SCORE the score is now: %d", score);
    [scoreLabel removeFromParent];
    score ++;
    
    //Play sound on bacon
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio playEffect:@"crunch.mp3"];
    
    
    
    scoreString = [NSString stringWithFormat: @"Score: %d", score];
    
    
    scoreLabel = [CCLabelTTF labelWithString:scoreString fontName:@"Verdana" fontSize:18.0f];
    scoreLabel.positionType = CCPositionTypeNormalized;
    scoreLabel.color = [CCColor whiteColor];
    
    //Center
    scoreLabel.position = ccp(0.89f, 0.95f);
    
    [self addChild:scoreLabel];
    CCAction *actionRemove = [CCActionRemove action];
    
    
    CCAction *actionRemoveRed = [CCActionRemove action];
    
    [redFlower runAction:actionRemoveRed];
    //  [blueFlower runAction:actionRemove];
    return YES;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair userCollision:(CCNode *)_sprite blueCollision:(CCNode *)blueFlower {
    //[blueFlower removeFromParent];
    [scoreLabel removeFromParent];
    score --;
    scoreLabel = [CCLabelTTF labelWithString:scoreString fontName:@"Verdana" fontSize:18.0f];
    NSLog(@"COLLISION DETECTED:  BLUE FLOWER HIT, POINT DEDUCTION :: BLUE, the score is now: %d", score);
    
    
    //Play sound on point loss
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio playEffect:@"boing.mp3"];
    
    
    scoreString = [NSString stringWithFormat: @"Score: %d", score];
    
    
    scoreLabel = [CCLabelTTF labelWithString:scoreString fontName:@"Verdana" fontSize:18.0f];
    scoreLabel.positionType = CCPositionTypeNormalized;
    scoreLabel.color = [CCColor whiteColor];
    
    if (score < 0) {
        scoreLabel.color = [CCColor redColor];
    }
    
    //Center
    scoreLabel.position = ccp(0.89f, 0.95f);
    
    [self addChild:scoreLabel];
    CCAction *actionRemove = [CCActionRemove action];
    
    [redFlower runAction:actionRemove];
    //  [blueFlower runAction:actionRemove];
    return YES;
}



-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    
}
- (void)flowerBomb:(CCTime)dt {
    redFlower = [CCSprite spriteWithImageNamed:@"bacon.png"];
    
    blueFlower = [CCSprite spriteWithImageNamed:@"blueFlower.png"];
    
    
    CCPhysicsNode *_physicsWorld;
    _physicsWorld = [CCPhysicsNode node];
    _physicsWorld.gravity = ccp(0,0);
    //  _physicsWorld.debugDraw = YES;
    _physicsWorld.collisionDelegate = self;
    
    _sprite = [CCSprite spriteWithImageNamed:@"pig.png"];
    _sprite.position  = ccp(self.contentSize.width/2,self.contentSize.height/2);
    _sprite.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _sprite.contentSize} cornerRadius:0]; // 1
    _sprite.physicsBody.collisionGroup = @"usergroup";
    _sprite.physicsBody.collisionType  = @"userCollision";
    [_physicsWorld addChild:_sprite];
    
    
    [self addChild:_physicsWorld];
    
    // Set our bounds for flowers
    int minY = redFlower.contentSize.height / 2;
    int maxY = self.contentSize.height - redFlower.contentSize.height / 2;
    
    //Set randoms for the blues
    int minYBlue = blueFlower.contentSize.height/.2 +1 ;
    int maxYBlue = self.contentSize.height - blueFlower.contentSize.height /3;
    
    int rangeBlue = maxYBlue - minYBlue;
    int rangeY = maxY - minY;
    
    int randomY = (arc4random() % rangeY) + minY;
    int randomD = (arc4random() % rangeY) + minY;
    int randomBlueY = (arc4random() % rangeBlue + minYBlue);
    
    // Add the redflowers
    
    redFlower.position = CGPointMake(self.contentSize.width + redFlower.contentSize.width/2, randomY);
    redFlower.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, redFlower.contentSize} cornerRadius:0];
    redFlower.physicsBody.collisionGroup = @"redGroup";
    redFlower.physicsBody.collisionType  = @"redCollision";
    [_physicsWorld addChild:redFlower];
    
    //Add the blueFlowers
    
    blueFlower.position = CGPointMake(self.contentSize.width + blueFlower.contentSize.width/2, randomD);
    blueFlower.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, blueFlower.contentSize} cornerRadius:0];
    blueFlower.physicsBody.collisionGroup = @"blueGroup";
    blueFlower.physicsBody.collisionType  = @"blueCollision";
    [_physicsWorld addChild:blueFlower];
    
    // Set time for the animation and range randomization
    int minDuration = 2;
    int maxDuration = 4;
    int rangeDuration = maxDuration - minDuration;
    int randomDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Move the flowers
    CCAction *actionMove = [CCActionMoveTo actionWithDuration:randomDuration position:CGPointMake(-redFlower.contentSize.width/2, randomY/2)];
    
    CCAction *moveBlueFlowers = [CCActionMoveTo actionWithDuration:randomDuration position:CGPointMake(-blueFlower.contentSize.width/2, randomY)];

    CCAction *actionRemove = [CCActionRemove action];
    [redFlower runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
    [blueFlower runAction:[CCActionSequence actionWithArray:@[moveBlueFlowers,actionRemove]]];
    
    
}


// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}

// -----------------------------------------------------------------------
@end
