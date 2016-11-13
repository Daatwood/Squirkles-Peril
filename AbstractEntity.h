

#import <Foundation/Foundation.h>
#import "Image.h"
#import "Animation.h"
#import "AngelCodeFont.h"
#import "SoundManager.h"
#import "AnimationManager.h"
@class GameScene;


@interface AbstractEntity : NSObject 
{
	//------------------------------
	
	// Access to the director
	Director *sharedDirector;
	// Access to the resource manager
	ResourceManager *sharedResources;
	// Access to the sound manager
	SoundManager *sharedSoundManager;
	// Access to the animation manager
	AnimationManager *sharedAnimationManager;
	// Access to the scene
	GameScene *scene;
	
	// The relative position of item (default = 100, 0 = first, -1 = last)
	int order;
	// The unique tag for the actor
	uint tag;
	// Is the actor disabled, when disabled the actor will not recieve touches or updates.
	BOOL disabled;
	// Is the actor visible, when not visible the actor will not render.
	BOOL visible;
	// Dictionary for holding all layers
	NSMutableDictionary *layers;
	// A Dictionary containing custom parameters for the actor 
	NSMutableDictionary *params;
	// The current string of the sound awaiting to be played.
	NSString* sound;
	// The number of updates per second
	uint frequency;
	// The interval since last update.
	float interval;
	
	// Touch Event Properties
	// Holds if the actor was initally touched down
	BOOL touched;
}

// Init Methods
- (id) initWithFrequency:(uint)aFrequency;

// Update the actor with the change in time since last frame.
- (void) updateWithDelta:(GLfloat)theDelta;

// Disables the actor
- (void) disable;

// Enables the actor
- (void) enable;

// Returns if the actor is disabled
- (BOOL) isDisabled;

// Hides the actor
- (void) hide;

// Shows the actor
- (void) show;

// Returns if the actor is visible
- (BOOL) isVisible;

- (void) setTag:(uint)newTag;

- (uint) returnTag;

// --Layer Management--
// Adds the layer to the actor if only the current tag 
// does not exist or it will just replace that layer.
- (void) addLayer:(Animation*)aLayer withTag:(NSString*)aTag;

- (Animation*) getLayerWithTag:(NSString*)aTag;

// Removes the image layer
- (void) removeLayerWithTag:(int)aTag;

// Checks layers removing any dead layers
- (void) removeTheDead;

// --Parameter Management--
// Set parameter equal to value, if parameter does not
// exsist then create it and set the value if possible
- (void) setParameter:(NSString*)aParam equalToValue:(int)aValue;

// Get parameter
- (int) getParameter:(NSString*)aParam;

// Removes the image layer
- (void) removeParameterWithTag:(int)aTag;

// Clears all the parameters
- (void) removeAllParameters;

// --Drawing Selectors--
// draw the actor at the animation's location
- (void) render;

// --Touch Selectors--
// The start point of the touch
- (BOOL) touchBeganAtPoint:(CGPoint)beginPoint;

// The start point of the touch
- (void) touchBegan;

// The end point of the touch
- (BOOL) touchEndedAtPoint:(CGPoint)endPoint;

// The end point of the touch
- (void) touchEnded;

// The end point of the touch when out of range of performing
- (void) touchCancelled;

@end
