

#import "GameScene.h"
#import "AbstractEntity.h"
#import "ForegroundActor.h"
#import "BackgroundActor.h"
#import "ButtonControl.h"
#import "ButtonFrame.h"
#import "CharacterActor.h"

// Is FPS output visible?
#define FPS 1

@interface GameScene (Private)
// Initialize the sound needed for this scene
- (void)initSound;
@end

@implementation GameScene

- (id)init 
{
	if(self == [super init]) 
	{
		NSLog(@"GameScene Initializing...");
        // Grab an instance of our singleton classes
		
		// Manages all Scenes and relays input
		sharedDirector = [Director sharedDirector];
		// Manages all Textures
		sharedResourceManager = [ResourceManager sharedResourceManager];
		// Manages all Sounds
		sharedSoundManager = [SoundManager sharedSoundManager];
		// Manages all Application Settings
		sharedSettingManager = [SettingManager sharedSettingManager];
		
		// Grab the bounds of the screen
		screenBounds = [[UIScreen mainScreen] bounds];
		
		// How quickly the scene will fade out
        sceneFadeSpeed = 1.0f;
        
		// Init Sound
		[self initSound];
		
		// Init font
        font = [[AngelCodeFont alloc] initWithFontImageNamed:@"GillSans16.png" controlFile:@"GillSans16" scale:1.0f filter:GL_LINEAR];
		
		// Create Character Actor
		characterActor = [[CharacterActor alloc] init];
		
		CFTimeInterval startTime = CFAbsoluteTimeGetCurrent();
		/*
		// Create the Menu bar, Scenery Bar, Costume Bar
		menuButtonBar = [[ButtonFrame alloc] initWithSize:CGRectMake(0, 0, 60, 480)];
		sceneryButtonBar = [[ButtonFrame alloc] initWithSize:CGRectMake(60, 0, 60, 480)];
		costumeButtonBar = [[ButtonFrame alloc] initWithSize:CGRectMake(120, 0, 60, 480)];
		
		// Create the Menu Button
		menuButton = [[ButtonControl alloc] initWithImageNamed:@"MenuButton.png" type:1];
		[menuButton setTarget:(id)menuButtonBar selector:@selector(toggle)];
		[menuButton setPosition:CGPointMake(10, 0)];
		
		// Create Menu Buttons
		ButtonControl *soundButton = [[ButtonControl alloc] initWithImageNamed:@"SoundButton.png" type:ButtonType_Toggle];
		ButtonControl *accelButton = [[ButtonControl alloc] initWithImageNamed:@"AccelButton.png" type:ButtonType_Toggle];
		ButtonControl *vibrateButton = [[ButtonControl alloc] initWithImageNamed:@"VibrateButton.png" type:ButtonType_Toggle];
		ButtonControl *helpButton = [[ButtonControl alloc] initWithImageNamed:@"HelpButton.png" type:ButtonType_Execute];
		ButtonControl *FbButton = [[ButtonControl alloc] initWithImageNamed:@"FacebookIcon.png" type:ButtonType_Execute];
		ButtonControl *storeButton = [[ButtonControl alloc] initWithImageNamed:@"StoreButton.png" type:ButtonType_Execute];
		ButtonControl *sceneryButton = [[ButtonControl alloc] initWithImageNamed:@"SceneryButton.png" type:ButtonType_Execute];
		ButtonControl *costumeButton = [[ButtonControl alloc] initWithImageNamed:@"CostumeButton.png" type:ButtonType_Execute];
		ButtonControl *emptyButton1 = [[ButtonControl alloc] initWithImageNamed:@"ButtonTemplate.png" type:ButtonType_Toggle];
		ButtonControl *emptyButton2 = [[ButtonControl alloc] initWithImageNamed:@"ButtonTemplate.png" type:ButtonType_Toggle];
		ButtonControl *emptyButton3 = [[ButtonControl alloc] initWithImageNamed:@"ButtonTemplate.png" type:ButtonType_Toggle];
		
		// Add the Buttons to the Menu Bar
		[menuButtonBar addButton:soundButton];
		[menuButtonBar addButton:accelButton];
		[menuButtonBar addButton:vibrateButton];
		[menuButtonBar addButton:helpButton];
		[menuButtonBar addButton:FbButton];
		[menuButtonBar addButton:storeButton];
		[menuButtonBar addButton:sceneryButton];
		[menuButtonBar addButton:costumeButton];
		[menuButtonBar addButton:emptyButton1];
		[menuButtonBar addButton:emptyButton2];
		[menuButtonBar addButton:emptyButton3];
		
		// Setup the Execute functions of the Buttons
		[soundButton setTarget:(id)sharedSettingManager selector:@selector(toggleSound)];
		[accelButton setTarget:(id)sharedSettingManager selector:@selector(toggleAccel)];
		[vibrateButton setTarget:(id)sharedSettingManager selector:@selector(toggleVibrate)];
		[sceneryButton setTarget:(id)sceneryButtonBar selector:@selector(toggle)];
		[costumeButton setTarget:(id)costumeButtonBar selector:@selector(toggle)];
		[storeButton setTarget:self selector:@selector(goToStore)];
		
		// Releases the temporary menu buttons
		[soundButton release];
		[accelButton release];
		[vibrateButton release];
		[helpButton release];
		[FbButton release];
		[storeButton release];
		[costumeButton release];
		[sceneryButton release];
		[emptyButton1 release];
		[emptyButton2 release];
		[emptyButton3 release];
		
		// Scene Bar Button Setup
		ButtonControl *sceneButton1 = [[ButtonControl alloc] initWithImageNamed:@"SceneryButton.png" type:ButtonType_Select order:100 group:2];
		ButtonControl *sceneButton2 = [[ButtonControl alloc] initWithImageNamed:@"SceneryButton.png" type:ButtonType_Select order:100 group:2];
		ButtonControl *sceneButton3 = [[ButtonControl alloc] initWithImageNamed:@"SceneryButton.png" type:ButtonType_Select order:100 group:2];
		ButtonControl *sceneButton4 = [[ButtonControl alloc] initWithImageNamed:@"SceneryButton.png" type:ButtonType_Select order:100 group:2];
		ButtonControl *sceneButton5 = [[ButtonControl alloc] initWithImageNamed:@"SceneryButton.png" type:ButtonType_Select order:100 group:2];
		ButtonControl *sceneButton6 = [[ButtonControl alloc] initWithImageNamed:@"SceneryButton.png" type:ButtonType_Select order:100 group:2];
		ButtonControl *sceneButton7 = [[ButtonControl alloc] initWithImageNamed:@"SceneryButton.png" type:ButtonType_Select order:100 group:2];
		ButtonControl *sceneButton8 = [[ButtonControl alloc] initWithImageNamed:@"SceneryButton.png" type:ButtonType_Select order:100 group:2];
		ButtonControl *sceneButton9 = [[ButtonControl alloc] initWithImageNamed:@"SceneryButton.png" type:ButtonType_Select order:100 group:2];
		ButtonControl *sceneButton10 = [[ButtonControl alloc] initWithImageNamed:@"SceneryButton.png" type:ButtonType_Select order:100 group:2];
		ButtonControl *sceneButton11 = [[ButtonControl alloc] initWithImageNamed:@"SceneryButton.png" type:ButtonType_Select order:100 group:2];
		
		[sceneryButtonBar addButton:sceneButton1];
		[sceneryButtonBar addButton:sceneButton2];
		[sceneryButtonBar addButton:sceneButton3];
		[sceneryButtonBar addButton:sceneButton4];
		[sceneryButtonBar addButton:sceneButton5];
		[sceneryButtonBar addButton:sceneButton6];
		[sceneryButtonBar addButton:sceneButton7];
		[sceneryButtonBar addButton:sceneButton8];
		[sceneryButtonBar addButton:sceneButton9];
		[sceneryButtonBar addButton:sceneButton10];
		[sceneryButtonBar addButton:sceneButton11];
		
		[sceneButton1 release];
		[sceneButton2 release];
		[sceneButton3 release];
		[sceneButton4 release];
		[sceneButton5 release];
		[sceneButton6 release];
		[sceneButton7 release];
		[sceneButton8 release];
		[sceneButton9 release];
		[sceneButton10 release];
		[sceneButton11 release];
		
		// Costume Bar Button Setup
		ButtonControl *costumeButton1 = [[ButtonControl alloc] initWithImageNamed:@"CostumeButton.png" type:ButtonType_Select order:100 group:3];
		ButtonControl *costumeButton2 = [[ButtonControl alloc] initWithImageNamed:@"CostumeButton.png" type:ButtonType_Select order:100 group:3];
		ButtonControl *costumeButton3 = [[ButtonControl alloc] initWithImageNamed:@"CostumeButton.png" type:ButtonType_Select order:100 group:3];
		ButtonControl *costumeButton4 = [[ButtonControl alloc] initWithImageNamed:@"CostumeButton.png" type:ButtonType_Select order:100 group:3];
		ButtonControl *costumeButton5 = [[ButtonControl alloc] initWithImageNamed:@"CostumeButton.png" type:ButtonType_Select order:100 group:3];
		ButtonControl *costumeButton6 = [[ButtonControl alloc] initWithImageNamed:@"CostumeButton.png" type:ButtonType_Select order:100 group:3];
		ButtonControl *costumeButton7 = [[ButtonControl alloc] initWithImageNamed:@"CostumeButton.png" type:ButtonType_Select order:100 group:3];
		ButtonControl *costumeButton8 = [[ButtonControl alloc] initWithImageNamed:@"CostumeButton.png" type:ButtonType_Select order:100 group:3];
		ButtonControl *costumeButton9 = [[ButtonControl alloc] initWithImageNamed:@"CostumeButton.png" type:ButtonType_Select order:100 group:3];
		ButtonControl *costumeButton10 = [[ButtonControl alloc] initWithImageNamed:@"CostumeButton.png" type:ButtonType_Select order:100 group:3];
		ButtonControl *costumeButton11 = [[ButtonControl alloc] initWithImageNamed:@"CostumeButton.png" type:ButtonType_Select order:100 group:3];
		
		[costumeButtonBar addButton:costumeButton1];
		[costumeButtonBar addButton:costumeButton2];
		[costumeButtonBar addButton:costumeButton3];
		[costumeButtonBar addButton:costumeButton4];
		[costumeButtonBar addButton:costumeButton5];
		[costumeButtonBar addButton:costumeButton6];
		[costumeButtonBar addButton:costumeButton7];
		[costumeButtonBar addButton:costumeButton8];
		[costumeButtonBar addButton:costumeButton9];
		[costumeButtonBar addButton:costumeButton10];
		[costumeButtonBar addButton:costumeButton11];
		
		[costumeButton1 release];
		[costumeButton2 release];
		[costumeButton3 release];
		[costumeButton4 release];
		[costumeButton5 release];
		[costumeButton6 release];
		[costumeButton7 release];
		[costumeButton8 release];
		[costumeButton9 release];
		[costumeButton10 release];
		[costumeButton11 release];
		 */
		CFTimeInterval finishTime = CFAbsoluteTimeGetCurrent();
		NSLog(@"Loading menu items took %f seconds.", finishTime - startTime);
    }
	
	return self;
}

