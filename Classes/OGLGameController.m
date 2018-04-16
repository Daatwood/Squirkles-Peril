//
//  OGLGameController.m
//  OGLGame
//
//  Created by Dustin Atwood on 08/05/2009.
//  Copyright 2009 Dustin Atwood. All rights reserved.
//

#import "OGLGameController.h"
#import "Common.h"
#import "EAGLView.h"

@interface OGLGameController (Private)

@end

@implementation OGLGameController

@synthesize backgroundScene;

#pragma mark - 
#pragma mark Dealloc

- (void)dealloc 
{
	[_soundManager shutdownSoundManager];
	[_resourceManager dealloc];
    [super dealloc];
}

#pragma mark -
#pragma mark Initialize the game

- (id)init {
	
	if(self == [super init]) {	
		// Get the shared instance from the SingletonGameState class.  This will provide us with a static
		// class that can track game and OpenGL state
		_resourceManager = [ResourceManager sharedResourceManager];
		_soundManager = [SoundManager sharedSoundManager];
		
		screenMode = PORTRATE_MODE;
		
		// Initialize OpenGL
		[self initOpenGL];
		
		backgroundScene = [[BackgroundScene alloc] init];
		
		// Initialize the game states and add them to the Director class
		AbstractScene *scene = [[MenuScene alloc] init];
		[[Director sharedDirector] addSceneWithKey:SCENEKEY_MENU scene:scene];
        [scene release];
		
		scene = [[OptionsScene alloc] init];
		[[Director sharedDirector] addSceneWithKey:SCENEKEY_OPTIONS scene:scene];
		[scene release];
		
		scene = [[StoreScene alloc] init];
		[[Director sharedDirector] addSceneWithKey:SCENEKEY_STORE scene:scene];
		[scene release];
		
		scene = [[ArcadeScene alloc] init];
		[[Director sharedDirector] addSceneWithKey:SCENEKEY_ARCADE scene:scene];
		[scene release];
		
		scene = [[StylizeScene alloc] init];
		[[Director sharedDirector] addSceneWithKey:SCENEKEY_STYLIZE scene:scene];
		[scene release];
		
		scene = [[SideScrollerScene alloc] init];
		[[Director sharedDirector] addSceneWithKey:GAMEKEY_ESCAPE scene:scene];
		[scene release];
		
		scene = [[JumpScrollerScene alloc] init];
		[[Director sharedDirector] addSceneWithKey:GAMEKEY_SKY scene:scene];
		[scene release];
		
		// Make sure glInitialised is set to NO so that OpenGL gets initialised when the first scene is rendered
		glInitialised = NO;

		// Set the initial game state
		[[Director sharedDirector] setCurrentSceneToSceneWithKey:SCENEKEY_MENU];
		[[[Director sharedDirector] currentScene] setSceneState:SceneState_TransitionIn];
		
		[[SettingManager sharedSettingManager] loadPreviousGameFile];
		
	}
	return self;
}

#pragma mark -
#pragma mark Initialize OpenGL settings

- (void)initOpenGL 
{
	
	screenBounds = [[UIScreen mainScreen] bounds];
	
	// Switch to GL_PROJECTION matrix mode and reset the current matrix with the identity matrix
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	
	
	// Rotate the entire view 90 degrees to the left to handle the phone being in landscape mode
	if(!PORTRATE_MODE) {
		glRotatef(-90.0f, 0, 0, 1);
	
		// Setup Ortho for the current matrix mode.  This describes a transformation that is applied to
		// the projection.  For our needs we are defining the fact that 1 pixel on the screen is equal to
		// one OGL unit by defining the horizontal and vertical clipping planes to be from 0 to the views
		// dimensions.  The far clipping plane is set to -1 and the near to 1.  The height and width have
		// been swapped to handle the phone being in landscape mode
		glOrthof(0, screenBounds.size.height, 0, screenBounds.size.width, -1, 1);
	} else {
		glOrthof(0, screenBounds.size.width, 0, screenBounds.size.height, -1, 1);
	}
	 
	//[self updateScreenMode];
	
	// Switch to GL_MODELVIEW so we can now draw our objects
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
	// Setup how textures should be rendered i.e. how a texture with alpha should be rendered ontop of
	// another texture.
	glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_BLEND_SRC);
	
	// We are not using the depth buffer in our 2D game so depth testing can be disabled.  If depth
	// testing was required then a depth buffer would need to be created as well as enabling the depth
	// test
	glDisable(GL_DEPTH_TEST);
	
	// Set the colour to use when clearing the screen with glClear
	glClearColor(0.02,0.02,0.02, [Director sharedDirector].globalBackgroundColor.alpha);
	
	// Mark OGL as initialised
	glInitialised = YES;
}

- (void)updateScreenMode
{
	// Rotate the entire view 90 degrees to the left to handle the phone being in landscape mode
	if(screenMode == 0) 
	{
		glRotatef(-90.0f, 0, 0, 1);
		
		// Setup Ortho for the current matrix mode.  This describes a transformation that is applied to
		// the projection.  For our needs we are defining the fact that 1 pixel on the screen is equal to
		// one OGL unit by defining the horizontal and vertical clipping planes to be from 0 to the views
		// dimensions.  The far clipping plane is set to -1 and the near to 1.  The height and width have
		// been swapped to handle the phone being in landscape mode
		glOrthof(0, screenBounds.size.height, 0, screenBounds.size.width, -1, 1);
	} 
	else 
	{
		glOrthof(0, screenBounds.size.width, 0, screenBounds.size.height, -1, 1);
	}
}

#pragma mark -
#pragma mark Update the game scene logic

- (void)updateScene:(GLfloat)aDelta 
{
	if([[Director sharedDirector] screenMode] != screenMode)
	{
		screenMode = [[Director sharedDirector] screenMode];
		//[self updateScreenMode];
	}
	//[backgroundScene updateWithDelta:aDelta];
	
	// Update the games logic based for the current scene
	[[[Director sharedDirector] currentScene] updateWithDelta:aDelta];

}


#pragma mark -
#pragma mark Render the scene

- (void)renderScene 
{
	glViewport(0, 0, 320 , 480);
	glClear(GL_COLOR_BUFFER_BIT);
	
	[backgroundScene render];
	
	if([[[Director sharedDirector] backgroundSpinner] isHidden])
		[[[Director sharedDirector] currentScene] render];
}

#pragma mark -
#pragma mark Touches

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
	[[[Director sharedDirector] currentScene] updateWithTouchLocationBegan:touches withEvent:event view:aView];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
	[[[Director sharedDirector] currentScene] updateWithTouchLocationMoved:touches withEvent:event view:aView];

}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView 
{
	[[[Director sharedDirector] currentScene] updateWithTouchLocationEnded:touches withEvent:event view:aView];
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView 
{
	//NSLog(@"Cancelling Touch GameController");
	[[[Director sharedDirector] currentScene] updateWithTouchLocationCancelled:touches withEvent:event view:aView];
}


#pragma mark -
#pragma mark Accelerometer

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    [[[Director sharedDirector] currentScene] updateWithAccelerometer:acceleration];
}

@end
