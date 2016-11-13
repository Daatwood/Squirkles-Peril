//
//  LabelControl.m
//  BadBadMonkey
//
//  Created by Dustin Atwood on 1/17/11.
//  Copyright 2011 Litlapps. All rights reserved.
//

#import "LabelControl.h"


@implementation LabelControl

@synthesize text, font, centerPoint, identifier;

- (id)initWithFontName:(NSString*)fontString;
{
	if(self = [super init])
	{
		font = [[AngelCodeFont alloc] initWithFontImageNamed:fontString controlFile:fontString scale:1.0f filter:GL_LINEAR];
		centerPoint = CGPointZero;
	}
	return self;
}

- (void) setText:(NSString*)newText atSceenPercentage:(CGPoint)point;
{
	[self setText:newText];
	centerPoint.x = [[Director sharedDirector] screenBounds].size.width * point.x / 100;
	centerPoint.y = [[Director sharedDirector] screenBounds].size.height * point.y / 100;
	
	centerPoint.x -= ([font getWidthForString:text] / 2);
	centerPoint.y += ([font getHeightForString:text] / 2);
}

- (void) render
{
	if(![super visible])
		return;
	
	[font drawStringAt:centerPoint text:text];
}

@end
