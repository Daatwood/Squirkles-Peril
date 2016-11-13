//
//  BoostIndicator.m
//  BadBadMonkey
//
//  Created by Dustin Atwood on 1/18/11.
//  Copyright 2011 Litlapps. All rights reserved.
//

#import "BoostIndicator.h"


@implementation BoostIndicator

- (id) initBoost:(int)boost atScreenPercentage:(CGPoint)screenPercentage
{
	if ((self = [super init])) 
	{
		amountTotal = boost;
		amountAddition = 0;
		font = [[AngelCodeFont alloc] initWithFontImageNamed:FONT21 controlFile:FONT21 scale:1.0 filter:GL_LINEAR];
		[font setColourFilterRed:0.0 green:0.60 blue:0.85 alpha:1.0];
		cooldownTimer = 0;
		imageEmblem = [[Image alloc] initWithImageNamed:@"iconCurrencyBoostLarge"];
		imageIndicatorBackground = [[Image alloc] initWithImageNamed:@"imageCurrencyBarSmall"];
		[imageIndicatorBackground setColourFilterRed:0.5 green:1.0 blue:0.0 alpha:1.0];
		
		CGPoint position;
		position.x = [[Director sharedDirector] screenBounds].size.width * (screenPercentage.x / 100);
		position.y = [[Director sharedDirector] screenBounds].size.height * (screenPercentage.y / 100);
		[imageIndicatorBackground setPositionAtScreenPrecentage:screenPercentage];
		
		position.x = position.x - [imageIndicatorBackground imageWidth] / 2 + [imageEmblem imageWidth] / 3;
		[imageEmblem setPositionImage:position];
		
		positionText.x = position.x + [imageEmblem imageWidth] / 2; //[font getWidthForString:@"9"] * 1.25;
		positionText.y = position.y + [font getHeightForString:@"9"] * .60;
	}
	return self;
}

- (void) changeInitialBoost:(int)boost
{
	amountTotal = boost;
	amountAddition = 0;
}

- (void) addBoost:(int)boost
{
	amountAddition += boost;
}

- (void) updateWithDelta:(GLfloat)delta
{
	if(cooldownTimer == 0)
	{
		if(amountAddition > 0)
		{
			amountTotal++;
			amountAddition--;
		
			cooldownTimer = 1;
		}
		else if(amountAddition < 0)
		{
			amountTotal--;
			amountAddition++;
			
			cooldownTimer = 1;
		}
		else 
		{
			//[imageEmblem setScale:1.0f];
		}

	}
	else if(cooldownTimer < 0)
	{
		cooldownTimer = 0;
	}
	else
	{
		//[imageEmblem setScale:1 + (cooldownTimer / 2)];
		cooldownTimer -= delta;
		if(cooldownTimer < 0)
			cooldownTimer = 0;
	}
}

- (void) render
{
	[imageIndicatorBackground render];
	[imageEmblem render];
	
	if(amountTotal < 999)
		[font drawStringAt:positionText text:[[NSNumber numberWithInt:amountTotal] stringValue]];
	else
		[font drawStringAt:positionText text:@"999"];
}


@end
