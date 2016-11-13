//
//  BackgroundScene.h
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 1/29/11.
//  Copyright 2011 Litlapps. All rights reserved.
//


// This is a scene that continuously runs in the background.

#import <Foundation/Foundation.h>
#import "Common.h"
#import "ParticleEmitter.h"
#import "Image.h"
#import "SettingManager.h"

@interface BackgroundScene : NSObject 
{
	ParticleEmitter* emitter;
	Image* imageBackground;
	
	BOOL isRunning;
}
@property(nonatomic) BOOL isRunning;

- (void)updateWithDelta:(GLfloat)aDelta;

- (void) changeParticleColor;

- (void) stopBackground;

- (void) startBackground;

- (void) render;

@end
