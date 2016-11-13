//
//  ImageActor.m
//  BadBadMonkey
//
//  Created by Dustin Atwood on 10/5/10.
//  Copyright 2010 Litlapps. All rights reserved.
//

#import "ImageActor.h"


@implementation ImageActor


// Init with Image Name at Position with Width and Height
- (id) initWithImageNamed:(NSString*)imageName atPosition:(CGPoint)newPosition
{
	self = [super initWithCGRect:CGRectMake(0, 0, 0, 0)];
	if(self != nil)
	{
		[self setImage:imageName];
		[super setBoundingBox:CGRectMake(newPosition.x,newPosition.y, [image imageWidth], [image imageHeight])];
	}
	return self;
}

- (void) setImage:(NSString*)imageName
{
	[image release];
	image = [[Image alloc] initWithImageNamed:imageName];
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
	//if([self selected] && CGRectContainsPoint(CGRectMake(0,0,320,40), newPoint))
	//{
	//	[[self image] setColourFilterCGColor:[UIColor redColor].CGColor];
	//}
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
	[image renderAtPoint:[super boundingBox].origin centerOfImage:YES];
}

// update
- (void) updateWithDelta:(GLfloat)delta
{
	[super updateWithDelta:delta];
}

@end
