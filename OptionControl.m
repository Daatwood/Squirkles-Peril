//
//  OptionControl.m
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 9/20/10.
//  Copyright 2010 Dustin Atwood. All rights reserved.
//

#import "OptionControl.h"

@implementation OptionControl

@synthesize state, controlType;

- (id) initAsType:(uint)cType
{
	self = [super init];
	if (self != nil) 
	{
		[self setControlType:cType];
		sharedSettingManager = [SettingManager sharedSettingManager];
		position = CGPointMake(0, -1 * 0);
		items = [[NSMutableArray alloc] initWithCapacity:4];
		selectedItemIndex = -1;
		if([self controlType] == ControlType_Menu)
			backgroundImage = [[Image alloc] initWithImageNamed:@"Nothing"];
		else
			backgroundImage = [[Image alloc] initWithImageNamed:@"Nothing"];
		[backgroundImage setColourFilterRed:0.7 green:0.7 blue:0.7 alpha:1.0];
		[self setState:ControlState_Disabled];
	}
	return self;
}

- (void) addUID:(uint)uid setSelected:(BOOL)select
{
	ButtonControl* newItem;
	
	int iCount = [items count];
	
	int x,y;
	
	if([self controlType] == ControlType_Icon)
	{
		x = 40 + (62 * (iCount % 4));
		y = 40 + (62 * (2 - floor(iCount / 4)));
	}
	else if([self controlType] == ControlType_Menu)
	{
		x = 82.5 + (155 * (iCount % 2));
		y = 36 + (54 * floor(iCount / 2));
	}
	else if([self controlType] == ControlType_Hybrid)
	{
		if(iCount < 2)
		{
			x = 82.5 + (155 * (iCount % 2));
			y = 150;
		}
		else 
		{
			iCount -= 2;
			x = 36 + (62 * (iCount % 5));
			y = 35 + (62 * (floor(iCount / 5)));
		}
		
	}
	else
	{
		NSLog(@"OptionControl: State not supported.");
		return;
	}
	
	newItem = [[ButtonControl alloc] initAsButtonImageNamed:[NSString stringWithFormat:@"%@Icon",
															 [sharedSettingManager get:ItemKey_Image withUID:uid]] 
											 selectionImage:NO atPosition:CGPointMake(x,y)];
	
	[newItem setSelected:select];
	[newItem setDrawLock:![sharedSettingManager purchased:uid]];
	
	[newItem setTarget:self andAction:@selector(hide)];
	
	[items addObject:newItem];
}

- (void) addItemWithImage:(NSString*)imageName setSelected:(BOOL)select hasSelect:(BOOL)sel hidesOnClick:(BOOL)hide
{
	ButtonControl* newItem;
	
	int iCount = [items count];
	
	int x,y;
	
	if([self controlType] == ControlType_Icon)
	{
		x = 40 + (62 * (iCount % 4));
		y = 40 + (62 * (2 - floor(iCount / 4)));
	}
	else if([self controlType] == ControlType_Menu)
	{
		x = 82.5 + (155 * (iCount % 2));
		y = 36 + (54 * floor(iCount / 2));
	}
	else if([self controlType] == ControlType_Hybrid)
	{
		if(iCount < 2)
		{
			x = 82.5 + (155 * (iCount % 2));
			y = 150;
		}
		else 
		{
			iCount -= 2;
			x = 36 + (62 * (iCount % 5));
			y = 35 + (62 * (floor(iCount / 5)));
		}

	}
	else
	{
		NSLog(@"OptionControl: State not supported.");
		return;
	}

	newItem = [[ButtonControl alloc] initAsButtonImageNamed:imageName selectionImage:sel
												 atPosition:CGPointMake(x,y)];
					
	[newItem setSelected:select];
	[newItem setDrawLock:NO];
	
	if(hide)
		[newItem setTarget:self andAction:@selector(hide)];
	
	[items addObject:newItem];
}

// Remove Item with Tag
- (void) removeItemAtIndex:(int)index
{
	[items removeObjectAtIndex:index];
}

// Modify Item with Tag
- (int) returnSelectedItem;
{
	int sel = selectedItemIndex;
	selectedItemIndex = -1;
	return sel;
}

