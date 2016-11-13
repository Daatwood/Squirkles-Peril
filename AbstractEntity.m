#import "AbstractEntity.h"

@interface AbstractEntity (Private)
- (BOOL) isFunctional;
@end

@implementation AbstractEntity
/*
@synthesize currentSpriteSheet;

- (id) initWithTag:(int)_tag
{
	self = [super init];
	if (self != nil) 
	{
		_sharedDirector = [Director sharedDirector];
		_sharedResources = [ResourceManager sharedResourceManager];
		_sharedSoundManager = [SoundManager sharedSoundManager];
		
		font = [[AngelCodeFont alloc] initWithFontImageNamed:@"GillSans16.png" controlFile:@"GillSans16" scale:1.0f filter:GL_LINEAR];
		timeCurr = 0.0;
		timeMax = 1.0;
		isRunning = YES;
		animationName = [[NSString alloc] initWithString:@"none"];
		tag = _tag;
		[self loadAnimations];
	}
	return self;
}

// Calls director to retireve all animations this can play
- (BOOL) loadAnimations
{
	animationProperties = [[NSArray alloc] initWithArray:[_sharedDirector getAnimationPropertiesWithTag:tag]];
	if(animationProperties == nil)		
	{
		if(MDEBUG) NSLog(@"Error: Animation properties are nil.");
		return NO;
	}
	return YES;
}
/*
 Inside the update method it will check to see if there is an animation whos priority is higher and requirements are met with the Event AGRS.
 Upon setting the new animation settings the class will update the animations, clearing out animations that will be given an new image
 and will set the duration limit to animation setting time. 
 Sets the current priority to equal to the animation
 Setting the current Setting the sound equal to that in the animation setting and playing it next update.
 
- (void)update:(GLfloat)delta 
{
	if(!isRunning)
		return;
	
	timeCurr += delta;
	if(timeCurr > timeMax)
	{
		// Animation has finished and will get a new animation
		[self retrieveAnimationWithEvent:0];
	}
	
	//TODO: play sound.
	if(![soundName isEqualToString:@"none"])
	{
		[_sharedSoundManager playSoundWithKey:soundName gain:1.0 pitch:1.0 location:Vector2fZero shouldLoop:NO sourceID:-1];
		soundName = [[NSString alloc] initWithString:@"none"];
	}
}

// Retrieves a new animation based on event and arguements
- (void) retrieveAnimationWithEvent:(int)_event
{
	if(_event < [animationProperties count])
	{
		/*
		 Start a loop checking reach requirement with the first object at _event.
		 when the object matches get the result portion and enter setupAnimation
		 if no object is found with the given event move to the next event and repeat the process
		 if unable to find any animation report an error and leave.
		 *
		
		ObjectEventArguements _args = _sharedDirector.eventArgs;
		for(int i = 0; i < [[animationProperties objectAtIndex:_event] count]; i++)
		{
			if(MDEBUG) NSLog(@"INFO: Monkey: Checking event %d at index %d.", _event, i);
			NSDictionary* currentEvent = [[NSDictionary dictionaryWithDictionary:[[[animationProperties objectAtIndex:_event] objectAtIndex:i] objectForKey:@"Animation_Prerequisite"]]retain];
			//NSLog(@"INFO: Outputing properties. %@", currentEvent);
			
			if([[currentEvent objectForKey:@"Taps"] intValue] != -1 && [[currentEvent objectForKey:@"Taps"] intValue] > taps)
				continue; // This event doesnt meet requirements, continue to next 'i'.
			if(MDEBUG) NSLog(@"INFO: Monkey: taps requirement met.");
			if((![[currentEvent objectForKey:@"Animation"] isEqualToString:@"none"]) && (![[currentEvent objectForKey:@"Animation"] isEqualToString:animationName]))
				continue; // This event doesnt meet requirements, continue to next 'i'.
			if(MDEBUG) NSLog(@"INFO: Monkey: animation requirement met.");
			if([[currentEvent objectForKey:@"Time"] floatValue] != 0 && [[currentEvent objectForKey:@"Time"] floatValue] > _args.elaspedTime)
				continue; // This event doesnt meet requirements, continue to next 'i'.
			_args.elaspedTime -= [[currentEvent objectForKey:@"Time"] floatValue];
			_sharedDirector.eventArgs = _args;
			if(MDEBUG) NSLog(@"INFO: Monkey: time requirement met.");
			if([[currentEvent objectForKey:@"Angle"] floatValue] != 0 && [[currentEvent objectForKey:@"Angle"] floatValue] != _args.acceleration.x)
				continue; // This event doesnt meet requirements, continue to next 'i'.
			if(MDEBUG) NSLog(@"INFO: Monkey: angle requirement met.");
			// Check which type of event this is so we can get the correct direction. Only None( w/ Angle Requirement) and Swipe would need to use this parameter
			if(_event == 2)
			{
				int dir = 1; //Get the direction of StartPoint to Endpoint.
				if([[currentEvent objectForKey:@"Direction"] intValue] != 0 && [[currentEvent objectForKey:@"Direction"] intValue] != dir)
					continue; // This event doesnt meet requirements, continue to next 'i'.
				if(MDEBUG) NSLog(@"INFO: Monkey: direction requirement met.");
			}
			// When all the previous requirements are ment then check the box requirement
			// then check if args.endpoint lands in atleast 1 of the boxes
			if([[currentEvent objectForKey:@"Box"] count] == 0)
			{
				if(MDEBUG) NSLog(@"INFO: Monkey: box requirement met.");
				// SUCCESS! We found an animation!
				// TODO: return a random result, current is set to the first.
				int var = RANDOM([[[[animationProperties objectAtIndex:_event] objectAtIndex:i] objectForKey:@"Animation_Result"] count]);
				NSDictionary* newSettings = [[NSDictionary dictionaryWithDictionary:[[[[animationProperties objectAtIndex:_event] objectAtIndex:i] objectForKey:@"Animation_Result"]objectAtIndex:var]]retain];
				animationName = [[NSString alloc] initWithString:[[[animationProperties objectAtIndex:_event] objectAtIndex:i] objectForKey:@"Animation_Name"]];
				[self setupAnimationWithDictionary:newSettings];
				[newSettings release];
				[currentEvent release];
				return;
			}
			else
			{
				for(int j=0; j < [[currentEvent objectForKey:@"Box"] count]; j++)
				{
					//CGRect a = CGRectFromString([[currentEvent objectForKey:@"Box"] objectAtIndex:j]);
					//if(MDEBUG) NSLog(@"INFO: Monkey: Is (%f, %f) inside ((%f, %f),(%f, %f))?", _args.startPoint.x,_args.startPoint.y,a.origin.x,a.origin.y,a.size.width,a.size.height);
					if(CGRectContainsPoint(CGRectFromString([[currentEvent objectForKey:@"Box"] objectAtIndex:j]), _args.startPoint))
					{
						if(MDEBUG) NSLog(@"INFO: Monkey: box requirement met.");
						// SUCCESS! We found an animation!
						// TODO: return a random result, current is set to the first.
						int var = RANDOM([[[[animationProperties objectAtIndex:_event] objectAtIndex:i] objectForKey:@"Animation_Result"] count]);
						NSDictionary* newSettings = [[NSDictionary dictionaryWithDictionary:[[[[animationProperties objectAtIndex:_event] objectAtIndex:i] objectForKey:@"Animation_Result"]objectAtIndex:var]]retain];
						animationName = [[NSString alloc] initWithString:[[[animationProperties objectAtIndex:_event] objectAtIndex:i] objectForKey:@"Animation_Name"]];
						[self setupAnimationWithDictionary:newSettings];
						[currentEvent release];
						return;
					}
				}
			}
		}
		
		// Aslong as the event is not a shake(3) or a simple update(0) then try to get another
		if(_event < 3 && _event > 1)
		{
			_event--;
			[self retrieveAnimationWithEvent:_event];
		}
		if(MDEBUG) NSLog(@"ERROR: Cannot find animation for event %d", _event);
	}
	else
	{
		if(MDEBUG) NSLog(@"ERROR: Monkey: Sent an invalid event %d, lowering event by 1 and retrying.", _event);
		// Aslong as the event is not a shake(3) or a simple update(0) then try to get another
		if(_event < 3 && _event > 1)
		{
			_event--;
			[self retrieveAnimationWithEvent:_event];
		}
		else
			if(MDEBUG) NSLog(@"ERROR: Monkey: Cannot lower event.", _event);
	}
}

// Setup the animations based on Dictionary with settings
- (void) setupAnimationWithDictionary:(NSDictionary *)_newSettings
{
	// Currently causes a random crash by trying to set a nil value
	soundName = [[NSString stringWithString:[_newSettings objectForKey:@"Sound"]]retain];
	timeMax = [[_newSettings objectForKey:@"Time"] intValue];
	timeCurr = 0.0;
	taps += [[_newSettings objectForKey:@"Taps"] intValue];
	if(taps > tapsMaxMonkey)
		taps = 0;
	
	for(int i = 0; i < [[_newSettings objectForKey:@"Images"] count]; i++)
	{
		NSString *key = [[NSString stringWithString:[[[_newSettings objectForKey:@"Images"] objectAtIndex:i] objectForKey:@"ImageSection"]] retain];
		NSString *imageName = [[NSString stringWithString:[[[_newSettings objectForKey:@"Images"] objectAtIndex:i] objectForKey:@"ImageName"]] retain];
		[[animationParts objectForKey:key] addFrameWithImage:[_sharedResources getImageWithImageKey:imageName andTextureAtlas:currentSpriteSheet andOffset:0] delay:0.1];
	}
}
*/
// NEW METHODS ---------------------------

