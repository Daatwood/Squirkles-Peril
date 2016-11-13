//
//  AbstractActor.m
//  PetGame
//
//  Created by Dustin Atwood on 9/20/10.
//  Copyright 2010 Dustin Atwood. All rights reserved.
//

#import "AbstractActor.h"


@implementation AbstractActor

@synthesize enabled, selected, highlighted, touched, locked, moved, state, position, size, mode;

// Init at Position with Width and Height
- (id) initAtPosition:(CGPoint)newPosition withSize:(CGPoint)newSize
{
	self = [super init];
	if(self != nil)
	{
		[self setPosition:newPosition];
		[self setSize:newSize];
		[self setState:ActorState_Normal];
		
		// Option Variables
		[self setEnabled:TRUE];
		[self setLocked:TRUE];
		[self setMode:1];
		
		// State Variables
		[self setSelected:FALSE]; 
		[self setHighlighted:FALSE];
		
		// Internal Variables
		[self setTouched:FALSE];
		[self setMoved:FALSE];
		sharedSettingManager = [SettingManager sharedSettingManager];
	}
	return self;
}

// touch inside
- (bool) isTouchInside:(CGPoint)touchPoint
{
	return CGRectContainsPoint(CGRectInset([self boundingBox], size.x * -0.50, size.x * -0.55), touchPoint);
	// Creates a then checks bounding box area.
	//return CGRectContainsPoint(CGRectMake(position.x - (size.x * .75), position.y - (size.y * .75), size.x * 1.25, size.y * 1.25), touchPoint);
}

- (CGRect) boundingBox
{
	return CGRectMake(position.x - (size.x * .5), position.y - (size.y * .5), size.x, size.y);
}

// touch began
- (void) touchBeganAtPoint:(CGPoint)beginPoint
{
	if (![self enabled]) 
		return ;
	
	if([self isTouchInside:beginPoint])
	{
		[self setHighlighted:TRUE];
		[self setTouched:TRUE];
		return ;
	}
	else
	{
		[self setHighlighted:FALSE];
		[self setTouched:FALSE];
		return ;
	}
}

// touch moved
- (void) touchMovedAtPoint:(CGPoint)newPoint
{
	// Ignore if is not enabled or was not orginally touched
	if (![self enabled] || ![self touched]) 
		return ;
	
	// Only perform a touch-area check if actor has not moved
	if(![self moved] && [self isTouchInside:newPoint])
	{
		[self setHighlighted:TRUE];
		return ;
	}
	// Now if the actor is unlocked move to position and flag moved, keeping highlighted
	else if(![self locked])
	{
		// Setting actor as moved
		[self setMoved:TRUE];
		// Keeping Highlighted
		[self setHighlighted:TRUE];
		// Moving it to new position
		[self setPosition:CGPointMake(newPoint.x, newPoint.y + size.y / 2)];
		return ;
	}
	// The actor cannot move and new point is outside of range, dehighlight
	else
	{
		[self setHighlighted:FALSE];
		return ;
	}
}

// touch ended
- (void) touchEndedAtPoint:(CGPoint)endPoint
{
	if (![self enabled] || ![self touched]) 
		return ;
	
	[self setTouched:FALSE];
	[self setHighlighted:FALSE];
	[self setMoved:FALSE];
	
	switch (mode) 
	{
			// Simple Bounding Box Check
		case 0:
		{
			if([self isTouchInside:endPoint])
			{
				[self setSelected:YES];
				return ;
			}
			else 
			{
				[self setSelected:NO];
				return ;
			}
		}
			// Time Check then Movement check
		case 1:
		{
			CGRect bBox = CGRectMake([[Director sharedDirector] eventArgs].startPoint.x - (0 * .5), 
									[[Director sharedDirector] eventArgs].startPoint.y - (0 * .5), 0, 0);
			if(CGRectContainsPoint(bBox, endPoint))
			{
				[self setSelected:YES];
				return ;
			}
			else 
			{
				[self setSelected:NO];
				return ;
			}
		}
		default:
			return ;
	}
	/*
	// If the point is within the bounding box then the
	// them item will be selected.
	if(/*![self moved] && [self isTouchInside:endPoint])
	{
		[self setSelected:TRUE];
	}
	else
	{
		[self setSelected:FALSE];
	}
	
	//
	
	[self setMoved:FALSE];
	
	// We are only returning TRUE on actually presses not movements
	return [self selected];
	*/
}

// render
- (void) render
{
	
}

// update
- (void) updateWithDelta:(GLfloat)delta
{
	/*
	// When the item is pressed down for a period of time it become a movable state
	if ([self enabled] && [self touched] && ![self locked] && ![self moved])
	{
		if( CFAbsoluteTimeGetCurrent() - [Director sharedDirector] eventArgs].startTime > 1.0f)
		{
			[self setMoved:TRUE];
			NSLog(@"Auto Moved!");
		}
	}
	 */
	
	
	//if([self holdActivated] && [self enabled] && [self touched] && ![self moved])
	//{
	//	if( CFAbsoluteTimeGetCurrent() - [Director sharedDirector] eventArgs].startTime > 1.0f)
	//	{
	//		[self setSelected:TRUE];
	//		NSLog(@"Auto Moved!");
	//	}
	//}
}

@end
