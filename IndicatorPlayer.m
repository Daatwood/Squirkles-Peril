//
//  IndicatorPlayer.m
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 3/8/11.
//  Copyright 2011 Litlapps. All rights reserved.
//

#define Fill_Width 164

#import "IndicatorPlayer.h"

@implementation IndicatorPlayer

@synthesize isEnabled;

- (id) init
{
	if((self = [super init]))
	{
		totalCoin = 0;
		additionCoin = 0;
		totalBoost = 0;
		additionBoost = 0;
		totalExperience = 0;
		additionExperience = 0;
		currentLevel = 0;
		
		imageIndicator = [[ResourceManager sharedResourceManager] getImageWithImageNamed:@"InterfaceInfo" withinAtlasNamed:@"InterfaceAtlas"];
		imageIndicatorFill = [[ResourceManager sharedResourceManager] getImageWithImageNamed:@"InterfaceInfoFill" withinAtlasNamed:@"InterfaceAtlas"];
		imageIndicatorFillBackground = [[ResourceManager sharedResourceManager] getImageWithImageNamed:@"InterfaceInfoFill" withinAtlasNamed:@"InterfaceAtlas"];
		[imageIndicatorFill setColourFilterRed:0 green:1.0 blue:0.0 alpha:1.0];
		//imageIndicatorFill = [[ResourceManager sharedResourceManager] getImageWithImageNamed:@"InterfaceInfoFill" withinAtlasNamed:@"InterfaceAtlas"];
		//[imageIndicatorFill setImageWidth:[imageIndicatorFill imageWidth] / 2];
		
		cooldownTimer = 0;
		[self setIsEnabled:YES];
	
		font = [[AngelCodeFont alloc] initWithFontImageNamed:FONT16 controlFile:FONT16 scale:1.0 filter:GL_LINEAR];
		
		[self setAtScreenPercentage:CGPointMake(64.8, 90)];
	}
	return self;
}

- (void) setAtScreenPercentage:(CGPoint)screenPercentage
{
	positionIndicator.x = [[Director sharedDirector] screenBounds].size.width * (screenPercentage.x / 100);// + ([imageIndicatorBackground imageWidth] / 2);
	positionIndicator.y = [[Director sharedDirector] screenBounds].size.height * (screenPercentage.y / 100);// - ([imageIndicatorBackground imageHeight] / 2);
	
	positionLevelString.x = positionIndicator.x - 85 - [font getWidthForString:@"1"] * 1.85;
	positionLevelString.y = positionIndicator.y + 38 - [font getHeightForString:@"9"];

	positionCoinString.x = positionIndicator.x + 70 - [font getWidthForString:@"9"];
	positionCoinString.y = positionIndicator.y + 55 - [font getHeightForString:@"9"];

	positionBoostString.x = positionIndicator.x + 80 - [font getWidthForString:@"9"];
	positionBoostString.y = positionIndicator.y + 10 - [font getHeightForString:@"9"];

}

- (void) refresh
{
	[self refreshWithCharacterIndex:
	 [[[SettingManager sharedSettingManager] for:FileType_Player get:ProfileKey_Character] intValue]];
}

