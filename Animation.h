#import <Foundation/Foundation.h>
#import "Frame.h"

@interface Animation : NSObject 
{	
	// Frames to be used within the animation
	NSMutableArray *frames;
	// Current display time of the frame
	float frameTimer;
	// Is the animation disabled, when disabled the animation will not recieve 
	// touches or updates. Upon becoming disabled the animation will start a
	// timer that upon reaching 0 will be considered 'dead' and no longer functional.
	BOOL disabled;
	// Is the actor visible, when not visible the animation will not render.
	BOOL visible;
	// The amount of times the animation will play, default 1
	int loop;
	// The current frame of the animation
	int currentFrame;
	// When the frame becomes disabled it will become re-enabled if true
	BOOL autoRefresh;
	// The unique identifier for the animation
	uint tag;
}

// -- Frame Management --
// Creates a frame out of an image with the delay time and adds to the animation
- (void)addFrameWithImage:(Image*)image delay:(float)delay;

// Removes all frames from the animation
- (void)removeAllFrames;

// Returns the image of the current frame
- (Image*)getCurrentFrameImage;

// Returns the number of frames of the animation
- (uint)getAnimationFrameCount;

// Returns the current frame
- (uint)getCurrentFrameNumber;

// Returns the frame at the given index
- (Frame*)getFrame:(uint)index;

// Flips the animation images.
- (void)flipAnimationVertically:(BOOL)flipVertically horizontally:(BOOL)flipHorizontally;

// -- Time and Render Management -- 
// Updates the animation with the time since last update
- (void)updateWithDelta:(GLfloat)theDelta;

// Draws the current frame onto the screen.
- (void)render;

// Draws the current frame onto the screen at position
- (void)renderAtPosition:(CGPoint)position centerOfImage:(BOOL)center;

// Disables the animation
- (void) disable;

// Enables the animation
- (void) enable;

// Returns if the animation is disabled
- (BOOL) isDisabled;

// Hides the animation
- (void) hide;

// Shows the animation
- (void) show;

// Returns if the animation is visible
- (BOOL) isVisible;

// Returns if the animation is considered 'Dead'
- (BOOL) isDead;

// Restarts the animation
- (void) revive;

// Set the number of loops the animation will do.
- (void) setLoops:(uint)value;

// Sets if the animation will never 'die'
- (void) setAutoRefresh:(BOOL)value;

// Returns if the animation is autorefresh
- (BOOL) needsRefresh;

// Set the tag
- (void) setTag:(uint)aTag;

// Retrieve tag
- (uint) getTag;

@end
