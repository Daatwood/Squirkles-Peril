//
//  BackgroundActor.m
//  BadBadMonkey
//
//  Created by Dustin Atwood on 10/27/10.
//  Copyright 2010 Litlapps. All rights reserved.
//

#import "BackgroundActor.h"


@implementation BackgroundActor

@synthesize enabled, touched, locked, position, state;

// Init at Position with Width and Height
- (id) initWithImageName:(NSString*)imageName
{
	self = [super init];
	if(self != nil)
	{
		// This is for a 1024 Width of an image
		[self setPosition:CGPointMake(512, 240)];
		//[self setPosition:CGPointMake(160, 240)];
		index = 0;
		[self setState:ActorState_Normal];
		currentImage = [[Image alloc] initWithImageNamed:@"HouseBackground"];
		lockImage = [[Image alloc] initWithImageNamed:@"Lock"];
		[self setLocked:NO];
		[self setTouched:NO];
		[self setEnabled:YES];
	}
	return self;
}

// Begins loading the next stage
- (void) nextStage
{
	if(state != ActorState_Normal)
		return;
	
	if(index + 1 >= 2)
		index = 0;
	else
		index++;
	
	if(index == 0)
	{
		[nextImage release];
		nextImage = [[Image alloc] initWithImageNamed:@"HouseBackground"];
	}
	else
	{
		[nextImage release];
		nextImage = [[Image alloc] initWithImageNamed:@"HillsBackground"];
	}
	[self setState:ActorState_MovingUp];
}

// Begins loading the previous stage
- (void) previousStage
{
	if(state != ActorState_Normal)
		return;
	
	if(index - 1 < 0)
		index = 1;
	else
		index--;
	
	if(index == 0)
	{
		[nextImage release];
		nextImage = [[Image alloc] initWithImageNamed:@"HouseBackground"];
	}
	else
	{
		[nextImage release];
		nextImage = [[Image alloc] initWithImageNamed:@"HillsBackground"];
	}
	[self setState:ActorState_MovingDown];
}

// resets the actor states
- (void) resetStates
{
}

// checks the bounding box
- (BOOL) checkBoundingBox:(CGPoint)point
{
	return NO;
}

// touch began
- (void) touchBeganAtPoint:(CGPoint)beginPoint
{
	if(![self enabled] || [self	locked])
		return;
	
	if([self state] == ActorState_Normal)
	{
		[self setTouched:TRUE];
		xDifference = fabsf(position.x - beginPoint.x);
	}
	else
		[self setTouched:FALSE];
}

// touch moved
- (void) touchMovedAtPoint:(CGPoint)newPoint
{
	if(![self enabled] || ![self touched] || [self locked])
		return;
	
	if(position.x < newPoint.x)
	{
		[self setState:ActorState_MovingRight];
		position.x = (newPoint.x - xDifference);
	}
	if(position.x > newPoint.x)
	{
		[self setState:ActorState_MovingLeft];
		position.x = (newPoint.x + xDifference);
	}
	
	if(position.x > 512)
		position.x = 512;
	if(position.x < -192)
		position.x = -192;
}

// touch ended
- (void) touchEndedAtPoint:(CGPoint)endPoint
{
	if(![self enabled] || ![self touched] || [self locked])
		return;
	
	[self setState:ActorState_Normal];
	[self setTouched:FALSE];
}

// render
- (void) render
{
	if(state == ActorState_MovingUp)
		[nextImage renderAtPoint:CGPointMake(position.x, position.y - 480) centerOfImage:YES];
	if(state == ActorState_MovingDown)
		[nextImage renderAtPoint:CGPointMake(position.x, position.y + 480) centerOfImage:YES];
	
	[currentImage renderAtPoint:position centerOfImage:YES];
}

// update
- (void) updateWithDelta:(GLfloat)delta
{
	switch ([self state]) 
	{
		case ActorState_Normal:
		{
			break;
		}
		case ActorState_MovingUp:
		{
			position.y += 72.0f * (0.2f * 2);
			if(position.y >= 720)
			{
				// This is when the current image is removed and the next
				// image replaces it and then the y is reset to normal.
				position.y = 240;
				[currentImage release];
				currentImage = [nextImage retain];
				[self setState:ActorState_Normal];
			}
			break;
		}
		case ActorState_MovingDown:
		{
			position.y -= 72.0f * (0.2f * 2);
			if(position.y <= -240)
			{
				// This is when the current image is removed and the next
				// image replaces it and then the y is reset to normal.
				position.y = 240;
				[currentImage release];
				currentImage = [nextImage retain];
				[self setState:ActorState_Normal];
			}
			break;
		}
		case ActorState_MovingLeft:
		{
			break;
		}
		case ActorState_MovingRight:
		{
			break;
		}
		default:
			break;
	}
}

@end
