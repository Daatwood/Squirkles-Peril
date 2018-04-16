//
//  OptionControl.h
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 9/20/10.
//  Copyright 2010 Dustin Atwood. All rights reserved.
//

/*
 An Option Control is a independant control. It may act like an abstractEntity 
 but does not inherit it. Containing state and internal variables similar. The
 Control instead contains an array of button controls. Some for scrolling and
 others for menu or drag-create items.
 
*/

// X and Y Inital Spacing
// X and Y between item Spacing
// # of items across

#import <Foundation/Foundation.h>
#import "ButtonControl.h"
#import "AbstractControl.h"
#import "SettingManager.h"

@interface OptionControl : NSObject
{
	SettingManager* sharedSettingManager;
	
	// Control State
	uint state;
	// Position
	CGPoint position;
	// Items
	NSMutableArray* items;
	// Selected Item
	int selectedItemIndex;
	// Scroll Bar
	//ScrollBar* scrollBar;
	// BackgroundImage
	Image* backgroundImage;
	// Style; Standard(Image Icons) or Wide(Text Icons)
	bool standard;
	
	// The type of Option Control; Menu vs Icons.
	uint controlType;
}

@property(nonatomic) uint state, controlType;

- (id) initAsType:(uint)cType;

// Add an UID item and everything set automaticly
- (void) addUID:(uint)uid setSelected:(BOOL)select;

// Manually Set item by providing image name
- (void) addItemWithImage:(NSString*)imageName setSelected:(BOOL)select hasSelect:(BOOL)sel hidesOnClick:(BOOL)hide;

// Remove Item with Tag
- (void) removeItemAtIndex:(int)index;

// Return the last selected item
- (int) returnSelectedItem;

// Return the last selected item UID

// Remove all Items
- (void) removeAllItems;

// Visible Items
- (int) visibleItems;

// Reload Items
- (void) reloadItems;

// Show, when moving from hide to show the control, will move upward, stays disabled until moving stops.
- (void) show;

// Hide, when moving from shown it will move downward out of view. Also becomes disabled before moving
- (void) hide;

// touch began
- (void) touchBeganAtPoint:(CGPoint)beginPoint;

// touch moved
- (void) touchMovedAtPoint:(CGPoint)newPoint;

// touch ended
- (void) touchEndedAtPoint:(CGPoint)endPoint;

// render
- (void) render;

// update
- (void) updateWithDelta:(GLfloat)delta;

@end
