//
//  AnimationActor.m
//  BadBadMonkey
//
//  Created by Dustin Atwood on 10/5/10.
//  Copyright 2010 Litlapps. All rights reserved.
//

#import "AnimationActor.h"


@implementation AnimationActor

@synthesize animation;

// Init with Animation at Position with Width and Height
- (id) initWithAnimation:(Animation*)newAnimation atPosition:(CGPoint)newPosition withSize:(CGPoint)newSize;
{
	self = [super initAtPosition:newPosition withSize:newSize];
	if(self != nil)
	{
		[self setAnimation:newAnimation];
	}
	return self;
}

// touch began
- (void) touchBeganAtPoint:(CGPoint)beginPoint
{
	[super touchBeganAtPoint:beginPoint];
}

// touch moved
- (void) touchMovedAtPoint:(CGPoint)newPoint
{
	 [super touchMovedAtPoint:newPoint];
}

// touch ended
- (void) touchEndedAtPoint:(CGPoint)endPoint
{
	 [super touchEndedAtPoint:endPoint];
}

// render
- (void) render
{
	[super render];
	[animation renderAtPosition:[super position] centerOfImage:YES];
}

// update
- (void) updateWithDelta:(GLfloat)delta
{
	[super updateWithDelta:delta];
	[animation updateWithDelta:delta];
}

@end
