//
//  OptionsScene
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 1/31/11.
//  Copyright 2011 Litlapps. All rights reserved.
//

#import "OptionsControl.h"


@implementation OptionsControl

// Make this class a singleton class
SYNTHESIZE_SINGLETON_FOR_CLASS(OptionsControl);

- (id) init
{
	self = [super init];
	if (self != nil) 
	{
		NSLog(@"Option Scene Initializing...");
		buttonClose = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonNormal" withText:@"Close" withFontName:FONT21
											atScreenPercentage:CGPointMake(50, 11)];
		[buttonClose setTarget:self andAction:@selector(hideOptions)];
		[buttonClose setButtonColourFilterRed:1.0 green:0.0 blue:0.0 alpha:1.0];
		
		
		buttonSound = [[ButtonControl alloc] initAsButtonImageNamed:@"iconSoundOn" withText:@"" withFontName:FONT21
											atScreenPercentage:CGPointMake(70, 65)];
		[buttonSound setTarget:self andAction:@selector(toggleEffects)];
		
		buttonMusic = [[ButtonControl alloc] initAsButtonImageNamed:@"iconMusicOn" withText:@"" withFontName:FONT21
											atScreenPercentage:CGPointMake(30, 65)];
		[buttonMusic setTarget:self andAction:@selector(toggleMusic)];
		
		buttonTwitter = [[ButtonControl alloc] initAsButtonImageNamed:@"iconTwitter" withText:@"" withFontName:FONT21
												 atScreenPercentage:CGPointMake(70, 46)];
		[buttonTwitter setTarget:self andAction:@selector(toggleEffects)];
		
		buttonFacebook = [[ButtonControl alloc] initAsButtonImageNamed:@"iconFacebook" withText:@"" withFontName:FONT21
												 atScreenPercentage:CGPointMake(30, 46)];
		[buttonFacebook setTarget:self andAction:@selector(toggleEffects)];
		
		buttonGameCenter = [[ButtonControl alloc] initAsButtonImageNamed:@"iconOpenFeint" withText:@"" withFontName:FONT21
												 atScreenPercentage:CGPointMake(30, 26)];
		[buttonGameCenter setTarget:self andAction:@selector(toggleEffects)];
		
		buttonOpenFeint = [[ButtonControl alloc] initAsButtonImageNamed:@"iconOpenFeint" withText:@"" withFontName:FONT21
												 atScreenPercentage:CGPointMake(70, 26)];
		[buttonOpenFeint setTarget:self andAction:@selector(toggleEffects)];
		
		//imageBackground = [[Image alloc] initWithImageNamed:@"BackgroundOptions"];
		//[imageBackground setPositionAtScreenPrecentage:CGPointMake(50, 50)];
		
		[super setVisible:FALSE];
	}
	return self;
}

- (void) showOptions
{
	if([super visible])
		return;
	
	[super setVisible:TRUE];

	[[NSNotificationCenter defaultCenter] postNotificationName:@"APPLICATION_RESIGN_ACTIVE" object:nil];
	
	// Effects
	if([[[SettingManager sharedSettingManager] for:FileType_Application get:ProfileKey_Effects] intValue] == 1)
		[buttonSound setButtonImageNamed:@"iconSoundOn" withSubImageNamed:nil];
	else
		[buttonSound setButtonImageNamed:@"iconSoundOff" withSubImageNamed:nil];
	
	// Music
	if([[[SettingManager sharedSettingManager] for:FileType_Application get:ProfileKey_Music] intValue] == 1)
		[buttonMusic setButtonImageNamed:@"iconMusicOn" withSubImageNamed:nil];
	else
		[buttonMusic setButtonImageNamed:@"iconMusicOff" withSubImageNamed:nil];
}

- (void) hideOptions
{
	[super setVisible:FALSE];
}

- (void) toggleEffects
{
	if([[[SettingManager sharedSettingManager] for:FileType_Application get:ProfileKey_Effects] intValue] == 0)
	{
		
		[[SettingManager sharedSettingManager] for:FileType_Application set:ProfileKey_Effects to:@"1"];
		[buttonSound setButtonImageNamed:@"iconSoundOn" withSubImageNamed:nil];
	}
	else
	{
		[[SettingManager sharedSettingManager] for:FileType_Application set:ProfileKey_Effects to:@"0"];
		[buttonSound setButtonImageNamed:@"iconSoundOff" withSubImageNamed:nil];
	}
}

- (void) toggleMusic
{
	if([[[SettingManager sharedSettingManager] for:FileType_Application get:ProfileKey_Music] intValue] == 0)
	{
		[[SettingManager sharedSettingManager] for:FileType_Application set:ProfileKey_Music to:@"1"];
		[buttonMusic setButtonImageNamed:@"iconMusicOn" withSubImageNamed:nil];
	}
	else
	{
		[[SettingManager sharedSettingManager] for:FileType_Application set:ProfileKey_Music to:@"0"];
		[buttonMusic setButtonImageNamed:@"iconMusicOff" withSubImageNamed:nil];
	}
}

- (void)updateWithDelta:(GLfloat)aDelta 
{
	if(![super visible])
		return;
	
	[buttonSound updateWithDelta:aDelta];
	[buttonMusic updateWithDelta:aDelta];
	[buttonClose updateWithDelta:aDelta];
	[buttonTwitter updateWithDelta:aDelta];
	[buttonFacebook updateWithDelta:aDelta];
	[buttonGameCenter updateWithDelta:aDelta];
	[buttonOpenFeint updateWithDelta:aDelta];
}

- (void) touchBeganAtPoint:(CGPoint)beginPoint
{
	if(![super visible])
		return;
	
	[buttonSound touchBeganAtPoint:beginPoint];
	[buttonMusic touchBeganAtPoint:beginPoint];
	[buttonClose touchBeganAtPoint:beginPoint];
	[buttonTwitter touchBeganAtPoint:beginPoint];
	[buttonFacebook touchBeganAtPoint:beginPoint];
	[buttonGameCenter touchBeganAtPoint:beginPoint];
	[buttonOpenFeint touchBeganAtPoint:beginPoint];
}

- (void) touchMovedAtPoint:(CGPoint)newPoint
{
	if(![super visible])
	return;
	
	[buttonSound touchMovedAtPoint:newPoint];
	[buttonMusic touchMovedAtPoint:newPoint];
	[buttonClose touchMovedAtPoint:newPoint];
	[buttonTwitter touchMovedAtPoint:newPoint];
	[buttonFacebook touchMovedAtPoint:newPoint];
	[buttonGameCenter touchMovedAtPoint:newPoint];
	[buttonOpenFeint touchMovedAtPoint:newPoint];
}

- (void) touchEndedAtPoint:(CGPoint)endPoint
{
	if(![super visible])
		return;
	
	[buttonSound touchEndedAtPoint:endPoint];
	[buttonMusic touchEndedAtPoint:endPoint];
	[buttonClose touchEndedAtPoint:endPoint];
	[buttonTwitter touchEndedAtPoint:endPoint];
	[buttonFacebook touchEndedAtPoint:endPoint];
	[buttonGameCenter touchEndedAtPoint:endPoint];
	[buttonOpenFeint touchEndedAtPoint:endPoint];
}

- (void)render 
{
	if(![super visible])
		return;
	
	//[imageBackground render];
			
	[buttonSound render];
	[buttonMusic render];
	[buttonClose render];
	[buttonTwitter render];
	[buttonFacebook render];
	[buttonGameCenter render];
	[buttonOpenFeint render];
}

@end
