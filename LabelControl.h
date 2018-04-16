//
//  LabelControl.h
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 1/17/11.
//  Copyright 2011 Dustin Atwood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import "Director.h"
#import "AngelCodeFont.h"

@interface LabelControl : NSObject 
{
	// reference to director manager
	AngelCodeFont* font;
	
	CGPoint centerPoint;
	
	NSString* text;
	
	BOOL enabled;
}
@property(nonatomic) CGPoint centerPoint;
@property(nonatomic, copy) NSString* text;
@property(nonatomic) BOOL enabled;
@property(nonatomic, retain) AngelCodeFont* font;

- (id)initWithFontName:(NSString*)fontString;

- (void) setText:(NSString*)newText atSceenPercentage:(CGPoint)point;

- (void) render;

@end
