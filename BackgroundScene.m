//
//  BackgroundScene.m
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 1/29/11.
//  Copyright 2011 Dustin Atwood. All rights reserved.
//

#import "BackgroundScene.h"


@implementation BackgroundScene

@synthesize isRunning;

- (id) init
{
	if(self = [super init])
	{
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeParticleColor) name:@"PLAYER_COLOR_CHANGE" object:nil];
		
		emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"imageStar" position:Vector2fMake(160, -120) 
													sourcePositionVariance:Vector2fMake(160, 0)  
																	   speed:70.0f
															   speedVariance:35.0f
															particleLifeSpan:6 
													particleLifespanVariance:3 
																	   angle:90
															   angleVariance:0 
																	 gravity:Vector2fMake(0.0f, 0.0f) 
																  startColor:Color4fMake(1.0, 1.0, 1.0, 1.0)
														  startColorVariance:Color4fMake(0.0, 0.0, 0.0, 0.0)
																 finishColor:Color4fMake(1.0, 1.0, 1.0, 0.0)
														 finishColorVariance:Color4fMake(0.0, 0.0, 0.0, 0.0)
																maxParticles:75 
																particleSize:20 
														particleSizeVariance:10 
																	duration:-1 
															   blendAdditive:YES];
		[emitter setEmissionRate:2.5];
		
		imageBackground = [[Image alloc] initWithImageNamed:@"imageBackground"];
		[imageBackground setPosition:CGPointMake(160, 240)];
	}
	
	return self;
}

- (void) changeParticleColor
{
	NSString *cString = [[[SettingManager sharedSettingManager] forProfileGet:ProfileKey_Pet_Color] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  
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
		}
	}
}

- (void)updateWithDelta:(GLfloat)aDelta 
{
	//@synchronized(self)
	//{
		
		[emitter update:aDelta];
		
	//}
}

- (void) render
{
	//@synchronized(self)
	//{
		glPushMatrix();
		[imageBackground render];
		//if(emitter)
			
		[emitter renderParticles];
		
		glPopMatrix();
		
	//}
}

@end
