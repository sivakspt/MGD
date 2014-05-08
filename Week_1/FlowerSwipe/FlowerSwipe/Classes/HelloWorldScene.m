    //
//  HelloWorldScene.m
//  FlowerSwipe
//
//  Created by Luke Switzer on 5/7/14.
//  Copyright com.lukeswitzer.ninjastrike 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "HelloWorldScene.h"
#import "IntroScene.h"

// -----------------------------------------------------------------------
#pragma mark - HelloWorldScene
// -----------------------------------------------------------------------

@implementation HelloWorldScene
{
    CCSprite *_sprite;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (HelloWorldScene *)scene
{
    return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
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
    _physicsWorld.debugDraw = YES;
    _physicsWorld.collisionDelegate = self;
    [self addChild:_physicsWorld];
    
    // Add a sprite
    _sprite = [CCSprite spriteWithImageNamed:@"pig.png"];
    _sprite.position  = ccp(self.contentSize.width/2,self.contentSize.height/2);
    _sprite.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _sprite.contentSize} cornerRadius:0]; // 1
    _sprite.physicsBody.collisionGroup = @"playerGroup"; // 2
    [_physicsWorld addChild:_sprite];
    
        
    // Create a back button
    CCButton *backButton = [CCButton buttonWithTitle:@"[ Menu ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.85f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];

    // done
	return self;
}

// -----------------------------------------------------------------------

- (void)dealloc
{
    // clean up code goes here
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
    
    // Animate sprite with action
    CCActionRotateBy* actionSpin = [CCActionRotateBy actionWithDuration:1.5f angle:360];
   // [_sprite runAction:[CCActionRepeatForever actionWithAction:actionSpin]];
    
    [_sprite runAction: [CCActionRepeat actionWithDuration:1.4f]];
    // Log touch location
    CCLOG(@"Move sprite to @ %@",NSStringFromCGPoint(touchLoc));

    [self flowerBomb:1.5f];
    // Move our sprite to touch location
    CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:1.0f position:touchLoc];
    [_sprite runAction:actionMove];
    [_sprite stopAction:actionSpin];
    
    
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    
}
- (void)flowerBomb:(CCTime)dt {
    
    CCSprite *redFlower = [CCSprite spriteWithImageNamed:@"redFlower.png"];
    
    CCSprite *blueFlower = [CCSprite spriteWithImageNamed:@"blueFlower.png"];

    CCPhysicsNode *_physicsWorld;
    _physicsWorld = [CCPhysicsNode node];
    _physicsWorld.gravity = ccp(0,0);
    _physicsWorld.debugDraw = YES;
    _physicsWorld.collisionDelegate = self;
   
    [self addChild:_physicsWorld];
    
    // Set our bounds for flowers
    int minY = redFlower.contentSize.height / 2;
    int maxY = self.contentSize.height - redFlower.contentSize.height / 2;
   
    int minYBlue = blueFlower.contentSize.height/2;
    int maxYBlue = self.contentSize.height - blueFlower.contentSize.height /3;
    
    int rangeBlue = maxYBlue - minYBlue;
    int rangeY = maxY - minY;
    
    int randomY = (arc4random() % rangeY) + minY;
    int randomBlueY = (arc4random() % rangeBlue + minYBlue);
    
    // Add the redflowers
    
    redFlower.position = CGPointMake(self.contentSize.width + redFlower.contentSize.width/2, randomY);
    redFlower.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, redFlower.contentSize} cornerRadius:0];
    redFlower.physicsBody.collisionGroup = @"redGroup";
    redFlower.physicsBody.collisionType  = @"redCollision";
    [_physicsWorld addChild:redFlower];
    
    //Add the blueFlowers
    
    blueFlower.position = CGPointMake(self.contentSize.width + blueFlower.contentSize.width/2, randomBlueY);
    blueFlower.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, redFlower.contentSize} cornerRadius:0];
    blueFlower.physicsBody.collisionGroup = @"blueGroup";
    blueFlower.physicsBody.collisionType  = @"blueCollision";
    [_physicsWorld addChild:blueFlower];
    
    
    // Set time for the animation and range randomization
    int minDuration = 1.4;
    int maxDuration = 5.0;
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
