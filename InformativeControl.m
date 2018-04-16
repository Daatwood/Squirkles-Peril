//
//  InformativeControl.m
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 1/3/11.
//  Copyright 2011 Dustin Atwood. All rights reserved.
//

#import "InformativeControl.h"


@implementation InformativeControl

@synthesize font;

- (id) initAtPosition:(CGPoint)position isLargeButton:(BOOL)isLarge
{
	if( self = [super init])
	{
		infoTextOne = [NSString stringWithString:@""];
		infoTextTwo = [NSString stringWithString:@""];
		if(isLarge)
			imageButton = [[Image alloc] initWithImageNamed:@"Nothing"];
		else
			imageButton = [[Image alloc] initWithImageNamed:@"Nothing"];
		font = [[AngelCodeFont alloc] initWithFontImageNamed:FONT16 controlFile:FONT16 scale:1.0f filter:GL_LINEAR];
		infoPosition = position;
	}
	return self;
}

- (void) setTextOne:(NSString*)text
{
	infoTextOne = [[NSString stringWithString:text] copy];
	infoTextOnePosition.x = infoPosition.x - ([font getWidthForString:text] / 2);
	infoTextOnePosition.y = infoPosition.y + ([font getHeightForString:text] / 2);
}

- (void) setTextTwo:(NSString*)text
{
	infoTextTwo = [[NSString stringWithString:text] copy];
	infoTextTwoPosition.x = infoPosition.x - ([font getWidthForString:text] / 2);
	
	infoTextOnePosition.y = infoPosition.y + [font getHeightForString:text];
	infoTextTwoPosition.y = infoPosition.y;
}

- (void) setImageWithName:(NSString*)imageName atPosition:(CGPoint)pos;
{
	[infoImage release];
	infoImage = [[Image alloc] initWithImageNamed:imageName];
	infoImagePosition = pos;
}

- (void) render
{
	[imageButton renderAtPoint:infoPosition centerOfImage:YES];
	[infoImage renderAtPoint:infoImagePosition centerOfImage:YES];
	[font drawStringAt:infoTextOnePosition text:infoTextOne];
	[font drawStringAt:infoTextTwoPosition text:infoTextTwo];
}

@end
