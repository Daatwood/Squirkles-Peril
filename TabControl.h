//
//  TabControl.h
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 9/20/10.
//  Copyright 2010 Dustin Atwood. All rights reserved.
//

// TabControl is a collection of icons, that switch between on and off
// but only 1 icon may be on at a time.

#import <Foundation/Foundation.h>
#import "AbstractControl.h"


@interface TabControl : AbstractControl
{
	// Items, The items that are contained within the TabControl
	NSMutableArray* items;
	// Selected Item, The currently selected item
	int selectedItemIndex;
	// Index of the currently touch item
	int touchedItemIndex;

}

- (id) init;

- (CGColorRef) getColor:(int)colorIndex;

// Add Item with Tag
- (void) addItem:(uint)item;

// Remove Item with Tag
- (void) removeItemAtIndex:(int)index;

// Remove all Items
- (void) removeAllItems;

@end