// Init Methods
- (id) initWithFrequency:(uint)aFrequency
{
	self = [super init];
	if (self != nil) 
	{
		sharedDirector = [Director sharedDirector];
		sharedResources = [ResourceManager sharedResourceManager];
		sharedSoundManager = [SoundManager sharedSoundManager];
		sharedAnimationManager = [AnimationManager sharedAnimationManager];
		
		frequency = aFrequency; // 0, 13, 30
		interval = aFrequency; // Set interval equal to aFrequency to allow for an initial first update.
		disabled = FALSE;
		visible = FALSE;
		layers = [[NSMutableDictionary alloc] initWithCapacity:1];
		params = [[NSMutableDictionary alloc] initWithCapacity:1];
	}
	return self;
}

// Update the actor with the change in time since last frame.
- (void) updateWithDelta:(GLfloat)theDelta
{
	if(disabled)
		return;
	
	// Interval is incremented by 1 each update. When reaching a number
	// of updates equal to or greater than the frequency number it will 
	// then reduce back to 0. When the number of updates are equal to 0 
	// the layers will update.
	interval++;
	if(interval < frequency)
		return;
	else
		interval -= frequency;
	
	// Update loop. Will update each layer. 
	for(int i = 0; i < [layers count]; i++)
	{
		// Make sure the current layer at the tag is not nil.
		if([layers objectForKey:[[NSNumber numberWithInt:i] stringValue]] != nil)
		{
			// If the layer is not dead then updated
			if(![[layers objectForKey:[[NSNumber numberWithInt:i] stringValue]] isDead])
			{
				[[layers objectForKey:[[NSNumber numberWithInt:i] stringValue]] updateWithDelta:theDelta];
				if ([[layers objectForKey:[[NSNumber numberWithInt:i] stringValue]] needsRefresh]) 
				{
					// Request layer update	
					[sharedAnimationManager refreshLayerTag:i withActor:self withEvent:0];
					//NSLog(@"Refreshing layer%D", i);
				}
				else if([[layers objectForKey:[[NSNumber numberWithInt:i] stringValue]] isDisabled])
				{
					// Request layer update	
					[sharedAnimationManager refreshLayerTag:i withActor:self withEvent:0];
					//NSLog(@"Enabling layer%D", i);
				}

			}
			else
				// The layer is dead, remove it
				[self removeLayerWithTag:i];
		}
	}
	
	// Play the sound.
	if(![sound isEqualToString:@"none"] || sound != nil)
	{
		[sharedSoundManager playSoundWithKey:sound gain:1.0 pitch:1.0 location:Vector2fZero shouldLoop:NO sourceID:-1];
		sound = [[NSString alloc] initWithString:@"none"];
	}
}