- (void) goToStore
{
	/*
	sceneState = kSceneState_TransitionOut;
	nextSceneKey = @"store";*/
}

- (void)updateWithDelta:(GLfloat)theDelta 
{

	switch (sceneState) 
	{
		// The Scene is in the forefront and running.
		case SceneState_Running:
		{
			ObjectEventArguements args = sharedDirector.eventArgs;
			args.elaspedTime += theDelta;
			sharedDirector.eventArgs = args;
			
			// Update the Background
			// [background update:theDelta];
			
			// Update the Foreground
			// [foreground update:theDelta];
			
			// Update the Character
			[characterActor updateWithDelta:theDelta];
			//[monkey updateWithDelta:theDelta];
			
			// Updates the Menu Bar
			[menuButtonBar updateWithDelta:theDelta];
			
			// Scenery and Costume bars do not have a fixed position, They will
			// 'float' in the second and third bar positons. This way there is
			// no gap between the menu bar the next open bar.
			if ([sceneryButtonBar isVisible] && ![costumeButtonBar isVisible]) 
			{
				[sceneryButtonBar setPosition:CGPointMake(60, 0)];
				[costumeButtonBar setPosition:CGPointMake(120, 0)];
			}
			else if(![sceneryButtonBar isVisible] && [costumeButtonBar isVisible])
			{
				[sceneryButtonBar setPosition:CGPointMake(120, 0)];
				[costumeButtonBar setPosition:CGPointMake(60, 0)];
			}
														  
			// Update the Scenery Bar
			[sceneryButtonBar updateWithDelta:theDelta];
			
			// Update the Costume Bar
			[costumeButtonBar updateWithDelta:theDelta];
			
			// Update the particle emitter
			[explosionEmitter update:theDelta];
			break;
		}
		// The scene is phasing out.
		case SceneState_TransitionOut:
		{
			sceneAlpha -= sceneFadeSpeed * (theDelta * 2);
            [sharedDirector setGlobalAlpha:sceneAlpha];
			if(sceneAlpha < 0)
                // If the scene being transitioned to does not exist then transition
                // this scene back in
				if(![sharedDirector setCurrentSceneToSceneWithKey:nextSceneKey])
                    sceneState = SceneState_TransitionIn;
			break;
		}
		// The scene is phasing in.
		case SceneState_TransitionIn:
		{
			// I'm not using the delta value here as the large map being loaded causes
            // the first delta to be passed in to be very big which takes the alpha
            // to over 1.0 immediately, so I've got a fixed delta for the fade in.
            sceneAlpha += sceneFadeSpeed * (0.02f * 2);
            [sharedDirector setGlobalAlpha:sceneAlpha];
			if(sceneAlpha >= 1.0f) {
				sceneState = SceneState_Running;
			}
			break;
		}
		// The scene is in an Unknown state.
		default:
		{
			NSLog(@"ERROR: Gamescene has no valid state.");
			break;
		}
	}

}

