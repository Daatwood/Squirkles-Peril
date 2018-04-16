

#import "AbstractScene.h"


@implementation AbstractScene

@synthesize sceneState;
@synthesize sceneMode;
@synthesize sceneAlpha;
@synthesize screenMode;
@synthesize accelerometerSensitivity;
@synthesize isInitialized;

- (id) init
{
	if(self = [super init]) 
	{
		sharedResourceManager = [ResourceManager sharedResourceManager];
		sharedSoundManager = [SoundManager sharedSoundManager];
		sharedSettingManager = [SettingManager sharedSettingManager];
        
        sceneFadeSpeed = 1.0f;
        sceneAlpha = 1.0f;
        [[Director sharedDirector] setGlobalAlpha:sceneAlpha];
		sceneMode = SceneMode_Idle;
		screenMode = PORTRATE_MODE;
		screenBounds = [[UIScreen mainScreen] bounds];
		
		accelerometerSensitivity = 0.1f;
		
		nextSceneKey = nil;
		isInitialized = FALSE;
	}
	return self;
}

- (void) startLoadScene
{
	
}

- (void) finishLoadScene
{

}

- (void)updateWithDelta:(GLfloat)aDelta 
{
	switch (sceneState) 
	{
			// The Scene is in the forefront and running.
		case SceneState_Running:
		{
			break;
		}
			// The scene is phasing out.
		case SceneState_TransitionOut:
		{
			sceneState = SceneState_TransitionIn;
			//sceneAlpha -= sceneFadeSpeed * (aDelta * 2);
            //[Director sharedDirector] setGlobalAlpha:sceneAlpha];
			//if(sceneAlpha < 0)
                // If the scene being transitioned to does not exist then transition
                // this scene back in
				//	if(![Director sharedDirector] setCurrentSceneToSceneWithKey:nextSceneKey])
				//        sceneState = SceneState_TransitionIn;
			break;
		}
			// The scene is phasing in.
		case SceneState_TransitionIn:
		{
			sceneState = SceneState_Running;
			// I'm not using the delta value here as the large map being loaded causes
            // the first delta to be passed in to be very big which takes the alpha
            // to over 1.0 immediately, so I've got a fixed delta for the fade in.
			// sceneAlpha += sceneFadeSpeed * (0.02f * 2);
			// [Director sharedDirector] setGlobalAlpha:sceneAlpha];
			//if(sceneAlpha >= 1.0f) 
			//{
			//	sceneState = SceneState_Running;
			//}
			break;
		}
			// The scene is in an Unknown state.
		default:
		{
			break;
		}
	}
}

- (void)updateWithTouchLocationBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView 
{
	//////////////////////////////////////
	// NEW
	// Grab the touch event
	UITouch *touch = [[event touchesForView:aView] anyObject];//[[touches allObjects] objectAtIndex:0];
	
	// Grab the location of the touch within the view
	CGPoint	location = [touch locationInView:aView];

	/*
	//////////////////////////////////////
	// OLD
	// Get the touch for the specific view
    UITouch *touch = [[event touchesForView:aView] anyObject];
    
	// Grab the location of the touch within the view
	CGPoint location = [touch locationInView:aView];
	*/ 
	 
	//////////////////////////////////////
	
	// Prepare the director arguements
	ObjectEventArguements args = [Director sharedDirector].eventArgs;
	
	// Flip the y location ready to check it against OpenGL coordinates
	args.startPoint.y = 480 - location.y;
	args.startPoint.x = location.x;
	args.startTime = CFAbsoluteTimeGetCurrent();
	args.touchCount = [touches count];
	[Director sharedDirector].eventArgs = args;
}

- (void)updateWithTouchLocationMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView 
{
	//////////////////////////////////////
	// NEW
	// Grab the touch event
	UITouch *touch = [[event touchesForView:aView] anyObject];//[[touches allObjects] objectAtIndex:0];
															  //int tc = [touches count];
	// Grab the location of the touch within the view
	CGPoint	location = [touch locationInView:aView];
	
	/*
	 //////////////////////////////////////
	 // OLD
	 // Get the touch for the specific view
	 UITouch *touch = [[event touchesForView:aView] anyObject];
	 
	 // Grab the location of the touch within the view
	 CGPoint location = [touch locationInView:aView];
	 */ 
	
	//////////////////////////////////////
	
	// Prepare the director arguements
	ObjectEventArguements args = [Director sharedDirector].eventArgs;
	
	// Flip the y location ready to check it against OpenGL coordinates
	args.movedPoint.y = 480 - location.y;
	args.movedPoint.x = location.x;
	[Director sharedDirector].eventArgs = args;
}

- (void)updateWithTouchLocationEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView 
{
	//////////////////////////////////////
	// NEW
	// Grab the touch event
	UITouch *touch = [[event touchesForView:aView] anyObject];//[[touches allObjects] objectAtIndex:0];
	
	// Grab the location of the touch within the view
	CGPoint	location = [touch locationInView:aView];
	
	/*
	 //////////////////////////////////////
	 // OLD
	 // Get the touch for the specific view
	 UITouch *touch = [[event touchesForView:aView] anyObject];
	 
	 // Grab the location of the touch within the view
	 CGPoint location = [touch locationInView:aView];
	 */ 
	
	//////////////////////////////////////
	
	// Prepare the director arguements
	ObjectEventArguements args = [Director sharedDirector].eventArgs;
	
	// Flip the y location ready to check it against OpenGL coordinates
	args.endPoint.y = 480 - location.y;
	args.endPoint.x = location.x;
	args.endTime = CFAbsoluteTimeGetCurrent();
	args.touchCount = [touches count];
	//NSLog(@"Global Touch count: %D", args.touchCount);
	[Director sharedDirector].eventArgs = args;
}

- (void)updateWithTouchLocationCancelled:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView
{
	NSLog(@"Cancelling Touch Abstract Scene");
	ObjectEventArguements args = [Director sharedDirector].eventArgs;
	args.touchCount = 0;
	[Director sharedDirector].eventArgs = args;
}

- (void)updateWithAccelerometer:(UIAcceleration*)aAcceleration 
{
	// Set the acceleration variables by going through a high pass filter
	ObjectEventArguements args = [Director sharedDirector].eventArgs;
	
	//High-Pass Filter
	args.acceleration.x = aAcceleration.x * accelerometerSensitivity + args.acceleration.x * (1.0 - accelerometerSensitivity);
	args.acceleration.y = aAcceleration.y * accelerometerSensitivity + args.acceleration.y * (1.0 - accelerometerSensitivity);
	//No Pass Filter
	//args.acceleration.x = aAcceleration.x;
	//args.acceleration.y = aAcceleration.y;
	
	[Director sharedDirector].eventArgs = args;
}

- (void)transitionToSceneWithKey:(NSString*)aKey 
{
	sceneState = SceneState_TransitionOut;
}

- (void)transitioningToCurrentScene
{
	
}

- (void)render 
{
	
}

@end