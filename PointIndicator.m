//
//  PointIndicator.m
//  BadBadMonkey
//
//  Created by Dustin Atwood on 1/18/11.
//  Copyright 2011 Litlapps. All rights reserved.
//

#import "PointIndicator.h"


@implementation PointIndicator

- (id) initAtScreenPercentage:(CGPoint)screenPercentage
{
	if ((self = [super init])) 
	{
		amountTotal = 0;
		amountAddition = 0;
		font = [[AngelCodeFont alloc] initWithFontImageNamed:FONT21 controlFile:FONT21 scale:1.0 filter:GL_LINEAR];
		[font setColourFilterRed:0.0 green:0.60 blue:0.85 alpha:1.0];
		cooldownTimer = 0;
		imageEmblem = [[Image alloc] initWithImageNamed:@"iconCurrencyPointLarge"];
		imageIndicatorBackground = [[Image alloc] initWithImageNamed:@"imageCurrencyBar"];
		[imageIndicatorBackground setColourFilterRed:1.0 green:1.0 blue:0.0 alpha:1.0];
		
		CGPoint position;
		position.x = [[Director sharedDirector] screenBounds].size.width * (screenPercentage.x / 100);// + ([imageIndicatorBackground imageWidth] / 2);
		position.y = [[Director sharedDirector] screenBounds].size.height * (screenPercentage.y / 100);// - ([imageIndicatorBackground imageHeight] / 2);
		[imageIndicatorBackground setPositionImage:position];
		
		position.x = position.x - [imageIndicatorBackground imageWidth] / 2; //+ [imageEmblem imageWidth] / 2;
		[imageEmblem setPositionImage:position];
		
		positionText.x = position.x + [imageEmblem imageWidth] / 2;
		positionText.y = position.y + [font getHeightForString:@"9"] * .60;
	}
	return self;
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
			amountTotal++;
			amountAddition--;
			
			cooldownTimer = 0.1;
		}
		else if(amountAddition < 0)
		{
			amountTotal--;
			amountAddition++;
			
			cooldownTimer = 0.1;
		}
	}
	else if(cooldownTimer < 0)
	{
		cooldownTimer = 0;
	}
	else
	{
		
		//[imageEmblem setAlpha:1 - cooldownTimer * 5];
		cooldownTimer -= delta;
		if(cooldownTimer < 0)
			cooldownTimer = 0;
	}
}

- (void) render
{
	[imageIndicatorBackground render];
	[imageEmblem render];
	
	if(amountTotal < 99999999)
		[font drawStringAt:positionText text:[[NSNumber numberWithInt:amountTotal] stringValue]];
	else
		[font drawStringAt:positionText text:@"99999999"];
}

@end
