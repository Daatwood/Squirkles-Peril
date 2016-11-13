//
//  MGSkyPlatformManager.m
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 2/1/11.
//  Copyright 2011 Litlapps. All rights reserved.
//

#import "MGSkyPlatformManager.h"


@implementation MGSkyPlatformManager

- (id) init
{
	if( self = [super init])
	{
		// Allocate the memory necessary for the particle emitter arrays
		randomPlatforms = malloc( sizeof(PlatformPlacement) * 3);
		cooldownPlatforms = malloc( sizeof(PlatformPlacement) * 6);
		
		// If one of the arrays cannot be allocated, then report a warning and return nil
		if(!(randomPlatforms && cooldownPlatforms)) 
		{
			NSLog(@"WARNING: MGSkyPlatformManager - Not enough memory");
			if(randomPlatforms)
				free(randomPlatforms);
			if(cooldownPlatforms)
				free(cooldownPlatforms);
			return nil;
		}
		
		// Reset the memory used for the particles array using zeros
		bzero( randomPlatforms, sizeof(PlatformPlacement) * 3);
		bzero( cooldownPlatforms, sizeof(PlatformPlacement) * 6);
		
		randomPlatformsCount = 0;
		cooldownPlatformsCount = 0;
	}
	return self;
}

- (void) removeAllPlatforms
{
	randomPlatformsCount = 0;
	cooldownPlatformsCount = 0;
}

- (BOOL) addPlatformWithType:(int)newType
{
	// If we have already reached the maximum number of platforms then do nothing
	if(randomPlatformsCount == 3)
		return NO;
	
	// Take the next platform out of the platform pool we have created and initialize it
	PlatformPlacement *platform = &randomPlatforms[randomPlatformsCount];
	
	platform->type = newType;
	platform->cooldownCurrent = 0;
	platform->cooldownMax = 0;
	
	// Increment the platform count
	randomPlatformsCount++;
	
	// Return YES to show that a platform has been created
	return YES;
}

- (BOOL) addPlatformWithType:(int)newType andCooldown:(int)cooldown
{
	// If we have already reached the maximum number of platforms then do nothing
	if(cooldownPlatformsCount == 6)
		return NO;
	
	// Take the next platform out of the platform pool we have created and initialize it
	PlatformPlacement *platform = &cooldownPlatforms[cooldownPlatformsCount];
	
	platform->type = newType;
	platform->cooldownCurrent = cooldown;
	platform->cooldownMax = cooldown;
	
	// Increment the platform count
	cooldownPlatformsCount++;
	
	// Return YES to show that a platform has been created
	return YES;
}

- (int) pickRandom
{
	if(randomPlatformsCount == 0)
		return PlatformType_Normal;
	
	// Randomly picks a number 0 through count; count being exclusive
	int randomPlatformIndex = RANDOM(randomPlatformsCount);
	
	PlatformPlacement *platform = &randomPlatforms[randomPlatformIndex];
	
	return platform->type;
}

- (int) pickReady
{
	if(cooldownPlatformsCount == 0)
		return [self pickRandom];
	
	int cooldownPlatformsIndex = 0;
	while(cooldownPlatformsIndex < cooldownPlatformsCount) 
	{
		PlatformPlacement *currentPlatform = &cooldownPlatforms[cooldownPlatformsIndex];
		currentPlatform->cooldownCurrent--;
		
		if(currentPlatform->cooldownCurrent <= 0)
		{
			currentPlatform->cooldownCurrent = currentPlatform->cooldownMax;
			return currentPlatform->type;
		}
		
		cooldownPlatformsIndex++;
	}
	
	return [self pickRandom];
}

@end
