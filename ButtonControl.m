//
//  ButtonControl.m
//  BadBadMonkey
//
//  Created by Dustin Atwood on 9/20/10.
//  Copyright 2010 Litlapps. All rights reserved.
//

#import "ButtonControl.h"


@implementation ButtonControl

@synthesize scale, rotation, font;

- (void) dealloc
{
	[font release];
	font = nil;
	[text release];
	text = nil;
	textPosition = CGPointZero;
	[imageButton release];
	imageButton = nil;
	[imageSubButton release];
	imageSubButton = nil;
	scale = 0;
	rotation = 0;
	target = nil;
	action = nil;
	[super dealloc];
}

- (id) initAsButtonImageNamed:(NSString*)imageName withSubImageNamed:(NSString*)subImageName atScreenPercentage:(CGPoint)screenPercentage
{
	self = [super initWithCGRect:CGRectZero];
	if(self != nil)
	{
		font = [[AngelCodeFont alloc] initWithFontImageNamed:FONT21 controlFile:FONT21 scale:1.0f filter:GL_LINEAR];
		[self setAtScreenPercentage:screenPercentage];
		[self setButtonImageNamed:imageName withSubImageNamed:subImageName];
		CGPoint position;
		position.x = [[Director sharedDirector] screenBounds].size.width * (screenPercentage.x / 100);
		position.y = [[Director sharedDirector] screenBounds].size.height * (screenPercentage.y / 100);
		[self setBoundingBox:CGRectMake(position.x, position.y, [imageButton imageWidth], [imageButton imageHeight])];

		[self setScale:1.0f];
		[super setEnabled:FALSE];
	}
	return self;
}

- (id) initAsButtonImageNamed:(NSString*)imageName withText:(NSString*)buttonText withFontName:(NSString*)fontName atScreenPercentage:(CGPoint)screenPercentage
{
	self = [super initWithCGRect:CGRectZero];
	if(self != nil)
	{
		font = [[AngelCodeFont alloc] initWithFontImageNamed:fontName controlFile:fontName scale:1.0f filter:GL_LINEAR];
		[self setAtScreenPercentage:screenPercentage];
		[self setButtonImageNamed:imageName withSubImageNamed:nil];
		CGPoint position;
		position.x = [[Director sharedDirector] screenBounds].size.width * (screenPercentage.x / 100);
		position.y = [[Director sharedDirector] screenBounds].size.height * (screenPercentage.y / 100);
		[self setBoundingBox:CGRectMake(position.x, position.y, [imageButton imageWidth], [imageButton imageHeight])];
		[self setText:buttonText];
		
		[self setScale:1.0f];
		[self setLocked:YES];
		[super setEnabled:FALSE];
	}
	return self;
}

- (id) initAsAtlasButtonImageNamed:(NSString*)imageName withSubImageNamed:(NSString*)subImageName atScreenPercentage:(CGPoint)screenPercentage
{
	self = [super initWithCGRect:CGRectZero];
	if(self != nil)
	{
		font = [[AngelCodeFont alloc] initWithFontImageNamed:FONT21 controlFile:FONT21 scale:1.0f filter:GL_LINEAR];
		[self setAtScreenPercentage:screenPercentage];
		[self setAtlasButtonImageNamed:imageName withSubImageNamed:subImageName];
		CGPoint position;
		position.x = [[Director sharedDirector] screenBounds].size.width * (screenPercentage.x / 100);
		position.y = [[Director sharedDirector] screenBounds].size.height * (screenPercentage.y / 100);
		[self setBoundingBox:CGRectMake(position.x, position.y, [imageButton imageWidth], [imageButton imageHeight])];
		
		[self setScale:1.0f];
		[self setLocked:YES];
		[super setEnabled:FALSE];
	}
	return self;
}

- (id) initAsAtlasButtonImageNamed:(NSString*)imageName withText:(NSString*)buttonText withFontName:(NSString*)fontName atScreenPercentage:(CGPoint)screenPercentage
{
	self = [super initWithCGRect:CGRectZero];
	if(self != nil)
	{
		font = [[AngelCodeFont alloc] initWithFontImageNamed:fontName controlFile:fontName scale:1.0f filter:GL_LINEAR];
		[self setAtScreenPercentage:screenPercentage];
		[self setAtlasButtonImageNamed:imageName withSubImageNamed:nil];
		CGPoint position;
		position.x = [[Director sharedDirector] screenBounds].size.width * (screenPercentage.x / 100);
		position.y = [[Director sharedDirector] screenBounds].size.height * (screenPercentage.y / 100);
		[self setBoundingBox:CGRectMake(position.x, position.y, [imageButton imageWidth], [imageButton imageHeight])];
		[self setText:buttonText];
		
		[self setScale:1.0f];
		[self setLocked:YES];
		[super setEnabled:FALSE];
	}
	return self;
}

- (void) setFontColourFilterRed:(float)red green:(float)green  blue:(float)blue alpha:(float)alpha
{
	[font setColourFilterRed:red green:green blue:blue alpha:alpha];
}

- (void) setButtonColourFilterRed:(float)red green:(float)green  blue:(float)blue alpha:(float)alpha
{
	[imageButton setColourFilterRed:red green:green blue:blue alpha:alpha];
}

- (void) setImageColourFilterRed:(float)red green:(float)green  blue:(float)blue alpha:(float)alpha
{
	[imageSubButton setColourFilterRed:red green:green blue:blue alpha:alpha];
}