// A touch has began do the nesscessary actions 
- (void)updateWithTouchLocationBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView 
{
	// Get the touch for the specific view
    UITouch *touch = [[event touchesForView:aView] anyObject];
    
	// Grab the location of the touch within the view
	CGPoint location = [touch locationInView:aView];
	
	// Prepare the director arguements
	ObjectEventArguements args = sharedDirector.eventArgs;
	
	// ??
	touchMoved = NO;
	
	// Flip the y location ready to check it against OpenGL coordinates
	args.startPoint.y = 480 - location.y;
	args.startPoint.x = location.x;
	args.elaspedTime = 0.0;
	sharedDirector.eventArgs = args;
	
	switch (sceneState) 
	{
		// The Scene is in the forefront and running.
		case SceneState_Running:
		{	
			// Check to see if the touch landed within the menu button
			// If the touch did not land then send the touch to the 
			// other entities
			if(![menuButton touchBeganAtPoint:args.startPoint])
			{
				// Send event to background about the touch
				//[background retrieveAnimationWithEvent:1];
						
				// Send event to foreground about the touch
				//[foreground retrieveAnimationWithEvent:1];
						
				// Send event to Character about the touch
				//[monkey retrieveAnimationWithEvent:1];
				
			}
			
			[characterActor touchBeganAtPoint:args.startPoint];
			
			// Send event to the Menu Bar
			[menuButtonBar touchBeganAtPoint:args.endPoint];
			
			// Send event to the scenery Bar
			[sceneryButtonBar touchBeganAtPoint:args.endPoint];
			
			// Send event to the costume Bar
			[costumeButtonBar touchBeganAtPoint:args.endPoint];
			
			//Init particle emitter
			/*
			 explosionEmitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"ButtonTemplate.png"
			 position:Vector2fMake(args.startPoint.x, args.startPoint.y)
			 sourcePositionVariance:Vector2fMake(0, 0)
			 speed:10.0f
			 speedVariance:10.0f
			 particleLifeSpan:3.0f	
			 particleLifespanVariance:3.0f
			 angle:0.0f
			 angleVariance:360
			 gravity:Vector2fMake(0.0f, 0.0f)
			 startColor:Color4fMake(1.0f, 1.0f, 1.0f, 1.0f)
			 startColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 0.5f)
			 finishColor:Color4fMake(1.0f, 1.0f, 1.0f, 0.0f)  
			 finishColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 0.0f)
			 maxParticles:1000
			 particleSize:1
			 particleSizeVariance:1
			 duration:10
			 blendAdditive:NO];
			 */
			
			break;
		}
		// Don't do anything if the scene isnt running.
		default:
			break;
	}
}

