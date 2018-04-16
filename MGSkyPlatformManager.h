//
//  MGSkyPlatformManager.h
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 2/1/11.
//  Copyright 2011 Dustin Atwood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"

typedef struct _PlatformPlacement 
{
	int type;
	int cooldownCurrent;
	int cooldownMax;
	
} PlatformPlacement;

@interface MGSkyPlatformManager : NSObject 
{
	// An array of Platform Types;
	// Holds Value if they
	PlatformPlacement *randomPlatforms;
	int randomPlatformsCount;
	PlatformPlacement *cooldownPlatforms;
	int cooldownPlatformsCount;
}

- (id) init;

- (BOOL) addPlatformWithType:(int)newType;

- (BOOL) addPlatformWithType:(int)newType andCooldown:(int)cooldown;

- (void) removeAllPlatforms;

- (int) pickRandom;

- (int) pickReady;

@end
