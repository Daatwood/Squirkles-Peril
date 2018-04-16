//
//  ButtonControl.m
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 9/20/10.
//  Copyright 2010 Dustin Atwood. All rights reserved.
//

#import "ButtonControl.h"


@implementation ButtonControl

@synthesize drawLock, scale, rotation, font;

- (id) initAsButtonImageNamed:(NSString*)imageName withText:(NSString*)buttonText atScreenPercentage:(CGPoint)screenPercentage isRotated:(BOOL)rotated
{
	self = [super initWithCGRect:CGRectZero];
	if(self != nil)
	{
		font = [[AngelCodeFont alloc] initWithFontImageNamed:FONT21 controlFile:FONT21 scale:1.0f filter:GL_LINEAR];
		text = [NSString stringWithString:buttonText];
		[self setButtonImage:imageName withSelectionImage:NO];
		
		if(!rotated)
		{
			// Portait
			CGPoint position;
			position.x = [[Director sharedDirector] screenBounds].size.width * (screenPercentage.x / 100);
			position.y = [[Director sharedDirector] screenBounds].size.height * (screenPercentage.y / 100);
			[self setBoundingBox:CGRectMake(position.x, position.y, [buttonImage imageWidth], [buttonImage imageHeight])];
			
			textPosition.x = super.boundingBox.origin.x - ([font getWidthForString:text] / 2);
			textPosition.y = super.boundingBox.origin.y + ([font getHeightForString:text] * 0.6);
		}
		else
		{
			// landscape
			CGPoint position;
			position.x = [[Director sharedDirector] screenBounds].size.height * (screenPercentage.x / 100) + ([buttonImage imageWidth] / 2);
			position.y = [[Director sharedDirector] screenBounds].size.width * (screenPercentage.y / 100) - ([buttonImage imageHeight] / 2);
			[buttonImage setRotation:90];
			[self setBoundingBox:CGRectMake(position.y, [[Director sharedDirector] screenBounds].size.height  - position.x, [buttonImage imageHeight], [buttonImage imageWidth])];
			
			textPosition.x = super.boundingBox.origin.x - ([font getWidthForString:text] / 2);
			textPosition.y = super.boundingBox.origin.y + ([font getHeightForString:text] * 0.6);
			[font setRotation:90];
		}
		[self setScale:1.0f];
		[self setLocked:YES];
		[self setDrawLock:NO];
		[super setEnabled:FALSE];
	}
	return self;
}

- (id) initAsButtonImageNamed:(NSString*)imageName withSubImageNamed:(NSString*)subImageName atScreenPercentage:(CGPoint)screenPercentage isRotated:(BOOL)rotated
{
	self = [super initWithCGRect:CGRectZero];
	if(self != nil)
	{
		font = [[AngelCodeFont alloc] initWithFontImageNamed:FONT21 controlFile:FONT21 scale:1.0f filter:GL_LINEAR];
		[self setButtonImageNamed:imageName withSubImageNamed:subImageName];
		
		if(!rotated)
		{
			// Portait
			CGPoint position;
			position.x = [[Director sharedDirector] screenBounds].size.width * (screenPercentage.x / 100);
			position.y = [[Director sharedDirector] screenBounds].size.height * (screenPercentage.y / 100);
			[self setBoundingBox:CGRectMake(position.x, position.y, [buttonImage imageWidth], [buttonImage imageHeight])];
			
			textPosition.x = super.boundingBox.origin.x;// - ([imageSubButton imageWidth] / 2);
			textPosition.y = super.boundingBox.origin.y;// - ([imageSubButton imageHeight] / 2);
		}
		else
		{
			// landscape
			CGPoint position;
			position.x = [[Director sharedDirector] screenBounds].size.height * (screenPercentage.x / 100) + ([buttonImage imageWidth] / 2);
			position.y = [[Director sharedDirector] screenBounds].size.width * (screenPercentage.y / 100) - ([buttonImage imageHeight] / 2);
			[buttonImage setRotation:90];
			[self setBoundingBox:CGRectMake(position.y, [[Director sharedDirector] screenBounds].size.height  - position.x, [buttonImage imageHeight], [buttonImage imageWidth])];
			
			textPosition.x = super.boundingBox.origin.x - ([font getWidthForString:text] / 2);
			textPosition.y = super.boundingBox.origin.y + ([font getHeightForString:text] * 0.6);
			[font setRotation:90];
		}
		[self setScale:1.0f];
		[self setLocked:YES];
		[self setDrawLock:NO];
		[super setEnabled:FALSE];
	}
	return self;
}