// A touch has moved do the nesscessary actions 
- (void)updateWithTouchLocationMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView 
{
	// Get the touch for the specific view
    UITouch *touch = [[event touchesForView:aView] anyObject];
	
	// Grab the location of the touch within the view
	CGPoint location = [touch locationInView:aView];
    
	// Flip the y location ready to check it against OpenGL coordinates
	location.y = 480 - location.y;
	
	// ??
	touchMoved = YES;   
	
	switch (sceneState) 
	{
		// The Scene is in the forefront and running.
		case SceneState_Running:
		{
			// Send event to the Menu Bar
			[menuButtonBar touchMovedToPoint:location];
			
			// Send event to the Scenery Bar
			[sceneryButtonBar touchMovedToPoint:location];
			
			// Send event to the Costume Bar
			[costumeButtonBar touchMovedToPoint:location];
			
			break;
		}
		// Don't do anything if the scene isnt running.
		default:
			break;
	}
}

// A touch has ended do the nesscessary actions 
- (void)updateWithTouchLocationEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView 
{
	// Get the touch for the specific view
    UITouch *touch = [[event touchesForView:aView] anyObject];
    
	// Grab the location of the touch within the view
	CGPoint location = [touch locationInView:aView];
	
	// Prepare the director arguements
	ObjectEventArguements args = sharedDirector.eventArgs;
	
	// Flip the y location ready to check it against OpenGL coordinates
	args.endPoint.y = 480 - location.y;
	args.endPoint.x = location.x;
	args.elaspedTime = 0.0;
	sharedDirector.eventArgs = args;
	
	switch (sceneState) 
	{
		// The Scene is in the forefront and running.
		case SceneState_Running:
			
			// Check to see if the touch ended within the menu button
			// If did then toggle the character, foreground and background 
			// on or off Procede to hide the scenery and costume bar incase 
			// the button is closing the menu
			if([menuButton touchEndedAtPoint:args.endPoint])
			{
				// Toggles the character updates on/off
				//[monkey toggle];
				
				// Toggles the foreground updates on/off
				//[foreground toggle];
				
				// Toggles the background updates on/off
				//[background toggle];
				
				// Hide the Scenery bar 
				[sceneryButtonBar hide];
				
				// Hide the Costume bar
				[costumeButtonBar hide];
			}
			// Since menubutton was not pressed send events to the menu bar
			// scenery bar and costume bar
			else
			{	
				// Send event to the Menu Bar
				[menuButtonBar touchEndedAtPoint:args.endPoint];
				
				// Send event to the scenery Bar
				[sceneryButtonBar touchEndedAtPoint:args.endPoint];
				
				// Send event to the costume Bar
				[costumeButtonBar touchEndedAtPoint:args.endPoint];
				
				// Send event to background about the touch
				//[background retrieveAnimationWithEvent:2];
				
				// Send event to foreground about the touch
				//[foreground retrieveAnimationWithEvent:2];
				
				// Send event to character about the touch
				//[monkey retrieveAnimationWithEvent:2];
				
				[characterActor touchEndedAtPoint:args.endPoint];
				
				/*
				// Send event to the Menu Bar
				if(![menuButtonBar touchEndedAtPoint:args.endPoint])
				{
					// Send event to the Scenery Bar
					if(![sceneryButtonBar touchEndedAtPoint:args.endPoint] ||
					   // Send event to the Costume Bar
					   ![costumeButtonBar touchEndedAtPoint:args.endPoint])
					{
						// If the touch had moved update the character, foreground 
						// and background
						if(touchMoved)
						{
							// Send event to background about the touch
							[background retrieveAnimationWithEvent:2];
							
							// Send event to foreground about the touch
							//[foreground retrieveAnimationWithEvent:2];
							
							// Send event to character about the touch
							[monkey retrieveAnimationWithEvent:2];
						}
					}*/
				break;
			}
		default:
			break;
	}
}

