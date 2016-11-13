

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "Director.h"
#import "ResourceManager.h"
#import "SoundManager.h"
#import "SettingManager.h"
#import "Image.h"
#import "Animation.h"
#import "AngelCodeFont.h"
#import "ParticleEmitter.h"
#import "MenuControl.h"
#import "OptionsControl.h"
#import "ParticleEmitter.h"

// This is an abstract class which contains the basis for any game scene which is going
// to be used.  A game scene is a self contained class which is responsible for updating 
// the logic and rendering the screen for the current scene.  It is simply a way to 
// encapsulate a specific scenes code in a single class.
//
// The Director class controls which scene is the current scene and it is this scene which
// is updated and rendered during the game loop.
//
@interface AbstractScene : NSObject 
{
	ResourceManager *sharedResourceManager;
	SoundManager    *sharedSoundManager;
	SettingManager  *sharedSettingManager;
	CGRect          screenBounds;
	uint            sceneState;
	float           sceneAlpha;
	NSString        *nextSceneKey;
    float           sceneFadeSpeed;
	uint			sceneMode; 
	uint			screenMode;
	float			accelerometerSensitivity;
	BOOL			isInitialized;
	
	// Interface Containers
	// Button Container
	NSMutableArray  *sceneControls;
	// Image Container
	NSMutableArray	*sceneImages;
	// Label Container
	NSMutableArray *sceneLabels;
}

#pragma mark -
#pragma mark Properties

// This will allow for easier integration of the buttons, labels and others.
// Simply add the control to the array and the scene will take care of rendering,
// updating and touch events.
@property(retain) NSMutableArray *sceneControls, *sceneImages, *sceneLabels;

// When the screen shows for the first time it will make all initalizations then.
@property (nonatomic) BOOL isInitialized;

// This property allows for the scenes state to be altered
@property (nonatomic) uint sceneState;

// A scene mode is a substate of a scene. Some Modes include: 
// Normal, No special operations are taking place
// OptionControl, a option control is currently visible and present 
// Pickup Item, an item is being touch and moved around.
@property (nonatomic, assign) uint sceneMode;

@property (nonatomic, assign) uint screenMode;

// This property allows for the scenes alpha to be changed.  Any image which is being rendered
// uses the Director to get the current scene and from this it will take the current scenes
// alpha and use this when calculating its own alpha.  This allows you to fade an entire scene
// just by changing the scenes alpha and not the individual alpha of each image
@property (nonatomic, assign) GLfloat sceneAlpha;

// Determines how sensitive the accelerometer is to sudden movements
@property (nonatomic) float accelerometerSensitivity;

// MANAGE SCENE CONTROLS
- (void) removeControl:(uint)sceneControlIndentifier;
- (id) control:(uint)sceneControlIdentifier;

- (void) removeImage:(uint)sceneImageIndentifier;
- (id) image:(uint)sceneImageIndentifier;

- (void) removeLabel:(uint)sceneLabelIndentifier;
- (id) label:(uint)sceneLabelIndentifier;

// This is called when it must begin loading varibles into memory.
- (void) startLoadScene;

// This is notified when it has finished loading into memory.
- (void) finishLoadScene;

// Selector to update the scenes logic using |aDelta| which is passe in from the game loop
- (void)updateWithDelta:(GLfloat)aDelta;

// Selector that enables a touchesBegan events location to be passed into a scene.  |aTouchLocation| is 
// a CGPoint which has been encoded into an NSString
- (void)updateWithTouchLocationBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView;
- (void)updateWithTouchLocationMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView;
- (BOOL)updateWithTouchLocationEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView;
- (void)updateWithTouchLocationCancelled:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView;
// Selector which enables accelerometer data to be passed into the scene.
- (void)updateWithAccelerometer:(UIAcceleration*)aAcceleration;

// Selector that transitions from this scene to the scene with the key specified.  This allows the current
// scene to perform a transition action before the current scene within the Director is changed.
- (void)transitionToSceneWithKey:(NSString*)aKey;

- (void)transitioningToCurrentScene;

// Selector which renders the scene
- (void)render;
@end
