//
//  MGSkyBanner.m
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 2/6/11.
//  Copyright 2011 Dustin Atwood. All rights reserved.
//

#import "MGSkyBanner.h"


@implementation MGSkyBanner

- (id) initAtScreenHeight:(float)height withText:(NSString*)label andColorFilterRed:(GLfloat)aRed green:(GLfloat)aGreen blue:(GLfloat)aBlue
{
	if(self = [super init])
	{
		imageBanner = [[Image alloc] initWithImageNamed:@"imagebanner"];
		[imageBanner setColourFilterRed:aRed green:aGreen blue:aBlue alpha:1.0];
		labelBanner = [[LabelControl alloc] initWithFontName:FONT21];
		[labelBanner setText:label atSceenPercentage:CGPointMake(50, height)];
	}
	return self;
}

- (void) updateWithDelta:(float)aDelta
{
	
}

- (BOOL) hasCollidedWithPlayer:(JumpScrollerPlayer*)player withDelta:(GLfloat)delta
{
	return	NO;
}

- (void) applyVelocity:(float)velocity
{
	CGPoint currentPosition = [labelBanner centerPoint];
	
	currentPosition.y -= velocity;
	
	[labelBanner setCenterPoint:currentPosition];
}

- (void) render
{
	[imageBanner renderAtPoint:CGPointMake(160, [labelBanner centerPoint].y) centerOfImage:YES];
	[labelBanner render];
}

@end
