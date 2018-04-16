//
//  InformativeControl.h
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 1/3/11.
//  Copyright 2011 Dustin Atwood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import "Image.h"
#import "AngelCodeFont.h"


// A Simple Control that displays Text on
// a Black Button Looking Background.
@interface InformativeControl : NSObject 
{
	AngelCodeFont* font;
	CGPoint infoPosition;
	
	NSString* infoTextOne;
	CGPoint infoTextOnePosition;
	NSString* infoTextTwo;
	CGPoint infoTextTwoPosition;
	
	// The Image
	Image* infoImage;
	CGPoint infoImagePosition;
	
	// Button Type
	bool isLargeButton;
	Image* imageButton;
}
@property (nonatomic, retain) AngelCodeFont* font;

- (id) initAtPosition:(CGPoint)position isLargeButton:(BOOL)isLarge;

- (void) setTextOne:(NSString*)text;

- (void) setTextTwo:(NSString*)text;

- (void) setImageWithName:(NSString*)imageName atPosition:(CGPoint)pos;

- (void) render;

@end
