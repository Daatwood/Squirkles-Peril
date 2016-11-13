//
//  IndicatorPower.m
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 3/9/11.
//  Copyright 2011 Litlapps. All rights reserved.
//

#import "IndicatorPower.h"

@implementation IndicatorPower

@synthesize isEnabled;

- (id) initAtScreenPercentage:(CGPoint)screenPercentage
{
	if(self = [super init])
	{
		currentLevel = 0;
		
		isEnabled = TRUE;
		
		imageIndicator = [[ResourceManager sharedResourceManager] getImageWithImageNamed:@"InterfaceStarLevel" withinAtlasNamed:@"InterfaceAtlas"];
		//imageIndicator = [[ResourceManager sharedResourceManager] getImageWithImageNamed:@"InterfaceStarLevel" withinAtlasNamed:@"InterfaceAtlas"];																	   //[imageIndicatorFill setImageWidth:[imageIndicatorFill imageWidth] / 2];
		
		[self setIsEnabled:YES];
		
		font = [[AngelCodeFont alloc] initWithFontImageNamed:FONT16 controlFile:FONT16 scale:1.0 filter:GL_LINEAR];
		
		[self setAtScreenPercentage:screenPercentage];
	}
	return self;
}

- (void) setAtScreenPercentage:(CGPoint)screenPercentage
{
	positionIndicator.x = [[Director sharedDirector] screenBounds].size.width * (screenPercentage.x / 100);
	positionIndicator.y = [[Director sharedDirector] screenBounds].size.height * (screenPercentage.y / 100);
}

- (void) refresh
{
	[currentLevel release];
	currentLevel = [[NSString stringWithString:[[SettingManager sharedSettingManager] for:FileType_Character get:ProfileKey_Power]] retain];
}

- (void) refreshWithCharacterIndex:(uint)index
{
	[currentLevel release];
	currentLevel = [[NSString stringWithString:
					 [[[[SettingManager sharedSettingManager] settingsCharacters] 
					   objectAtIndex:index] objectAtIndex:ProfileKey_Power]] retain];
}

- (void) render
{
	if(![self isEnabled])
		return;
	
	[imageIndicator renderAtPoint:positionIndicator centerOfImage:YES];
	[font drawStringAt:CGPointMake(positionIndicator.x - [font getWidthForString:currentLevel] / 1.5, positionIndicator.y + [font getHeightForString:currentLevel] / 2) text:currentLevel];
}

@end
