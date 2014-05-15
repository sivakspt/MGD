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
@synthesize crunchSound,boingSound,whipSound,pigX,pigY;

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
    score = 0;
    
    didHitBacon = false;
    didHitFlower = false;
    
    
    currentPoint = CGPointMake(163.5, 54);
    
    
    
    CCSprite *background1 = [CCSprite spriteWithImageNamed:@"bg2.jpg"];
    
//    CCSprite *blueFlower = [CCSprite spriteWithImageNamed:@"blueFlower.png"];
    background1.position = ccp(260, 120);
    
     [self addChild:background1 z:0];
    
    
    frameCount = 0;
    
    //Score label
    scoreString = [NSString stringWithFormat: @"Bacon : %d", score];
    
    scoreLabel = [CCLabelTTF labelWithString:scoreString fontName:@"Verdana-Bold" fontSize:18.0f];
    scoreLabel.positionType = CCPositionTypeNormalized;
    scoreLabel.color = [CCColor whiteColor];
    if (score < 0) {
        scoreLabel.color = [CCColor redColor];
    }
    
    //Center
    scoreLabel.position = ccp(0.89f, 0.95f);
    
    [self addChild:scoreLabel];
    //Physics for collisions
    
    
    
    CCPhysicsNode *_physicsWorld;
    _physicsWorld = [CCPhysicsNode node];
    _physicsWorld.gravity = ccp(0,-9);
   // _physicsWorld.debugDraw = YES;
    _physicsWorld.collisionDelegate = self;
    [self addChild:_physicsWorld];
    
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
  //  [self addChild:background];
    
    // Add a sprite
    _pigPlayer = [CCSprite spriteWithImageNamed:@"pigNormal.png"];
    _pigPlayer.position  = ccp(self.contentSize.width/2,self.contentSize.height/2);
    _pigPlayer.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _pigPlayer.contentSize} cornerRadius:0];
    _pigPlayer.physicsBody.collisionGroup = @"usergroup";
    _pigPlayer.physicsBody.collisionType  = @"userCollision";
    //[_physicsWorld addChild:_pigPlayer];
    
    
    
    // Create a back button
    CCButton *backButton = [CCButton buttonWithTitle:@"Quit" fontName:@"Verdana" fontSize:18.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.08f, 0.95f); // Top Right of screen
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
    [self schedule:@selector(flowerBomb:) interval:1.3];
    
    
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInterActionEnabled for the individual nodes
    // Per frame update is automatically enabled, if update is overridden
    
}

// -----------------------------------------------------------------------
-(void)gameWon{
    
    //TODO go back to intro screen and end all processes, alert user they won, reset counter
    
        [self unscheduleAllSelectors];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congrats!" message:@"Want to play again?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    
    
    [alert show];
    // back to intro scene with transition
    
    
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
       // [self unscheduleAllSelectors];
                NSLog(@"At 0");
        [[CCDirector sharedDirector] replaceScene:[MainScene scene]
                                   withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
        
    }
    if (buttonIndex == 1) {
        NSLog(@"At 1");
        [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                                   withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
    }
}

-(void)gameLost{

    [scoreLabel removeFromParent];
    //TODO go back to intro screen and end all processes, alert user they lost, reset counter
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Deadly Bacon Levels!" message:@"You Lost!" delegate:self cancelButtonTitle:@"Play Again" otherButtonTitles:@"Quit", nil];
    
    
    [alert show];

    //Unschedule the flowerbombing
    [self unscheduleAllSelectors];

    
}


- (void)onExit
{
    //Unload the cached loaded sound from cache---------------! MEMORY LEAKS CAN HAPPEN HERE!
    [whipSound unloadAllEffects];

    
    [self unscheduleAllSelectors];
    
    
    [crunchSound unloadAllEffects];
    [boingSound unloadAllEffects];


    // always call super onExit last
    [super onExit];
}
- (void)flowerBomb:(CCTime)dt {
  
    //Remove the created player
    [_pigPlayer removeFromParentAndCleanup:true];
    
    CCSprite *baconSprite = [CCSprite spriteWithImageNamed:@"bacon.png"];
    
    CCSprite *blueFlower = [CCSprite spriteWithImageNamed:@"blueFlower.png"];
    
    //Make physics for world
    CCPhysicsNode *_physicsWorld;
    _physicsWorld = [CCPhysicsNode node];
    _physicsWorld.gravity = ccp(0,0);
    //  _physicsWorld.debugDraw = YES;
    _physicsWorld.collisionDelegate = self;
    

    
    [self addChild:_physicsWorld];
    
    
    // Add a sprite
    _pigPlayer = [CCSprite spriteWithImageNamed:@"pigNormal.png"];
    _pigPlayer.position  = currentPoint;
    _pigPlayer.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _pigPlayer.contentSize} cornerRadius:0];
    _pigPlayer.physicsBody.collisionGroup = @"usergroup";
    _pigPlayer.physicsBody.collisionType  = @"userCollision";
    [_physicsWorld addChild:_pigPlayer];
  
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
    int minDuration = 1.6;
    int maxDuration = 2.5;
    int rangeDuration = maxDuration - minDuration;
    int randomDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Move the flowers
    CCAction *actionMove = [CCActionMoveTo actionWithDuration:randomDuration position:CGPointMake(-baconSprite.contentSize.width/2, randomY)];
    
    CCAction *moveBlueFlowers = [CCActionMoveTo actionWithDuration:randomDuration position:CGPointMake(-blueFlower.contentSize.width/2, randomBlueY)];

    //Clean up
    CCAction *actionRemove = [CCActionRemove action];
    [baconSprite runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
    [blueFlower runAction:[CCActionSequence actionWithArray:@[moveBlueFlowers,actionRemove]]];
    
    
    
    
}



// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLoc = [touch locationInNode:self];
    

    
    _pigPlayer.position = currentPoint;
    
    //If you tap the pig
    if (CGRectContainsPoint(_pigPlayer.boundingBox, touchLoc))
    {
        NSLog(@"Tapped player sprite");
        //Play sound on movement
        OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
        [audio playEffect:@"oink.mp3"];
    }
    
    
    float angle = 20;
    //Get the proper interpolation
    float speedFloat = deltaCurrent;
    
    float vx = cos(angle * M_PI / 180) * speedFloat;
    float vy = sin(angle * M_PI / 180) * speedFloat;
    
    CGPoint velocity =  { _pigPlayer.position.x + velocity.x, velocity.y + _pigPlayer.position.y};
    
    
    
    CGPoint direction = CGPointMake(vx,vy);
    
    CGPoint sum = { touchLoc.x + direction.x, touchLoc.y + direction.y};
    
    
    
    // Log touch location coords
    CCLOG(@"Move sprite to @ %@ from %@",NSStringFromCGPoint(touchLoc), NSStringFromCGPoint(_pigPlayer.position));
    
    currentPoint = touchLoc;
    
    
    // Move our sprite to touch location
    CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:1.0 position:sum];
    CCActionMoveTo *actionMoveSlow = [CCActionMoveTo actionWithDuration:deltaCurrent position:touchLoc];

    //Play sound on movement
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio playEffect:@"whip.mp3"];
    
    //Check how fast to move the character depending on delta speed
    
           [_pigPlayer runAction:actionMoveSlow];

          
 
     //   [_pigPlayer runAction:actionMove];
 

        
    
 
    
    
    
}

//Hit a blue flower, deduct a point
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair userCollision:(CCNode *)_sprite blueCollision:(CCNode *)blueFlower {
    
    [blueFlower removeFromParent];
    [scoreLabel removeFromParent];
    
    
    NSLog(@"COLLISION DETECTED:  BLUE FLOWER HIT, POINT DEDUCTION :: BLUE, the score is now: %d", score);
    
     didHitFlower = true;
    [scoreLabel removeFromParentAndCleanup:true];
    
    
    if (didHitFlower == true) {
        score --;
        
    }
    
    //Play sound on point loss
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio playEffect:@"boing.mp3"];
    
    
    
    scoreString = [NSString stringWithFormat: @"Bacon : %d", score];
    
    
    scoreLabel = [CCLabelTTF labelWithString:scoreString fontName:@"Verdana" fontSize:18.0f];
    scoreLabel.positionType = CCPositionTypeNormalized;
    scoreLabel.color = [CCColor whiteColor];
    
    if (score == 0 && didHitFlower == true) {
        [scoreLabel removeFromParent];
        scoreString =  @"LOW BACON!";
        
        
        scoreLabel = [CCLabelTTF labelWithString:scoreString fontName:@"Verdana" fontSize:18.0f];
        scoreLabel.positionType = CCPositionTypeNormalized;
        scoreLabel.color = [CCColor redColor];
        //Center
        scoreLabel.position = ccp(0.49f, 0.95f);
        
//        [self addChild:scoreLabel];
    }
    
    
    
    if (score < 0) {
        [scoreLabel removeFromParent];
        
        [self gameLost];
        //Center
   
        

    }
    
    //Center
    scoreLabel.position = ccp(0.89f, 0.95f);
    
    [self addChild:scoreLabel];
    
    if (score == -1) {
        scoreString = @"DEAD!";
        [scoreLabel removeFromParent];
    }
    
    [blueFlower removeFromParent];
   
    return YES;
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    
}


//Bacon  hit, good, add a point
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair userCollision:(CCNode *)_sprite redCollision:(CCNode *)redFlower {
    


    [redFlower removeFromParent];
    
    NSLog(@"COLLISION DETECTED:  BACON HIT, REMOVING FROM VIEW AND ADDING TO SCORE the score is now: %d", score);
    
    [scoreLabel removeFromParentAndCleanup:true];
    
    didHitBacon = true;
    if (didHitBacon == true) {
         score ++;
        
    }
   


    //Play sound on bacon
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio playEffect:@"crunch.mp3"];
    
    if (score >= 25) {
        [self gameWon];
    }
    
    
    scoreString = [NSString stringWithFormat: @"Bacon : %d", score];
    
    
    scoreLabel = [CCLabelTTF labelWithString:scoreString fontName:@"Verdana" fontSize:18.0f];
    scoreLabel.positionType = CCPositionTypeNormalized;
    scoreLabel.color = [CCColor whiteColor];
    
    //Center
    scoreLabel.position = ccp(0.89f, 0.95f);
    
    [self addChild:scoreLabel];
   
    
        [whipSound unloadAllEffects];
        [crunchSound unloadAllEffects];
        [boingSound unloadAllEffects];
    return YES;
}


//Position update


-(void) update:(CCTime)delta
{
 
    //Get our delta time for the interpolation
    deltaCurrent = delta *166.66 ;
    currentPoint = _pigPlayer.position;
    
  //  NSLog(@"DELTA CURRENT : %f", deltaCurrent);
    
    
    
    pigY = _pigPlayer.position.y;
    pigX = _pigPlayer.position.x;
    
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
