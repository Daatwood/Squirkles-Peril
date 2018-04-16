//
//  OptionsScene.h
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 1/31/11.
//  Copyright 2011 Dustin Atwood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ButtonControl.h"
#import "Image.h"
#import "AngelCodeFont.h"
#import "PetActor.h"
#import "OptionControl.h"
#import "Common.h"
#import "CurrencyControl.h"
#import "InformativeControl.h"
#import "AbstractScene.h"
#import "LabelControl.h"
#import "ParticleEmitter.h"
#import "NetworkManager.h"

@interface OptionsScene : AbstractScene 
{
	ButtonControl* buttonBack;
	ButtonControl* buttonProfile;
	ButtonControl* buttonEffects;
	ButtonControl* buttonMusic;
	ButtonControl* buttonReset;
	ButtonControl* buttonResetConfirm;
	ButtonControl* buttonResetStop;
	
	LabelControl* labelTitle;
	LabelControl* labelProfile;
	LabelControl* labelEffects;
	LabelControl* labelMusic;
	LabelControl* labelReset;
	LabelControl* labelVersion;
}

- (void) loadMenuScene;

- (void) toggleEffects;

- (void) toggleMusic;

- (void) resetAttempt;

- (void) resetConfirm;

- (void) resetCancel;

- (void) showNewProfileName;

@end