- (id) initAsButtonImageNamed:(NSString*)imageName withText:(NSString*)buttonText selectionImage:(BOOL)sel atPosition:(CGPoint)pos;
{
	self = [super initWithCGRect:CGRectZero];
	if(self != nil)
	{
		font = [[AngelCodeFont alloc] initWithFontImageNamed:FONT21 controlFile:FONT21 scale:1.0f filter:GL_LINEAR];
		text = [NSString stringWithString:buttonText];
		[self setButtonImage:imageName withSelectionImage:sel];
		[self setBoundingBox:CGRectMake(pos.x, pos.y, [buttonImage imageWidth], [buttonImage imageHeight])];
		[self setScale:1.0f];
		[self setLocked:YES];
		[self setDrawLock:NO];
		[super setEnabled:FALSE];
		
		textPosition.x = super.boundingBox.origin.x - ([font getWidthForString:text] / 2);
		textPosition.y = super.boundingBox.origin.y + ([font getHeightForString:text] * 0.6);
	}
	return self;
}

- (id) initAsButtonImageNamed:(NSString*)imageName selectionImage:(BOOL)sel atPosition:(CGPoint)pos;
{
	return [self initAsButtonImageNamed:imageName withText:@"" selectionImage:sel atPosition:pos];
}

- (void) setFontColourFilterRed:(float)red green:(float)green  blue:(float)blue alpha:(float)alpha
{
	[font setColourFilterRed:red green:green blue:blue alpha:alpha];
}

- (void) setButtonColourFilterRed:(float)red green:(float)green  blue:(float)blue alpha:(float)alpha
{
	[buttonImage setColourFilterRed:red green:green blue:blue alpha:alpha];
}

- (void) setSubImageColourFilterRed:(float)red green:(float)green  blue:(float)blue alpha:(float)alpha
{
	[imageSubButton setColourFilterRed:red green:green blue:blue alpha:alpha];
}

- (void) setButtonColourWithString:(NSString*)colorString
{
	[buttonImage setColourWithString:colorString];
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

- (void) setText:(NSString*)newText
{
	[text release];
	text = [[NSString alloc] initWithString:newText];
	textPosition.x = super.boundingBox.origin.x - ([font getWidthForString:text] / 2);
	textPosition.y = super.boundingBox.origin.y + ([font getHeightForString:text] * 0.6);
}

- (void) setButtonImageNamed:(NSString*)imageName withSubImageNamed:(NSString*)subImageName
{
	[buttonImage release];
	buttonImage = [[Image alloc] initWithImageNamed:imageName];
	
	[imageSubButton release];
	imageSubButton = [[Image alloc] initWithImageNamed:subImageName];
}

- (void) setButtonImage:(NSString*)newImage withSelectionImage:(BOOL)sel
{
	[buttonImage release];
	buttonImage = [[Image alloc] initWithImageNamed:newImage];
	if(sel)
	{
		[buttonImageSelect release];
		buttonImageSelect = [[Image alloc] initWithImageNamed:[NSString stringWithFormat:@"%@Select",newImage]];
	}
}

- (void) performAction
{
	if([target respondsToSelector:action])
		[target performSelector:action];
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
	// If the button was successfully touched then perform
	[super touchEndedAtPoint:endPoint];
	
	if([super activated] && [super enabled])
	{
		// [self PlaySound];
		[self performAction];
		//NSLog(@"Performing Action");
	}
}

// render
- (void) render
{
	[super render];
	
	if(![super enabled])
		return;
	
	if(buttonImageSelect != nil)
	{
		if ([super selected])
		{
			[buttonImageSelect renderAtPoint:super.boundingBox.origin centerOfImage:YES];
			[font setColourFilterRed:0.0 green:0.0 blue:0.0 alpha:1.0];
		}
		else
		{
			[buttonImage renderAtPoint:super.boundingBox.origin centerOfImage:YES];
			[font setColourFilterRed:1.0 green:1.0 blue:1.0 alpha:1.0];
		}
	}
	else if(imageSubButton != nil)
	{
		if ([super selected])
		{
			[buttonImage setScale:0.9];
			[imageSubButton setScale:0.9];
		}
		else
		{
			[buttonImage setScale:1.0];
			[imageSubButton setScale:1.0];
		}
		
		[buttonImage renderAtPoint:super.boundingBox.origin centerOfImage:YES];
		[imageSubButton renderAtPoint:textPosition centerOfImage:YES];
	}
	else
	{
		if ([super selected])
		{
			[buttonImage setScale:0.9];
			[font setScale:0.9];
		}
		else
		{
			[buttonImage setScale:1.0];
			[font setScale:1.0];
		}
		
		[buttonImage renderAtPoint:super.boundingBox.origin centerOfImage:YES];
		[font drawStringAt:textPosition text:text];
	}
}

// update
- (void) updateWithDelta:(GLfloat)delta
{
	[super updateWithDelta:delta];
}

@end
