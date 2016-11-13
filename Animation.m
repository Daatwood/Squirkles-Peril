#import "Animation.h"

#define DECAY_TIME 5

@implementation Animation

- (id)init 
{
	if(self = [super init]) 
	{
		// Initialize the array which will hold our frames
		frames = [[NSMutableArray alloc] init];
		
		// Set the default values for important properties
		currentFrame = 0;
		frameTimer = 0;
		loop = 1;
		disabled = YES;
		visible = NO;
		autoRefresh = NO;
		tag = 0;
	}
	return self;
}

// -- Frame Management --
// Creates a frame out of an image with the delay time and adds to the animation
- (void)addFrameWithImage:(Image*)image delay:(float)delay
{
	// Create a new frame instance which will hold the frame image and delay for that image
	Frame *frame = [[Frame alloc] initWithImage:image delay:delay];
	
	// Add the frame to the array of frames in this animation
	[frames addObject:frame];
	
	//NSLog(@"Image Desc: %@", [image description]);
	//NSLog(@"Frame Image Desc: %@", [[frames lastObject] description]);
	
	// Release the frame instance created as having added it to the array will have put its
	// retain count up to 2 so the object we need will not be released until we are finished
	// with it
	[frame release];
	[self show];
}

// Removes all frames from the animation
- (void)removeAllFrames
{
	if([frames count] > 0)
		[frames removeAllObjects];
	currentFrame = 0;
	frameTimer = 0;
}

// Returns the image of the current frame
- (Image*)getCurrentFrameImage
{
	return [[frames objectAtIndex:currentFrame] frameImage];
}

// Returns the number of frames of the animation
- (uint)getAnimationFrameCount
{
	return [frames count];
}

// Returns the current frame
- (uint)getCurrentFrameNumber
{
	return currentFrame;
}

// Returns the frame at the given index
- (Frame*)getFrame:(uint)index
{
	// If a frame number is reuqested outside the range that exists, return nil
	// and log an error
	if(index >= [frames count])
		return nil;
	
	// Return the frame for the requested index
	return [frames objectAtIndex:index];
}

// Flips the animation images.
- (void)flipAnimationVertically:(BOOL)flipVertically horizontally:(BOOL)flipHorizontally
{
	for(int i=0; i < [frames count]; i++) 
	{
		[[[frames objectAtIndex:i] frameImage] setFlipVertically:flipVertically];
		[[[frames objectAtIndex:i] frameImage] setFlipHorizontally:flipHorizontally];
	}
}

// -- Time and Render Management -- 
// Updates the animation with the time since last update
- (void)updateWithDelta:(GLfloat)theDelta
{
	if(disabled)
	{
		if(frameTimer <= DECAY_TIME)
			frameTimer += theDelta;
	}
	else 
	{
		if([frames count] == 0)
			return;
		
		frameTimer += theDelta;
		// If the timer has exceed the delay for the current frame, move to the next frame.
		// If we are at the end of the animation, check to see if we should repeat.
		if(frameTimer > [[frames objectAtIndex:currentFrame] frameDelay] /*|| [[frames objectAtIndex:currentFrame] frameDelay] < 0*/) 
		{
			frameTimer = 0;
			currentFrame ++;
			if(currentFrame >= [frames count]) 
			{
				loop--;
				if(loop > 0)
					currentFrame = 0;
				else
					[self disable];
			}
		}
	}
}

// Draws the current frame onto the screen.
- (void)render
{
	if(!visible)
		return;
	
	if([frames count] == 0)
		return;
	
	// Get the current frame for this animation
	Frame *frame = [frames objectAtIndex:currentFrame];
	
	// Take the image for this frame and render
	[[frame frameImage] render];
}

// Draws the current frame onto the screen at position
- (void)renderAtPosition:(CGPoint)position centerOfImage:(BOOL)center
{
	if(!visible)
		return;
	
	if([frames count] == 0)
		return;
	
	// Get the current frame for this animation
	Frame *frame = [frames objectAtIndex:currentFrame];
	
	// Take the image for this frame and render
	[[frame frameImage] renderAtPoint:position centerOfImage:center];
}

// Disables the animation
- (void) disable
{
	[self hide];
	disabled = TRUE;
	frameTimer = 0;
}

// Enables the animation
- (void) enable
{
	[self show];
	disabled = FALSE;
	frameTimer = 0;
}

// Returns if the animation is disabled
- (BOOL) isDisabled
{
	return disabled;
}

// Hides the animation
- (void) hide
{
	visible = FALSE;
}

// Shows the animation
- (void) show
{
	visible = TRUE;
}

// Returns if the animation is visible
- (BOOL) isVisible
{
	return visible;
}

// Returns if the animation is considered 'Dead'
- (BOOL) isDead
{
	if(frameTimer > DECAY_TIME && disabled)
		return TRUE;
	else
		return FALSE;
}

// Restarts the animation
- (void) revive
{
	currentFrame = 0;
	frameTimer = 0;
	[self enable];
}

// Set the number of loops the animation will do.
- (void) setLoops:(uint)value
{
	loop = value;
}

// Sets if the animation will never 'die'
- (void) setAutoRefresh:(BOOL)value
{
	autoRefresh = value;
}

// Sets if the animation will never 'die'
- (BOOL) needsRefresh
{
	if([self isDisabled] && autoRefresh)
		return TRUE;
	
	return FALSE;
}

// Set the tag
- (void) setTag:(uint)aTag
{
	tag = aTag;
}

// Retrieve tag
- (uint) getTag
{
	return tag;
}

@end
