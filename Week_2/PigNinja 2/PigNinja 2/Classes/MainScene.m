//
//  MainScene.m
//  PigNinja 2
//
//  Created by Luke Switzer on 5/14/14.
//  Copyright com.lukeswitzer.pigninja 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "MainScene.h"
#import "IntroScene.h"



// -----------------------------------------------------------------------
#pragma mark - MainScene
// -----------------------------------------------------------------------

@implementation MainScene
@synthesize crunchSound,boingSound,whipSound;

    CCSprite *_pigPlayer;
   

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (MainScene *)scene
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
    
    // Add a sprite
    _pigPlayer = [CCSprite spriteWithImageNamed:@"pigNormal.png"];
    _pigPlayer.position  = ccp(self.contentSize.width/2,self.contentSize.height/2);
    [self addChild:_pigPlayer];
    
    // Animate sprite with action
    CCActionRotateBy* actionSpin = [CCActionRotateBy actionWithDuration:1.5f angle:360];
  //  [_pigPlayer runAction:[CCActionRepeatForever actionWithAction:actionSpin]];
    
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
    
    //Interval for bacon and flowers
    [self schedule:@selector(flowerBomb:) interval:1.5];
    
    
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInterActionEnabled for the individual nodes
    // Per frame update is automatically enabled, if update is overridden
    
}

// -----------------------------------------------------------------------


- (void)onExit
{
    //Unload the cached loaded sound from cache---------------! MEMORY LEAKS CAN HAPPEN HERE!
    [whipSound unloadAllEffects];
    
    // always call super onExit last
    [super onExit];
}



- (void)flowerBomb:(CCTime)dt {
    CCSprite *baconSprite = [CCSprite spriteWithImageNamed:@"bacon.png"];
    
    CCSprite *blueFlower = [CCSprite spriteWithImageNamed:@"blueFlower.png"];

    //Make physics for world
    CCPhysicsNode *_physicsWorld;
    _physicsWorld = [CCPhysicsNode node];
    _physicsWorld.gravity = ccp(0,0);
    //  _physicsWorld.debugDraw = YES;
    _physicsWorld.collisionDelegate = self;
    

    
    
    [self addChild:_physicsWorld];
    
    // Set our bounds for flowers
    int minY = baconSprite.contentSize.height / 2;
    int maxY = self.contentSize.height - baconSprite.contentSize.height / 2;
    
    //Set randoms for the blues
    int minYBlue = blueFlower.contentSize.height/.2 +1 ;
    int maxYBlue = self.contentSize.height - blueFlower.contentSize.height /3;
    
    int rangeBlue = maxYBlue - minYBlue;
    int rangeY = maxY - minY;
    
    int randomY = (arc4random() % rangeY) + minY;
    int randomBlueY = (arc4random() % rangeBlue + minYBlue);
    
    // Add the baconSprites
    
    baconSprite.position = CGPointMake(self.contentSize.width + baconSprite.contentSize.width/2, randomY);
    baconSprite.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, baconSprite.contentSize} cornerRadius:0];
    baconSprite.physicsBody.collisionGroup = @"redGroup";
    baconSprite.physicsBody.collisionType  = @"redCollision";
    [_physicsWorld addChild:baconSprite];
    
    //Add the blueFlowers
    
    blueFlower.position = CGPointMake(self.contentSize.width + blueFlower.contentSize.width/2, randomBlueY);
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
    CCAction *actionMove = [CCActionMoveTo actionWithDuration:randomDuration position:CGPointMake(-baconSprite.contentSize.width/2, randomY/2)];
    
    CCAction *moveBlueFlowers = [CCActionMoveTo actionWithDuration:randomDuration position:CGPointMake(-blueFlower.contentSize.width/2, randomBlueY)];
    
    CCAction *actionRemove = [CCActionRemove action];
    [baconSprite runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
    [blueFlower runAction:[CCActionSequence actionWithArray:@[moveBlueFlowers,actionRemove]]];
    //  [blueFlower2 runAction:[CCActionSequence actionWithArray:@[moveBlueFlowers,actionRemove]]];
    
    
}


// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLoc = [touch locationInNode:self];
    
    touchedPoint = touchLoc;
   
    //If you tap the pig
    if (CGRectContainsPoint(_pigPlayer.boundingBox, touchedPoint))
    {
        NSLog(@"Tapped player sprite");
        
    }
    
    // Log touch location coords
    CCLOG(@"Move sprite to @ %@ from %@",NSStringFromCGPoint(touchLoc), NSStringFromCGPoint(_pigPlayer.position));
    
    // Move our sprite to touch location
    CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:1.0 position:touchLoc];
    [_pigPlayer runAction:actionMove];

    //Play sound on movement
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio playEffect:@"whip.mp3"];
}

//Position update


-(void) update:(CCTime)delta
{
    
    self.position = ccpAdd(self.position, ccpMult(velocity, delta));
    
    
    
  //  NSLog(@"DELTA: %f", NSStringFromCGPoint(velocity),delta);
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
