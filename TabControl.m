//
//  TabControl.m
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 9/20/10.
//  Copyright 2010 Dustin Atwood. All rights reserved.
//

#import "TabControl.h"


@implementation TabControl

- (id) init
{
	self = [super initAtPosition:CGPointMake(161, 30) withSize:CGPointMake(309, 57)];
	if(self != nil)
	{
		items = [[NSMutableArray alloc] initWithCapacity:4];
		selectedItemIndex = 0;
		touchedItemIndex = -1;
		
		
	}
	return self;
}

- (CGColorRef) getColor:(int)colorIndex
{
	switch (colorIndex) 
	{
		case 0:
			return [UIColor yellowColor].CGColor;
		case 1:
			return [UIColor blueColor].CGColor;
		case 2:
			return [UIColor greenColor].CGColor;
		case 3:
			return [UIColor purpleColor].CGColor;
		case 4:
			return [UIColor redColor].CGColor;
		default:
			return [UIColor blackColor].CGColor;
	}
}

// Add Item with Tag
- (void) addItem:(uint)item
{
	if([items count] < 5)
	{
		IconControl* newItem = [[IconControl alloc] initAtPosition:CGPointMake(35 + 62 * [items count], 30) withSize:CGPointMake(IconHeightStandard, IconWidthStandard) 
													   normalColor:[UIColor whiteColor].CGColor selectedColor:[self getColor:[items count]] withText:
								[sharedSettingManager get:ItemKey_Text withUID:item]];
		[items addObject:newItem];
	}
	else
		NSLog(@"Error: Tab Control is Full.");
}

// Remove Item with Tag
- (void) removeItem:(IconControl*)item atIndex:(int)index
{
	[items removeObjectAtIndex:index];
}

// Modify Item with Tag
- (IconControl*) modifyItemAtIndex:(int)index
{
	return [items objectAtIndex:index];
}

// Remove all Items
- (void) removeAllItems
{
	[items removeAllObjects];
}

// touch began
- (uint) touchBeganAtPoint:(CGPoint)beginPoint
{
	// Check touch for each when come back true save the tag.
	for(IconControl* anItem in items)
	{
		if([anItem touchBeganAtPoint:beginPoint])
		{
			touchedItemIndex = [items indexOfObject:anItem];
			return Touch_Selected;
		}
	}
	return Touch_Unsuccessful;
}

// touch moved
- (uint) touchMovedAtPoint:(CGPoint)newPoint
{
	if(touchedItemIndex == -1)
		return Touch_Unsuccessful;
	[[items objectAtIndex:touchedItemIndex] touchMovedAtPoint:newPoint];
	return Touch_Selected;
}

// touch ended
- (uint) touchEndedAtPoint:(CGPoint)endPoint
{
	if(touchedItemIndex == -1)
		return Touch_Unsuccessful;
	[[items objectAtIndex:touchedItemIndex] touchEndedAtPoint:endPoint];
	selectedItemIndex = touchedItemIndex;
	touchedItemIndex = -1;
	return Touch_Successful;
}

// render
- (void) render
{
	[super render];
	
	for(IconControl* anItem in items)
	{
		[anItem render];
	}
}

// update
- (void) updateWithDelta:(GLfloat)delta
{
	[super updateWithDelta:delta];
	// This ensures the selected icon wont appear unselected.
	[[items objectAtIndex:selectedItemIndex] setSelected:TRUE];
}


@end