- (void) refreshWithCharacterIndex:(uint)index
{
	//NSLog(@"c: %@", [[[[SettingManager sharedSettingManager] settingsCharacters] objectAtIndex:index] description]);
	
	totalCoin = [[[SettingManager sharedSettingManager] for:FileType_Player get:ProfileKey_Coins] intValue];
	totalBoost = [[[SettingManager sharedSettingManager] for:FileType_Player get:ProfileKey_Boost] intValue];
	totalExperience = [[[[[SettingManager sharedSettingManager] settingsCharacters] objectAtIndex:index] objectAtIndex:ProfileKey_Experience] intValue];
	currentLevel = [[[[[SettingManager sharedSettingManager] settingsCharacters] objectAtIndex:index] objectAtIndex:ProfileKey_Power] intValue];
	
	float percentage = totalExperience;
	[imageIndicatorFill setImageWidth:(percentage / (currentLevel * 30 * 1.10)) * Fill_Width];
	
	positionCoinString.x = positionIndicator.x + [imageIndicator imageWidth]/2 - [font getWidthForString:[[NSNumber numberWithInt:totalCoin] stringValue]];
	positionCoinString.y = positionIndicator.y + 55 - [font getHeightForString:[[NSNumber numberWithInt:totalCoin] stringValue]];
	
	positionLevelString.x = 117.5 - [font getWidthForString:[[NSNumber numberWithInt:currentLevel] stringValue]]/2;
	positionLevelString.y = 438 + [font getHeightForString:[[NSNumber numberWithInt:currentLevel] stringValue]] / 2;

	positionBoostString.x = positionIndicator.x + [imageIndicator imageWidth]/2 - [font getWidthForString:@"000"] * .85;
	positionBoostString.y = positionIndicator.y - [font getHeightForString:[[NSNumber numberWithInt:totalBoost] stringValue]] / 2;
}

- (void) addCoinValue:(int)value
{
	additionCoin += value;
}

- (void) addBoostValue:(int)value
{
	additionBoost += value;
}

- (void) addExpValue:(int)value
{
	additionExperience += value;
}

- (int) returnTotalCoins
{
	return totalCoin + additionCoin;
}

- (int) returnTotalBoost
{
	return totalBoost + additionBoost;
}

- (int) returnTotalExp
{
	return totalExperience;
}

- (void) updateWithDelta:(GLfloat)delta
{
	if(cooldownTimer == 0)
	{
        [self refresh];
        /*
       // [imageIndicatorFill setImageWidth:(totalExperience / (currentLevel * 30 * 1.10)) * Fill_Width];
		
		if(additionCoin > 0)
		{
			int reduction = ceilf(additionCoin * 0.25);
			if(reduction < 1)
				reduction = 1;
			totalCoin += reduction;
			additionCoin -= reduction;
		}
		else if(additionCoin < 0)
		{
			int reduction = abs(ceilf(additionCoin * 0.25));
			if(reduction < 1)
				reduction = 1;
			totalCoin -= reduction;
			additionCoin += reduction;
		}
		
		if(additionBoost > 0)
		{
			int reduction = ceilf(additionBoost * 0.25);
			if(reduction < 1)
				reduction = 1;
			totalBoost += reduction;
			additionBoost -= reduction;
		}
		else if(additionBoost < 0)
		{
			int reduction = abs(ceilf(additionBoost * 0.25));
			if(reduction < 1)
				reduction = 1;
			totalBoost -= reduction;
			additionBoost += reduction;
		}
		*/
		cooldownTimer = 0.05;
	}
	else if(cooldownTimer < 0)
		cooldownTimer = 0;
	else
	{
		cooldownTimer -= delta;
		if(cooldownTimer < 0)
			cooldownTimer = 0;
	}
}

- (void) render
{
	if(![self isEnabled])
		return;
	
	[imageIndicatorFillBackground renderAtPoint:CGPointMake(40 + positionIndicator.x - [imageIndicator imageWidth] / 2, positionIndicator.y - [imageIndicatorFill imageHeight] / 2 + 1) centerOfImage:NO];
	[imageIndicatorFill renderAtPoint:CGPointMake(40 + positionIndicator.x - [imageIndicator imageWidth] / 2, positionIndicator.y - [imageIndicatorFill imageHeight] / 2 + 1) centerOfImage:NO];
	[imageIndicator renderAtPoint:positionIndicator centerOfImage:YES];
	
	[font setLeftAlignment:FALSE];
	[font drawStringAt:positionCoinString text:[[NSNumber numberWithInt:totalCoin] stringValue]];
	[font drawStringAt:positionBoostString text:[[NSNumber numberWithInt:totalBoost] stringValue]];
	
	[font setLeftAlignment:TRUE];
	[font drawStringAt:positionLevelString text:[[NSNumber numberWithInt:currentLevel] stringValue]];
}

@end
