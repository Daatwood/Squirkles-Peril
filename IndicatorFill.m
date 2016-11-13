//
//  IndicatorFill.m
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 3/10/11.
//  Copyright 2011 Litlapps. All rights reserved.
//

#import "IndicatorFill.h"

#define Fill_Max 402

@implementation IndicatorFill

@synthesize isEnabled, levelMax;

- (id) initAtScreenPercentage:(CGPoint)screenPercentage withDirection:(uint)direction
{
	if(self = [super init])
	{
		levelMax = 100;
		
		fillDirection = direction;
		
		isEnabled = TRUE;
		
		switch (fillDirection) 
		{
				// Vertical
			case 0:
			{
				imageIndicator = [[ResourceManager sharedResourceManager] getImageWithImageNamed:@"SliderVertical" withinAtlasNamed:@"InterfaceAtlas"];
				imageIndicatorFill = [[ResourceManager sharedResourceManager] getImageWithImageNamed:@"SliderVerticalFill" withinAtlasNamed:@"InterfaceAtlas"];
				[imageIndicatorFill setColourFilterRed:1.0 green:0.0 blue:0.0 alpha:1.0];
				imageIndicatorFillBackground = [[ResourceManager sharedResourceManager] getImageWithImageNamed:@"SliderVerticalFill" withinAtlasNamed:@"InterfaceAtlas"];
				break;
			}
				// Horizontal
			case 1:
			{
				NSLog(@"IndicatorFill: Horizontal is not supported");
				imageIndicator = [[ResourceManager sharedResourceManager] getImageWithImageNamed:@"SliderHorizontal" withinAtlasNamed:@"InterfaceAtlas"];
				imageIndicatorFill = [[ResourceManager sharedResourceManager] getImageWithImageNamed:@"SliderHorizontalFill" withinAtlasNamed:@"InterfaceAtlas"];
				break;
			}
			default:
			{
				NSLog(@"IndicatorFill: Invalid Direction");
				break;
			}
		}
		
		[self setIsEnabled:YES];
		
		[self setAtScreenPercentage:screenPercentage];
	}
	return self;
}

- (void) setAtScreenPercentage:(CGPoint)screenPercentage
{
	positionIndicator.x = [[Director sharedDirector] screenBounds].size.width * (screenPercentage.x / 100);
	positionIndicator.y = [[Director sharedDirector] screenBounds].size.height * (screenPercentage.y / 100);
}

- (void) setLevelCurrent:(float)currentLevel
{
	[imageIndicatorFill setImageHeight:(currentLevel / levelMax) * Fill_Max];
}

- (void) render
{
	[imageIndicatorFillBackground renderAtPoint:CGPointMake(positionIndicator.x - [imageIndicatorFill imageWidth] / 2, 13.5 + positionIndicator.y - [imageIndicator imageHeight] / 2) centerOfImage:NO];
	
	[imageIndicatorFill renderAtPoint:CGPointMake(positionIndicator.x - [imageIndicatorFill imageWidth] / 2, 13.5 + positionIndicator.y - [imageIndicator imageHeight] / 2) centerOfImage:NO];
	
	
	[imageIndicator renderAtPoint:positionIndicator centerOfImage:YES];
}

@end