// Disables the actor
- (void) disable
{
	disabled = TRUE;
}

// Enables the actor
- (void) enable
{
	disabled = FALSE;
}

// Returns if the actor is disabled
- (BOOL) isDisabled
{
	return disabled;
}

// Hides the actor
- (void) hide
{
	visible = FALSE;
}

// Shows the actor
- (void) show
{
	visible = TRUE;
}

// Returns if the actor is visible
- (BOOL) isVisible
{
	return visible;
}

// Checks if the actor is visible and not disabled
- (BOOL) isFunctional
{
	if(visible && !disabled)
		return TRUE;
	else 
		return FALSE;
}

- (void) setTag:(uint)newTag
{
	tag = newTag;
}

- (uint) returnTag
{
	return tag;
}

// --Drawing Selectors--
// draw the actor at the animation's location
- (void) render
{
	if(!visible)
		return;
	
	// Render loop. Will render each layer. 
	for(int i = 0; i < [layers count]; i++)
	{
		if([layers objectForKey:[[NSNumber numberWithInt:i] stringValue]] != nil)
		{
			[[layers objectForKey:[[NSNumber numberWithInt:i] stringValue]] render];
		}
	}
}

// --Touch Selectors--
// The start point of the touch
- (BOOL) touchBeganAtPoint:(CGPoint)beginPoint
{
	// Will check if the actor has been touched. This is usually
	// done by checking if each layer within the actor and responding
	// to the first layer returning true by calling the touchBegan method.
	[self touchBegan];
	return FALSE;
}