// Remove all Items
- (void) removeAllItems
{
	[items removeAllObjects];
}

// Visible Items
- (int) visibleItems
{
	if(standard)
		return 12;
	else
		return 3;
}

// Reload Items
- (void) reloadItems
{
	
}

// Show, when moving from hide to show the control, will move upward, stays disabled until moving stops.
- (void) show
{
	[self setState:ControlState_Showing];
}

// Hide, when moving from shown it will move downward out of view. Also becomes disabled before moving
- (void) hide
{
	[self setState:ControlState_Hiding];
}

// touch began
- (void) touchBeganAtPoint:(CGPoint)beginPoint
{
	if([self state] != ControlState_Normal)
		return;
	
	//if([items count] > [self visibleItems])
	//{
		//[scrollBar touchBeganAtPoint:beginPoint];
		//		return;
		//}
	
	//for(int i = [scrollBar getScrollingOffset]; i < [scrollBar getScrollingOffset] + [self visibleItems]; i++)
	for(int i = 0; i < [items count]; i++)
	{
		[[items objectAtIndex:i] touchBeganAtPoint:beginPoint];
	}
}

// touch moved
- (void) touchMovedAtPoint:(CGPoint)newPoint
{
	if([self state] != ControlState_Normal)
		return;
	
	//if([items count] > [self visibleItems])
	///{
	//	[scrollBar touchMovedAtPoint:newPoint];
	//		return;
	//}
	
	//for(int i = [scrollBar getScrollingOffset]; i < [scrollBar getScrollingOffset] + [self visibleItems]; i++)
	for(int i = 0; i < [items count]; i++)
	{
		[[items objectAtIndex:i] touchMovedAtPoint:newPoint];
	}
}

// touch ended
- (void) touchEndedAtPoint:(CGPoint)endPoint
{
	if([self state] != ControlState_Normal)
		return;
	
	//if([items count] > [self visibleItems])
	//{
	//	[scrollBar touchEndedAtPoint:endPoint];
	//	return;
	//}
	
	//for(int i = [scrollBar getScrollingOffset]; i < [scrollBar getScrollingOffset] + [self visibleItems]; i++)
	selectedItemIndex -1;
	for(int i = 0; i < [items count]; i++)
	{
		[[items objectAtIndex:i] touchEndedAtPoint:endPoint];
		if([[items objectAtIndex:i] activated])
		{
			selectedItemIndex = i;
			[[items objectAtIndex:i] performAction];
			return;
		}
	}
}

// render
- (void) render
{
	if([self state] == ControlState_Disabled)
		return;
	
	[backgroundImage renderAtPoint:position centerOfImage:YES];
	
	if([self state] != ControlState_Normal)
		return;
	
	//[scrollBar render];
	
	if([items count] <= 0)
		return;
	
	//for(int i = [scrollBar getScrollingOffset]; i < [scrollBar getScrollingOffset] + [self visibleItems]; i++)
	for(int i = 0; i < [items count]; i++)
	{
		// Also need to find and draw the position here.
		[[items objectAtIndex:i] render];
	}
}

// update
- (void) updateWithDelta:(GLfloat)delta
{
	switch ([self state]) 
	{
		case ControlState_Normal:
		{
			//[scrollBar updateWithDelta:delta];
			
			//for(int i = [scrollBar getScrollingOffset]; i < [scrollBar getScrollingOffset] + [self visibleItems]; i++)
			for(int i = 0; i < [items count]; i++)
			{
				// Also need to find and draw the position here.
				[[items objectAtIndex:i] updateWithDelta:delta];
			}
			break;
		}
		case ControlState_Showing:
		{
			position.y += 72.0f * (0.2f * 2);
			if(position.y >= 0) 
			{
				position.y = 0;
				[self setState:ControlState_Normal];
			}
			break;
		}
		case ControlState_Hiding:
		{
			position.y -= 72.0f * (0.2f * 2);
			if(position.y < 0 * -1)
			{
				position.y = 0 * -1;
				[self setState:ControlState_Disabled];
			}
			break;
		}
		case ControlState_Disabled:
		{
			break;
		}
		default:
			break;
	}
	
	
}

@end
