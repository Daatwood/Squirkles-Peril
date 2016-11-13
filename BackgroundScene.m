//
//  BackgroundScene.m
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 1/29/11.
//  Copyright 2011 Litlapps. All rights reserved.
//

#import "BackgroundScene.h"


@implementation BackgroundScene

@synthesize isRunning;

- (id) init
{
	if((self = [super init]))
	{
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeParticleColor) name:@"PLAYER_COLOR_CHANGE" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopBackground) name:@"STOP_BACKGROUND" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startBackground) name:@"START_BACKGROUND" object:nil];
		
        /*
		Color4f aColor;
		int rndColor = RANDOM(3);
		if(rndColor == 0)
			aColor = Color4fMake(0.75 + RANDOM_0_TO_1() / 4, RANDOM_0_TO_1(), RANDOM_0_TO_1(), 1.0f);
		else if(rndColor == 1)
			aColor = Color4fMake(RANDOM_0_TO_1(), 0.75 + RANDOM_0_TO_1() / 4, RANDOM_0_TO_1(), 1.0f);
		else if(rndColor == 2)
			aColor = Color4fMake(RANDOM_0_TO_1(), RANDOM_0_TO_1(), 0.75 + RANDOM_0_TO_1() / 4, 1.0f);
		*/
		emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"imageStar" position:Vector2fMake(160, -120) 
													sourcePositionVariance:Vector2fMake(160, 0)  
																	   speed:70.0f
															   speedVariance:35.0f
															particleLifeSpan:6 
													particleLifespanVariance:3 
																	   angle:90
															   angleVariance:0 
																	 gravity:Vector2fMake(0.0f, 0.0f) 
																  startColor:Color4fMake(0.0, 0.0, 0.0, 1.0)
														  startColorVariance:Color4fMake(1.0, 1.0, 1.0, 0.0)
																 finishColor:Color4fMake(0.0, 0.0, 0.0, 0.0)
														 finishColorVariance:Color4fMake(1.0, 1.0, 1.0, 0.0)
																maxParticles:75 
																particleSize:20 
														particleSizeVariance:10 
																	duration:-1 
															   blendAdditive:TRUE];
		//[emitter setRandomColors:TRUE];
		[emitter setEmissionRate:2.5];
		
		imageBackground = [[Image alloc] initWithImageNamed:@"BackgroundTexture"];
		[imageBackground setPositionImage:CGPointMake(160, 240)];
		//[imageBackground setColourWithColor4f:aColor];
		//[imageBackground setColourFilterRed:0.0 green:1.0 blue:0.0 alpha:1.0];
		[self setIsRunning:TRUE];
	}
	
	return self;
}

- (void) stopBackground
{
	[self setIsRunning:FALSE];
}

- (void) startBackground
{
	[self setIsRunning:TRUE];
}

- (void) changeParticleColor
{
	NSString *cString = [[[SettingManager sharedSettingManager] for:FileType_Character get:ProfileKey_Color] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  
	//[imageBackground setColourWithString:cString];
	// Proper color strings are denoted with braces  
	if ([cString hasPrefix:@"{"] && [cString hasSuffix:@"}"])
	{
		// Remove braces      
		cString = [cString substringFromIndex:1];  
		cString = [cString substringToIndex:([cString length] - 1)];  
		
		// Separate into components by removing commas and spaces  
		NSArray *components = [cString componentsSeparatedByString:@", "];
		
		if ([components count] == 3) 
		{
			[emitter setStartColor:Color4fMake([[components objectAtIndex:0] floatValue], 
											   [[components objectAtIndex:1] floatValue], 
											   [[components objectAtIndex:2] floatValue], 
											   1.0)];
			[emitter setFinishColor:Color4fMake([[components objectAtIndex:0] floatValue], 
											   [[components objectAtIndex:1] floatValue], 
											   [[components objectAtIndex:2] floatValue], 
											   0.0)];
            
            [imageBackground setColourWithColor4f:Color4fMake(1.0 - [[components objectAtIndex:0] floatValue], 
                                                              1.0 - [[components objectAtIndex:1] floatValue], 
                                                              1.0 - [[components objectAtIndex:2] floatValue], 
                                                              1.0)];
            
		}
	}
}

- (void)updateWithDelta:(GLfloat)aDelta 
{
	if(!isRunning)
		return;
    
    [emitter update:aDelta];
}

- (void) render
{
	if(!isRunning)
		return;
	
    glPushMatrix();
    [imageBackground render];
    
    if([[SettingManager sharedSettingManager] isPremium])
		[emitter renderParticles];
		
    glPopMatrix();
}

@end
