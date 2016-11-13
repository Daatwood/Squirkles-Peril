//
//  LargeIndicator.m
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 2/8/11.
//  Copyright 2011 Litlapps. All rights reserved.
//

#define ValueLimit 999999999

#import "Indicator.h"


@implementation Indicator

@synthesize isEnabled;

- (id) initAtScreenPercentage:(CGPoint)screenPercentage withSize:(int)size currencyType:(int)type leftsideIcon:(BOOL)leftside
{
	if (self = [super init]) 
	{
		amountTotal = 0;
		amountAddition = 0;
		cooldownTimer = 0;
		[self setIsEnabled:YES];
		font = [[AngelCodeFont alloc] initWithFontImageNamed:FONT21 controlFile:FONT21 scale:1.0 filter:GL_LINEAR];
		
		switch (size) 
		{
			case 0:
			{
				imageIndicatorBackground = [[Image alloc] initWithImageNamed:@"imageCurrencyBarSmall"];
				break;
			}
			case 1:
			{
				imageIndicatorBackground = [[Image alloc] initWithImageNamed:@"imageCurrencyBar"];
				break;
			}
			case 2:
			{
				imageIndicatorBackground = [[Image alloc] initWithImageNamed:@"imageCurrencyBarLarge"];
				break;
			}
			default:
				break;
		}
		
		// Sets the Image based on currency type.
		switch (type) 
		{
			case CurrencyType_Coin:
			{
				imageEmblem = [[Image alloc] initWithImageNamed:@"iconCurrencyCoinLarge"];
				[font setColourFilterRed:0.0 green:0.60 blue:0.85 alpha:1.0];
				[imageIndicatorBackground setColourFilterRed:1.0 green:1.0 blue:0.0 alpha:1.0];
				break;
			}
			case CurrencyType_Treat:
			{
				imageEmblem = [[Image alloc] initWithImageNamed:@"iconCurrencyTreatLarge"];
				[font setColourFilterRed:0.0 green:0.60 blue:0.85 alpha:1.0];
				[imageIndicatorBackground setColourFilterRed:1.0 green:1.0 blue:0.0 alpha:1.0];
				break;
			}
			case CurrencyType_Boost:
			{
				imageEmblem = [[Image alloc] initWithImageNamed:@"iconCurrencyBoostLarge"];
				[font setColourFilterRed:1.0 green:0.8 blue:0.0 alpha:1.0];
				[imageIndicatorBackground setColourFilterRed:0.0 green:0.60 blue:0.85 alpha:1.0];
				break;
			}
			case CurrencyType_Point:
			{
				imageEmblem = [[Image alloc] initWithImageNamed:@"iconCurrencyPointLarge"];
				[font setColourFilterRed:1.0 green:0.8 blue:0.0 alpha:1.0];
				[imageIndicatorBackground setColourFilterRed:0.0 green:0.60 blue:0.85 alpha:1.0];
				break;
			}
			default:
				break;
		}
		
		[self setAtScreenPercentage:screenPercentage leftsideIcon:leftside];
	}
	return self;
}

- (void) setAtScreenPercentage:(CGPoint)screenPercentage leftsideIcon:(BOOL)leftside
{
	if (leftside) 
	{
		CGPoint position;
		position.x = [[Director sharedDirector] screenBounds].size.width * (screenPercentage.x / 100);// + ([imageIndicatorBackground imageWidth] / 2);
		position.y = [[Director sharedDirector] screenBounds].size.height * (screenPercentage.y / 100);// - ([imageIndicatorBackground imageHeight] / 2);
		[imageIndicatorBackground setPositionImage:position];
		
		position.x = position.x - [imageIndicatorBackground imageWidth] / 2; //+ [imageEmblem imageWidth] / 2;
		[imageEmblem setPositionImage:position];
		
		positionText.x = position.x + [imageEmblem imageWidth] / 2;
		positionText.y = position.y + [font getHeightForString:@"9"] * .60;
	}
	else
	{
		CGPoint position;
		position.x = [[Director sharedDirector] screenBounds].size.width * (screenPercentage.x / 100) - [imageEmblem imageWidth] / 2;
		position.y = [[Director sharedDirector] screenBounds].size.height * (screenPercentage.y / 100);
		[imageIndicatorBackground setPositionImage:position];
		
		position.x = position.x + [imageIndicatorBackground imageWidth] - [imageIndicatorBackground imageWidth] / 2;
		[imageEmblem setPositionImage:position];
		positionText.x = [[Director sharedDirector] screenBounds].size.width * (screenPercentage.x / 100) - [imageIndicatorBackground imageWidth] / 2 - [imageEmblem imageWidth] / 3;
		positionText.y = position.y + [font getHeightForString:@"9"] * .60;
	}
}

- (int) returnTotalPoints
{
	return amountTotal + amountAddition;
}

- (void) changeInitialValue:(int)value
{
	amountTotal = value;
	amountAddition = 0;
}

- (void) addValue:(int)value
{
	amountAddition += value;
}

- (void) updateWithDelta:(GLfloat)delta
{
	if(cooldownTimer == 0)
	{
		if(amountAddition > 0)
		{
			int reduction = ceilf(amountAddition * 0.25);
			if(reduction < 1)
				reduction = 1;
			
			amountTotal += reduction;
			amountAddition -= reduction;
			
			cooldownTimer = 0.05;
		}
		else if(amountAddition < 0)
		{
			int reduction = abs(ceilf(amountAddition * 0.25));
			if(reduction < 1)
				reduction = 1;

			amountTotal -= reduction;
			amountAddition += reduction;
			
			cooldownTimer = 0.05;
		}
	}
	else if(cooldownTimer < 0)
	{
		cooldownTimer = 0;
	}
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
	
	[imageIndicatorBackground render];
	[imageEmblem render];
	
	if(amountTotal < ValueLimit)
		[font drawStringAt:positionText text:[[NSNumber numberWithInt:amountTotal] stringValue]];
	else
		[font drawStringAt:positionText text:[[NSNumber numberWithInt:ValueLimit] stringValue]];
}

@end
