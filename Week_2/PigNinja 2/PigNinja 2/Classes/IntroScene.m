//
//  IntroScene.m
//  PigNinja 2
//
//  Created by Luke Switzer on 5/14/14.
//  Copyright com.lukeswitzer.pigninja 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "IntroScene.h"
#import "MainScene.h"

// -----------------------------------------------------------------------
#pragma mark - IntroScene
// -----------------------------------------------------------------------

@implementation IntroScene
@synthesize whipSound,boingSound,crunchSound;

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (IntroScene *)scene
{
	return [[self alloc] init];
    

    
}

// -----------------------------------------------------------------------

- (id)init

{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    //Make a purple bg
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.3f green:0.2f blue:0.3f alpha:1.0f]];
    [self addChild:background];
    
    //Title Screen
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Pig Ninja" fontName:@"Chalkduster" fontSize:36.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor redColor];
    
    //Center
    label.position = ccp(0.5f, 0.5f);
    [self addChild:label];
    
    //Title Screen - info label
    CCLabelTTF *infoLabel = [CCLabelTTF labelWithString:@"Get the Bacon, Dodge the Plants! " fontName:@"Verdana" fontSize:18.0f];
    infoLabel.positionType = CCPositionTypeNormalized;
    infoLabel.color = [CCColor whiteColor];
    
    //Center
    infoLabel.position = ccp(0.5f, 0.7f);
    [self addChild:infoLabel];
    
    
    // Start Button
    CCButton *startButton = [CCButton buttonWithTitle:@"[Start]" fontName:@"Verdana-Bold" fontSize:19.0f];
    startButton.positionType = CCPositionTypeNormalized;
    startButton.position = ccp(0.5f, 0.35f);
    [startButton setTarget:self selector:@selector(onSpinningClicked:)];
    
    //Play sound on bacon
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio playEffect:@"crunch.mp3"];
    
    [self addChild:startButton];
    


    // done
	return self;
}

-(void)gameWon{
    
    //TODO go back to intro screen and end all processes, alert user they won, reset counter
    
    
}

-(void)gameLost{
    //TODO go back to intro screen and end all processes, alert user they lost, reset counter
    
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onSpinningClicked:(id)sender
{
    // start spinning scene with transition
    [[CCDirector sharedDirector] replaceScene:[MainScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionUp duration:.8f]];
     [self unscheduleAllSelectors];

}

// -----------------------------------------------------------------------
@end
