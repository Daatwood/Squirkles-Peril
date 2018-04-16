//
//  OGLGameController.h
//  OGLGame
//
//  Created by Dustin Atwood on 08/05/2009.
//  Copyright 2009 Dustin Atwood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "AccelerometerSimulation.h"
#import "ResourceManager.h"
#import "SoundManager.h"
#import "Image.h"
#import "AbstractScene.h"
#import "ArcadeScene.h"
#import "StylizeScene.h"
#import "MenuScene.h"
#import "OptionsScene.h"
#import "StageScene.h"
#import "SideScrollerScene.h"
#import "JumpScrollerScene.h"
#import "BackgroundScene.h"
#import "StoreScene.h"


@class EAGLView;

@interface OGLGameController : UIView <UIAccelerometerDelegate> {
	/* State to define if OGL has been initialised or not */
	BOOL glInitialised;
	
	// Grab the bounds of the screen
	CGRect screenBounds;
	
	// Accelerometer fata
	UIAccelerationValue _accelerometer[3];
	
	BackgroundScene* backgroundScene;
	
	// Shared resource manager
	ResourceManager *_resourceManager;
	
	// Shared sound manager
	SoundManager *_soundManager;
	
	// Current screne mode
	GLuint screenMode;
}

@property (nonatomic, retain) BackgroundScene *backgroundScene;

- (id)init;
- (void)initOpenGL;
- (void)renderScene;
- (void)updateScene:(GLfloat)aDelta;

- (void)updateScreenMode;
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView;
- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView;
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView;
- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView;

@end
