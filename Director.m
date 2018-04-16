
#include <stdlib.h>
#import "Director.h"
#import "AbstractScene.h"
#import "BackgroundScene.h"

@implementation Director

@synthesize glView;
@synthesize indicatorSpinner;
@synthesize backgroundSpinner;
@synthesize currentlyBoundTexture;
@synthesize gameMode;
@synthesize screenMode;
@synthesize currentScene;
@synthesize globalAlpha;
@synthesize globalBackgroundColor;
@synthesize framesPerSecond;
@synthesize averageFramesPerSecond;
@synthesize textureAtlas;
@synthesize textureXML;
@synthesize eventArgs;
@synthesize animationXML;
@synthesize screenBounds;
@synthesize screenScale;
//@synthesize fontNormal;

// Make this class a singleton class
SYNTHESIZE_SINGLETON_FOR_CLASS(Director);

- (id)init 
{
	NSLog(@"Director Initializing...");
	[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
	// Initialize the arrays to be used within the state manager
	_scenes = [[NSMutableDictionary alloc] init];
	currentScene = nil;
	screenMode = PORTRATE_MODE;
	screenBounds = [[UIScreen mainScreen] bounds];
	screenScale = [[UIScreen mainScreen] scale];
	NSLog(@"Screen Size: %F, %F @ x%F", screenBounds.size.width, screenBounds.size.height, screenScale);
	globalAlpha = 1.0f;
	globalBackgroundColor = Color4fMake(1.0, 1.0, 1.0, 1.0);
	eventArgs.touchCount = 0;
	eventArgs.startPoint = CGPointZero; // Touch down point
	eventArgs.movedPoint = CGPointZero; // Last touch moved point
	eventArgs.endPoint = CGPointZero; // Touch up point
	eventArgs.startTime = CFAbsoluteTimeGetCurrent(); // The time the touch started.
	eventArgs.acceleration = CGPointZero; // X, Y Acceleration variables
	return self;
}

- (void) startLoading
{
	[backgroundSpinner setHidden:FALSE];
	[indicatorSpinner startAnimating];
}
- (void) stopLoading
{
	[backgroundSpinner setHidden:TRUE];
	[indicatorSpinner stopAnimating];
}

- (void)addSceneWithKey:(NSString*)aSceneKey scene:(AbstractScene*)aScene 
{
	[_scenes setObject:aScene forKey:aSceneKey];
}


- (BOOL)setCurrentSceneToSceneWithKey:(NSString*)aSceneKey 
{
	if(![_scenes objectForKey:aSceneKey]) 
	{
		NSLog(@"ERROR: Scene with key '%@' not found.", aSceneKey);
        return NO;
    }
	
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    currentScene = [_scenes objectForKey:aSceneKey];
	//[currentScene setNextScene:aSceneKey];
	[currentScene setSceneAlpha:1.0f];
	[currentScene setSceneState:SceneState_TransitionIn];
	[currentScene transitioningToCurrentScene];
	[self setScreenMode:[currentScene screenMode]];
    
    return YES;
}

- (void) setCurrentSceneState:(uint)newSceneState
{
	[currentScene setSceneState:newSceneState];
}

- (BOOL)transitionToSceneWithKey:(NSString*)aSceneKey 
{
	if(![_scenes objectForKey:aSceneKey]) 
	{
		NSLog(@"ERROR: Scene with key '%@' not found.", aSceneKey);
        return NO;
    }
	
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    currentScene = [_scenes objectForKey:aSceneKey];
	//[currentScene setNextScene:aSceneKey];
	[currentScene setSceneAlpha:1.0f];
	[currentScene setSceneState:SceneState_TransitionIn];
	[currentScene transitioningToCurrentScene];
	[self setScreenMode:[currentScene screenMode]];
    
    return YES;
}
- (void)dealloc 
{
	[textureAtlas release];
	[_scenes release];
	[super dealloc];
}

@end
