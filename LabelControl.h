//
//  LabelControl.h
//  BadBadMonkey
//
//  Created by Dustin Atwood on 1/17/11.
//  Copyright 2011 Litlapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import "Director.h"
#import "AngelCodeFont.h"
#import "BaseControl.h"

@interface LabelControl : BaseControl 
{
	// When added to an array this will allow for identification
	uint identifier;
	
	// reference to director manager
	AngelCodeFont* font;
	
	CGPoint centerPoint;
	
	NSString* text;
}
@property(nonatomic) CGPoint centerPoint;
@property(nonatomic, copy) NSString* text;
@property(nonatomic, retain) AngelCodeFont* font;
@property(nonatomic) uint identifier;

- (id)initWithFontName:(NSString*)fontString;

- (void) setText:(NSString*)newText atSceenPercentage:(CGPoint)point;

- (void) render;

@end
