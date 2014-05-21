//
//  CreditsScene.m
//  PigNinja 2
//
//  Created by Luke Switzer on 5/21/14.
//  Copyright 2014 com.lukeswitzer.pigninja. All rights reserved.
//

#import "CreditsScene.h"
#import "CCButton.h"
#import "MainScene.h"
#import "IntroScene.h"

@implementation CreditsScene

+ (CreditsScene *)scene
{
	return [[self alloc] init];
    
    
    
}
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
    label.color = [CCColor whiteColor];
    
    //Center
    label.position = ccp(0.5f, 0.9f);
    [self addChild:label];
    
    //Title Screen - info label
    CCLabelTTF *infoLabel = [CCLabelTTF labelWithString:@"    Instructions: Move the pig by tapping the screen \n to collect bacon. Avoid the flowers, they're toxic to pigs." fontName:@"Verdana" fontSize:13.0f];
    infoLabel.positionType = CCPositionTypeNormalized;
    infoLabel.color = [CCColor whiteColor];
    
    //Center
    infoLabel.position = ccp(0.5f, 0.7f);
    [self addChild:infoLabel];
    
    
    
    
    // Start Button
    CCButton *startButton = [CCButton buttonWithTitle:@"www.lukeswitzer.com" fontName:@"Verdana-Bold" fontSize:19.0f];
    startButton.positionType = CCPositionTypeNormalized;
    startButton.color = [CCColor whiteColor];
    startButton.position = ccp(0.5f, 0.45f);
    [startButton setTarget:self selector:@selector(onLink:)];
    
    //Play sound on bacon
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio playEffect:@"crunch.mp3"];
    
    [self addChild:startButton];
    
    
    // Start Button
    CCButton *backBtn = [CCButton buttonWithTitle:@"[ Back ]" fontName:@"Verdana-Bold" fontSize:14.0f];
    backBtn.positionType = CCPositionTypeNormalized;
    backBtn.color = [CCColor whiteColor];
    backBtn.position = ccp(0.5f, 0.25f);
    [backBtn setTarget:self selector:@selector(onBack:)];
    
    [self addChild:backBtn];
    
    // done
	return self;
}


-(void)onLink:(id)sender{
    NSLog(@"Go to creds homepage");
    NSURL *url = [ [ NSURL alloc ] initWithString: @"http://www.lukeswitzer.com" ];
    
    [[UIApplication sharedApplication] openURL:url];
}
-(void)onBack:(id)sender{
    NSLog(@"Go back home");
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionUp duration:.8f]];
    [self unscheduleAllSelectors];

}





@end
