//
//  SliderControl.m
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 1/19/11.
//  Copyright 2011 Dustin Atwood. All rights reserved.
//

#import "SliderControl.h"


@implementation SliderControl

- (id) initAtPosition:(CGPoint)pos
{
	self = [super initWithCGRect:CGRectZero];
	if(self != nil)
	{
		imageButton = [[Image alloc] initWithImageNamed:@"imageButtonSlider"];
		imageBar = [[Image alloc] initWithImageNamed:@"imageBarSlider"];
		[imageBar setPosition:pos];
		
		[imageBar setPosition:pos];
		[imageButton setPosition:pos];
		
		value = 0;
		offset = pos.x - [imageBar imageWidth] / 2;
		[self setBoundingBox:CGRectMake(pos.x - ([imageBar imageWidth] / 2), pos.y, [imageButton imageWidth] * 2, [imageButton imageHeight] * 2)];
		[super setEnabled:FALSE];
	}
	return self;
}

// touch moved
- (void) touchMovedAtPoint:(CGPoint)newPoint
{
	if(![super enabled] || ![super touched])
		return;
	
	// If the touched moved beyond the bounding box, untouch it and ignore all further attempts
	if([super locked] && ![super sticky])
	{
		if([super checkBoundingBox:newPoint])
			[super setSelected:TRUE];
		else
			[super setSelected:FALSE];
		
		//[self setSelected:[self touched]];
	}
	else if(![super locked])
	{
		CGRect newBox = super.boundingBox;
		newBox.origin.x = newPoint.x;
		
		if(newBox.origin.x < offset)
			newBox.origin.x = offset;
			
		if(newBox.origin.x > offset + [imageBar imageWidth])
			newBox.origin.x = offset + [imageBar imageWidth];
		
		value = newBox.origin.x - offset;
		
		super.boundingBox = newBox;
		[self performAction];
	}
}

- (void) setButtonColourFilterRed:(float)red green:(float)green  blue:(float)blue alpha:(float)alpha
{
	[imageButton setColourFilterRed:red green:green blue:blue alpha:alpha];
}

- (float) returnButtonPosition
{
	return (value / [imageBar imageWidth]);
}

- (void) setButtonPosition:(float)valueFloat
{
	value = valueFloat * [imageBar imageWidth];
	CGRect newBox = super.boundingBox;
	newBox.origin.x = value + offset;
	super.boundingBox = newBox;
}

- (void) setTarget:(id)newTarget andAction:(SEL)newAction
{
	target = newTarget;
	action = newAction;
	if([target respondsToSelector:action])
		[super setEnabled:TRUE];
	else
		[super setEnabled:FALSE];
}

- (void) performAction
{
	
	if([target respondsToSelector:action])
		[target performSelector:action];
}

// render
- (void) render
{
	[super render];

	if(![super enabled])
		return;
	
	[imageBar render];
	[imageButton renderAtPoint:super.boundingBox.origin centerOfImage:YES];
}

@end