// The device was moved by accelerometer
- (void)updateWithAccelerometer:(UIAcceleration*)aAcceleration 
{
	// Check to make sure the settings accept accelerometer
	if(![sharedSettingManager vibrateOn])
		return;
	
	// Set the acceleration variables by going through a high pass filter
	ObjectEventArguements args = sharedDirector.eventArgs;
	args.acceleration.x = aAcceleration.x * 0.1f + args.acceleration.x * (1.0 - 0.1f);
	args.acceleration.y = aAcceleration.y * 0.1f + args.acceleration.y * (1.0 - 0.1f);
	
	sharedDirector.eventArgs = args;
}

// Changes the scene to the selected scene key
- (void)transitionToSceneWithKey:(NSString*)theKey 
{
	sceneState = SceneState_TransitionOut;
}

// Renders the scene
- (void)render 
{
    // Render the rest of the scene.  We translate our location so that everything is drawn in relation
    // to where the player is in the tilemap.
    glPushMatrix();

	// Render the particle emitter and baddies.  This is done after the translate so that
    // they are rendered relative to the tilemap
	//[background render];
	//[monkey render];
	[characterActor render];
	[menuButtonBar render];
	[sceneryButtonBar render];
	[costumeButtonBar render];
	[menuButton renderAtPoint:CGPointMake(10, 0)];
    // Pop the matrix back off the stack which will undo the glTranslate we did above
	[explosionEmitter renderParticles];
    glPopMatrix();
	
    if(FPS)
	{
		[font drawStringAt:CGPointMake(5, 465) text:[NSString stringWithFormat:@"Agg: %D", [characterActor getParameter:@"Aggravation"]]];
        [font drawStringAt:CGPointMake(5, 450) text:[NSString stringWithFormat:@"FPS: %1.0f", [sharedDirector framesPerSecond]]];
	}
}

