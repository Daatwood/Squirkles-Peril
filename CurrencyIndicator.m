//
//  CurrencyIndicator.m
//  BadBadMonkey
//
//  Created by Dustin Atwood on 1/18/11.
//  Copyright 2011 Litlapps. All rights reserved.
//

#import "CurrencyIndicator.h"


@implementation CurrencyIndicator

@synthesize isEnabled;

- (id) initAtScreenPercentage:(CGPoint)screenPercentage
{
	if ((self = [super init])) 
	{
		font = [[AngelCodeFont alloc] initWithFontImageNamed:FONT21 controlFile:FONT21 scale:1.0 filter:GL_LINEAR];
		[font setColourFilterRed:1.0 green:1.0 blue:0.0 alpha:1.0];
		imageIndicatorBackground = [[Image alloc] initWithImageNamed:@"imageCurrencyBarLarge"];
		[imageIndicatorBackground setColourFilterRed:0.0 green:0.60 blue:0.85 alpha:1.0];
		
		totalCoins = 0;
		additionCoins = 0;
		cooldownTimerCoins = 0;
		imageEmblemCoins = [[Image alloc] initWithImageNamed:@"iconCurrencyCoinLarge"];
		//[imageEmblemCoins setColourFilterRed:1.0 green:1.0 blue:0.0 alpha:1.0];
		
		totalTreats = 0;
		additionTreats = 0;
		cooldownTimerTreats = 0;
		imageEmblemTreats = [[Image alloc] initWithImageNamed:@"iconCurrencyTreatLarge"];
		//[imageEmblemTreats setColourFilterRed:0.7 green:0.5 blue:0.2 alpha:1.0];
		
		CGPoint position, position2;
		position.x = [[Director sharedDirector] screenBounds].size.width * (screenPercentage.x / 100); //+ ([imageIndicatorBackground imageWidth] / 2);
		position.y = [[Director sharedDirector] screenBounds].size.height * (screenPercentage.y / 100); //- ([imageIndicatorBackground imageHeight] / 2);
		[imageIndicatorBackground setPositionImage:position];
		position2 = position;

		// Coins
		position.x = position.x - [imageIndicatorBackground imageWidth] / 2;// + [imageEmblemCoins imageWidth] / 2;
		[imageEmblemCoins setPositionImage:position];
		positionTextCoins.x = position.x + [imageEmblemCoins imageWidth] / 2; //[font getWidthForString:@"9"] * 1.25;
		positionTextCoins.y = position.y + [font getHeightForString:@"9"] * .60;
		
		
		// Treats
		position2.x = position2.x + [imageEmblemTreats imageWidth] * 0.75;
		[imageEmblemTreats setPositionImage:position2];
		positionTextTreats.x = position2.x + [imageEmblemTreats imageWidth] / 2; //[font getWidthForString:@"9"] * 1.25;
		positionTextTreats.y = position2.y + [font getHeightForString:@"9"] * .60;
		
		[self setIsEnabled:TRUE];
	}
	return self;
}

- (void) setInitialCoins:(int)coins
{
	totalCoins = coins;
	additionCoins = 0;
	[self setIsEnabled:TRUE];
}

- (void) addCoins:(int)coins
{
	additionCoins += coins;
}

- (void) setInitialTreats:(int)treats
{
	totalTreats = treats;
	additionTreats = 0;
	[self setIsEnabled:TRUE];
}

- (void) addTreats:(int)treats
{
	additionTreats += treats;
}

- (int) infoCoins
{
	return totalCoins + additionCoins;
}

- (int) infoTreats
{
	return totalTreats + additionTreats;
}

- (void) updateWithDelta:(GLfloat)delta
{
	if(cooldownTimerCoins == 0)
	{
		if(additionCoins > 0)
		{
			totalCoins++;
			additionCoins--;
			
			cooldownTimerCoins = 0.1;
		}
		else if(additionCoins < 0)
		{
			totalCoins--;
			additionCoins++;
			
			cooldownTimerCoins = 0.1;
		}
		else 
		{
			//[imageEmblemCoins setScale:1.0f];
		}
		
	}
	else if(cooldownTimerCoins < 0)
	{
		cooldownTimerCoins = 0;
	}
	else
	{
		//[imageEmblemCoins setScale:1 + cooldownTimerCoins * 5];
		cooldownTimerCoins -= delta;
		if(cooldownTimerCoins < 0)
			cooldownTimerCoins = 0;
	}
	
	if(cooldownTimerTreats == 0)
	{
		if(additionTreats > 0)
		{
			totalTreats++;
			additionTreats--;
			
			cooldownTimerTreats = 1;
		}
		else if(additionTreats < 0)
		{
			totalTreats--;
			additionTreats++;
			
			cooldownTimerTreats = 1;
		}
		else 
		{
			//[imageEmblemTreats setScale:1.0f];
		}
		
	}
	else if(cooldownTimerTreats < 0)
	{
		cooldownTimerTreats = 0;
	}
	else
	{
		//[imageEmblemTreats setScale:1 + (cooldownTimerTreats / 2)];
		cooldownTimerTreats -= delta;
		if(cooldownTimerTreats < 0)
			cooldownTimerTreats = 0;
	}
}

- (void) render
{
	if(![self isEnabled])
		return;
	
	[imageIndicatorBackground render];
	[imageEmblemCoins render];
	[imageEmblemTreats render];
	
	
	if(totalCoins < 999999)
		[font drawStringAt:positionTextCoins text:[[NSNumber numberWithInt:totalCoins] stringValue]];
	else
		[font drawStringAt:positionTextCoins text:@"999999"];
	
	if(totalTreats < 999)
		[font drawStringAt:positionTextTreats text:[[NSNumber numberWithInt:totalTreats] stringValue]];
	else
		[font drawStringAt:positionTextTreats text:@"999999"];
}

@end