// The start point of the touch
- (void) touchBegan
{
	// Will send a request to the animation manager that the touch has began
	// and is in need of possibly new images for the layers. The manager will
	// retrieve all new animations and set them accordingly within the actor. 
	// Will revive dead layers if needed.
	[sharedAnimationManager requestLayer:self withEvent:1];
	
}

// The end point of the touch
- (BOOL) touchEndedAtPoint:(CGPoint)endPoint
{
	// Will check if the actor has been touched. This is usually
	// done by checking if each layer within the actor and responding
	// to the first layer returning true by calling the touchEnded method.
	[self touchEnded];
	return TRUE;
}

// The end point of the touch
- (void) touchEnded
{
	// Will send a request to the animation manager that the touch has ended
	// and is in need of possibly new images for the layers. The manager will
	// retrieve all new animations and set them accordingly within the actor. 
	// Will revive dead layers if needed.
	[sharedAnimationManager requestLayer:self withEvent:3];
}

// The end point of the touch when out of range of performing
- (void) touchCancelled
{
	
}

// --Layer Management--
// Need to be able to retrieve a layer. When adding a layer it will 

- (Animation*) getLayerWithTag:(NSString*)aTag
{
	/*
	 1. Check if the layer Exsists
	  In the event the layer does not
	 1. Create new Layer
	 2. Return layer
	  In the event the layer does
	 1. Return Layer
	 */
	
	Animation* layer = [layers objectForKey:aTag];
	
	if(layer != nil)
	{
		return layer;
	}
	else 
	{
		layer = [[Animation alloc] init];
		[self addLayer:layer withTag:aTag];
		return layer;
	}
}

// Adds the layer to the actor if only the current tag 
// does not exist or it will just replace that layer.
- (void) addLayer:(Animation*)aLayer withTag:(NSString*)aTag
{
	[layers setObject:aLayer forKey:aTag];
}

// Removes the image layer
- (void) removeLayerWithTag:(int)aTag
{
	[layers removeObjectForKey:[[NSNumber numberWithInt:aTag] stringValue]];
}

// Checks layers removing any dead layers
- (void) removeTheDead
{
	// loop. Will remove all dead layers. 
	for(int i = 0; i < [layers count]; i++)
	{
		NSLog(@"Cleaning up old layers.");
		// Get the current frame for this animation
		Animation *layer = [layers objectForKey:[[NSNumber numberWithInt:i] stringValue]];
		
		if(layer != nil)
		{
			if([layer isDead])
				[self removeLayerWithTag:i];
		}
	}
}

// --Parameter Management--
// Set parameter equal to value, if parameter does not
// exsist then create it and set the value if possible
- (void) setParameter:(NSString*)aParam equalToValue:(int)aValue
{
	//NSString* value = ;
	//NSLog(@"The Value '%d': %@, %@",aValue, value, [params description]);
	[params setValue:[[NSNumber numberWithInt:aValue] stringValue] forKey:aParam];
}

// Get parameter
- (int) getParameter:(NSString*)aParam
{
	//NSLog(@"Return Value '%@': %@", aParam, [params objectForKey:aParam]);
	return [[params valueForKey:aParam] intValue];
}

// Removes the image layer
- (void) removeParameterWithTag:(int)aTag
{
	[params removeObjectForKey:[[NSNumber numberWithInt:aTag] stringValue]];
}

// Clears all the parameters
- (void) removeAllParameters
{
	[params removeAllObjects];
}

@end