@end


@implementation GameScene (Private)

#pragma mark -
#pragma mark Initialize sound

- (void)initSound 
{
	CFTimeInterval startTime = CFAbsoluteTimeGetCurrent();
    [sharedSoundManager setListenerPosition:Vector2fMake(160, 0)];
	
    // Initialize the sound effects
	[sharedSoundManager loadSoundWithKey:@"calmHit1" fileName:@"calm_hit_1" fileExt:@"caf"];
	[sharedSoundManager loadSoundWithKey:@"calmHit2" fileName:@"calm_hit_2" fileExt:@"caf"];
	[sharedSoundManager loadSoundWithKey:@"calmHit3" fileName:@"calm_hit_3" fileExt:@"caf"];
	[sharedSoundManager loadSoundWithKey:@"calmHit4" fileName:@"calm_hit_4" fileExt:@"caf"];
	[sharedSoundManager loadSoundWithKey:@"calmHit5" fileName:@"calm_hit_5" fileExt:@"caf"];
	
	// Initialize the background music
	//[sharedSoundManager loadBackgroundMusicWithKey:@"music" fileName:@"music" fileExt:@"caf"];
	[sharedSoundManager setMusicVolume:0.75f];
	//[sharedSoundManager playMusicWithKey:@"music"  timesToRepeat:-1];
	
	// Set the master sound FX volume
	[sharedSoundManager setFXVolume:1.0f];
	CFTimeInterval finishTime = CFAbsoluteTimeGetCurrent();
	NSLog(@"Loading sounds took %f seconds.", finishTime - startTime);
}

@end