- (void) setButtonColourWithString:(NSString*)colorString
{
	[imageButton setColourWithString:colorString];
}

- (void) setTarget:(id)newTarget andAction:(SEL)newAction
{
	target = newTarget;
	action = newAction;
	if([target respondsToSelector:action])
	{
		[super setEnabled:TRUE];
		[super setVisible:TRUE];
	}
	else
	{
		[super setEnabled:FALSE];
		[super setVisible:FALSE];
        NSLog(@"Target does not Respond to Action");
    }
}

- (void) setText:(NSString*)newText
{
	[text release];
	text = [[NSString alloc] initWithString:newText];
	textPosition.x = super.boundingBox.origin.x - ([font getWidthForString:text] / 2);
	textPosition.y = super.boundingBox.origin.y + ([font getHeightForString:text] * 0.5);
	
	[imageSubButton release];
	imageSubButton = nil;
}

- (void) setAtScreenPercentage:(CGPoint)screenPercentage
{
	CGPoint position;
	position.x = [[Director sharedDirector] screenBounds].size.width * (screenPercentage.x / 100);
	position.y = [[Director sharedDirector] screenBounds].size.height * (screenPercentage.y / 100);
	[self setBoundingBox:CGRectMake(position.x, position.y, self.boundingBox.size.width, self.boundingBox.size.height)];
	
	if(imageSubButton != nil)
	{
		textPosition.x = super.boundingBox.origin.x;
		textPosition.y = super.boundingBox.origin.y;
	}
	else
	{
		textPosition.x = super.boundingBox.origin.x - ([font getWidthForString:text] / 2);
		textPosition.y = super.boundingBox.origin.y + ([font getHeightForString:text] * 0.5);
	}
}

- (void) setAtlasButtonImageNamed:(NSString*)imageName withSubImageNamed:(NSString*)subImageName
{
	[imageButton release];
	imageButton = [[ResourceManager sharedResourceManager] getImageWithImageNamed:imageName withinAtlasNamed:@"InterfaceAtlas"];
	
	if(subImageName)
	{
		[imageSubButton release];
		imageSubButton = [[ResourceManager sharedResourceManager] getImageWithImageNamed:subImageName withinAtlasNamed:@"InterfaceAtlas"];
		[imageSubButton setColourFilterRed:0.0 green:1.0 blue:0.5 alpha:1.0];
		textPosition.x = super.boundingBox.origin.x;
		textPosition.y = super.boundingBox.origin.y;
	}
	
	if(!imageLock)
	{
		imageLock = [[ResourceManager sharedResourceManager] getImageWithImageNamed:@"InterfaceLock" withinAtlasNamed:@"InterfaceAtlas"];
		[imageLock setScale:0.75];
		[imageLock setColourFilterRed:1.0 green:0.0 blue:0.0 alpha:1.0];
	}
}

- (void) setButtonImageNamed:(NSString*)imageName withSubImageNamed:(NSString*)subImageName
{
	[imageButton release];
	imageButton = [[Image alloc] initWithImageNamed:imageName];
	
	if(subImageName)
	{
		[imageSubButton release];
		imageSubButton = [[Image alloc] initWithImageNamed:subImageName];
		textPosition.x = super.boundingBox.origin.x;
		textPosition.y = super.boundingBox.origin.y;
	}
	
	if(!imageLock)
	{
		imageLock = [[ResourceManager sharedResourceManager] getImageWithImageNamed:@"InterfaceLock" withinAtlasNamed:@"InterfaceAtlas"];
		//[imageLock setScale:0.75];
		//[imageLock setColourFilterRed:1.0 green:0.0 blue:0.0 alpha:1.0];
	}
}

- (void) performAction
{
	if([target respondsToSelector:action])
		[target performSelector:action];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

// touch began
- (void) touchBeganAtPoint:(CGPoint)beginPoint
{
	[super touchBeganAtPoint:beginPoint];
    
    if([super touched])
        [[SoundManager sharedSoundManager] playSoundWithKey:@"ButtonClick" gain:1.0f pitch:1.0f location:Vector2fZero shouldLoop:NO sourceID:-1];
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
	
	if([super activated] && [super touchable])
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performAction) name:@"BUTTON_PERFORM_ACTION" object:nil];
}

// render
- (void) render
{
	[super render];
	
	if(![super visible])
		return;
	
	if(imageSubButton != nil)
	{
		
		if ([super selected])
		{
			[imageButton setScale:0.9];
			[imageSubButton setScale:0.9];
		}
		else
		{
			[imageButton setScale:1.0];
			[imageSubButton setScale:1.0];
		}
		
		[imageButton renderAtPoint:super.boundingBox.origin centerOfImage:YES];
		[imageSubButton renderAtPoint:textPosition centerOfImage:YES];
	}
	else
	{
		if ([super selected])
		{
			[imageButton setScale:0.9];
			[font setScale:0.9];
		}
		else
		{
			[imageButton setScale:1.0];
			[font setScale:1.0];
		}
		
		[imageButton renderAtPoint:super.boundingBox.origin centerOfImage:YES];
		[font drawStringAt:textPosition text:text];
	}
	
	if(![super enabled])
		[imageLock renderAtPoint:super.boundingBox.origin centerOfImage:YES];
}

// update
- (void) updateWithDelta:(GLfloat)delta
{
	[super updateWithDelta:delta];
}

@end
