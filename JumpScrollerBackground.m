//
//  JumpScrollerBackground.m
//  BadBadMonkey
//
//  Created by Dustin Atwood on 12/31/10.
//  Copyright 2010 Litlapps. All rights reserved.
//

#import "JumpScrollerBackground.h"


@implementation JumpScrollerBackground

@synthesize offsetMax, offsetCurrent, offsetAdditional, offset, level, colorTop, colorBottom;

- (id) init
{
	if((self = [super init]))
	{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBackgroundColor) name:@"PLAYER_COLOR_CHANGE" object:nil];
		
        
		offsetMax = 100;
		offsetCurrent = 0;
		offsetAdditional = 0;
		offset = 0;
		
		cooldownTimer = 0;
		
		imageBackground = [[Image alloc] initWithImageNamed:@"BackgroundTexture"];
        [self changeBackgroundColor];
	}
	return self;
}

- (void) reset
{
    [self setOffsetCurrent:0];
	[self setOffsetAdditional:0];
	[self setOffset:0];
}

- (void) changeBackgroundColor
{
    NSString* colorString = [[SettingManager sharedSettingManager] for:FileType_Character get:ProfileKey_Color];
    
    colorTop = Color4fMake(1.0f, 1.0f, 1.0f, 1.0f);
    
    // Proper color strings are denoted with braces  
    if ([colorString hasPrefix:@"{"] && [colorString hasSuffix:@"}"])
    {
        // Remove braces      
        colorString = [colorString substringFromIndex:1];  
        colorString = [colorString substringToIndex:([colorString length] - 1)];  
        
        // Separate into components by removing commas and spaces  
        NSArray *components = [colorString componentsSeparatedByString:@", "];
        
        if ([components count] == 3) 
        {
            colorTop = Color4fMake(1.0 - [[components objectAtIndex:0] floatValue], 
                                   1.0 - [[components objectAtIndex:1] floatValue], 
                                   1.0 - [[components objectAtIndex:2] floatValue], 
                                   1.0);
        }
    }
    colorBottom = colorTop;
}

- (void) increaseBy:(float)amount
{
	offsetCurrent += amount;
   
}

- (void) updateWithDelta:(float)delta
{
	if(cooldownTimer == 0)
	{
        offset = (offsetCurrent / offsetMax) * 960;
		if (offset > 960) 
		{
			[[NSNotificationCenter defaultCenter] postNotificationName:@"INCREASE_GAME_STAGE" object:nil];
            [[SettingManager sharedSettingManager] forPlayerAdjustBoostBy:1];
			offset = 0;
			offsetCurrent = 0;
		}
		
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
	[imageBackground setColourWithColor4f:colorBottom];
	[imageBackground renderAtPoint:CGPointMake(-320, 0 - offset - 240) centerOfImage:NO];
	[imageBackground renderAtPoint:CGPointMake(320, 0 - offset - 240) centerOfImage:NO];
	
	[imageBackground setColourWithColor4f:colorTop];
	[imageBackground renderAtPoint:CGPointMake(-320, 960 - offset - 240) centerOfImage:NO];
	[imageBackground renderAtPoint:CGPointMake(320, 960 - offset - 240) centerOfImage:NO];
    
    //[imageOverlay renderAtPoint:CGPointMake(160, 240) centerOfImage:YES];
}

@end
