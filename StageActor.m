//
//  StageActor.m
//  BadBadMonkey
//
//  Created by Dustin Atwood on 9/20/10.
//  Copyright 2010 Litlapps. All rights reserved.
//

#import "StageActor.h"


@implementation StageActor

@synthesize locked, editing;

- (id) initAsPreview:(BOOL)preview;
{
	self = [super init];
	if(self != nil)
	{
		previewMode = preview;
		//backgroundActor = [[ImageActor alloc] initWithImageNamed:@"BasicBackground" atPosition:CGPointMake(160, 240)];
		//[backgroundActor setLocked:YES];
		
		backgroundActor = [[BackgroundActor alloc] initWithImageName:@""];
		
		sharedSettingManager = [SettingManager sharedSettingManager];
		//[backgroundActor setSize:CGPointMake(IconWidthStandard, IconHeightStandard)];
		foregroundActor = [[MultiImageActor alloc] init];
		displayItemActor = [[MultiImageActor alloc] init];
		deletionBar = [[Image alloc] initWithImageNamed:@"DeletionBar"];
		[self setLocked:YES];
		if(!previewMode)
		{
			[self loadBackgroundActor];
			[self loadForegroundActor];
			[self loadDisplayItemActor];
			
		}
	}
	return self;
}

// Load Background Actor
- (void) loadBackgroundActor
{
	if(previewMode)
		return;
}

// Load Foreground Actor
- (void) loadForegroundActor
{
	if(previewMode)
		return;
}

// Load DisplayItem Actor
- (void) loadDisplayItemActor
{
	if(previewMode)
		return;
}

// Set Background Actor 
- (void) setBackgroundActor
{
	//[backgroundActor setImage:@"BasicBackground"];
	
	//NSArray* eItem = [NSArray arrayWithArray:
	//				  [sharedSettingManager getItemsInBin:ItemBin_Equipped ofType:ItemType_Background]];
	
	//if([eItem count] > 0)
	//	[backgroundActor setImage:[sharedSettingManager get:ItemKey_Image withUID:[[eItem objectAtIndex:0] intValue]]];
	//else
	//	[backgroundActor setImage:@"BasicBackground"];
	
}

- (void) nextBackgroundImage
{
	[backgroundActor nextStage];
	// Retrieve a list of backgrounds then equip the one at index 0
	// Currently only supports for two backgrounds
	
	//NSArray* storedImages = [NSArray arrayWithArray:
	//						 [sharedSettingManager getItemsInBin:ItemBin_Stored ofType:ItemType_Background]];
	
	//if([storedImages count] == 1)
	//	return;
	
	//[sharedSettingManager equipItem:[[storedImages objectAtIndex:1] intValue]];
	//[self setBackgroundActor];
	
}

- (void) previousBackgroundImage
{
	[backgroundActor previousStage];
	//NSArray* storedImages = [NSArray arrayWithArray:
	//						 [sharedSettingManager getItemsInBin:ItemBin_Stored ofType:ItemType_Background]];
	//
	//if([storedImages count] == 0)
	//	return;
	
	//[sharedSettingManager equipItem:[[storedImages objectAtIndex:0] intValue]];
	//[self setBackgroundActor];
}

// Set Background Actor 
- (void) setBackgroundActorImage:(NSString*)imageName
{
	if(!previewMode)
		return;
}


// Add Foreground Actor Item
- (void) addItemToForegroundActor:(uint)uid
{
	if(!previewMode)
		return;
	
	[foregroundActor addImageActorByUID:uid];
}

// Add Foreground Actor image
- (void) addItemImageToForegroundActor:(NSString*)imageName
{
	if (!previewMode) 
		return;
	
	[foregroundActor addImageActorByImageName:imageName];
}

// Add DisplayItem Actor Item
- (void) addItemToDisplayItemActor:(uint)uid
{
	if(!previewMode)
		return;
}

// Clear all actors
- (void) clearActors
{
	//[backgroundActor setImage:nil];
	[foregroundActor removeAllActors];
	[displayItemActor removeAllActors];
}

// Return Selected Index Type
- (int) returnSelectedItemType
{
	if([displayItemActor activated])
		return ItemType_Display;
	else if([foregroundActor activated])
		return ItemType_Foreground;
	//else if([backgroundActor activated])
	//	return ItemType_Background;
	else
		return ItemType_Invalid;
}

// Lock Foreground
- (void) lockForeground
{
	[self setLocked:YES];
	[foregroundActor lockAllImageActors];
}

// Unlock Foreground
- (void) unlockForeground
{
	[self setLocked:NO];
	[foregroundActor unlockAllImageActors];
}

// Lock DisplayItem
- (void) lockDisplayItem
{
	[self setLocked:YES];
	[displayItemActor lockAllImageActors];
}

// Unlock DisplayItem
- (void) unlockDisplayItem
{
	[self setLocked:NO];
	[displayItemActor unlockAllImageActors];
}

// touch began
- (void) touchBeganAtPoint:(CGPoint)beginPoint
{
	if(![self locked])
	{
		[self setEditing:TRUE];
		[displayItemActor touchBeganAtPoint:beginPoint];
		if([displayItemActor selected])
			return;
		[foregroundActor touchBeganAtPoint:beginPoint];
		if([foregroundActor selected])
			return;
		[self setEditing:FALSE];
	}
	[backgroundActor touchBeganAtPoint:beginPoint];
	
	/*
	if ([displayItemActor touchBeganAtPoint:beginPoint]) 
	{
		// If unlocked and touch was successful then enter editing mode
		if(![self locked])
			[self setEditing:TRUE];
		return TRUE;
	}
	if ([foregroundActor touchBeganAtPoint:beginPoint]) 
	{
		if(![self locked])
			[self setEditing:TRUE];
		return TRUE;
	}
	if ([backgroundActor touchBeganAtPoint:beginPoint]) 
		return TRUE;
	
	return FALSE;
	 */
}

// touch moved
- (void) touchMovedAtPoint:(CGPoint)newPoint
{
	if(![self locked])
	{
		if([displayItemActor selected])
		{
			[displayItemActor touchMovedAtPoint:newPoint];
			[self setEditing:[displayItemActor selected]];
			return;
		}
		if([foregroundActor selected])
		{
			[foregroundActor touchMovedAtPoint:newPoint];
			[self setEditing:[foregroundActor selected]];
			return;
		}
	}
	[backgroundActor touchMovedAtPoint:newPoint];
}

// touch ended
- (void) touchEndedAtPoint:(CGPoint)endPoint
{
	[self setEditing:FALSE];
	
	if(![self locked])
	{
		if([displayItemActor selected])
		{
			[displayItemActor touchEndedAtPoint:endPoint];
			if ([displayItemActor activated])
				return;
		}
		if([foregroundActor selected])
		{
			[foregroundActor touchEndedAtPoint:endPoint];
			if ([foregroundActor activated])
			{
				NSLog(@"foreground Active");
				if(CGRectContainsPoint(CGRectMake(0,0,320,48), endPoint))
					[foregroundActor removeImageActorAtIndex:[foregroundActor returnSelectedImageActorIndex]];
				return;
			}
		}
	}
	
	[backgroundActor touchEndedAtPoint:endPoint];
	//if ([backgroundActor activated])
	//	return;
	
	return;
	
	
	
	
	/*
	[self setEditing:FALSE];
	
	uint result = [displayItemActor touchMovedAtPoint:newPoint];
	if (result != Touch_Unsuccessful) 
		return result;
	
	if ([displayItemActor touchEndedAtPoint:endPoint])
	{
		// It returned true that the item was successfully touched.
		// If intersects with deletion bar, remove it.
		
		//(position.x - (size.x * .75), position.y - (size.y * .75), size.x * 1.25, size.y * 1.25)
		
		//int actorX = [[[foregroundActor actors] objectAtIndex:[foregroundActor returnSelectedImageActorIndex]] position].x;
		//int actorY = [[[foregroundActor actors] objectAtIndex:[foregroundActor returnSelectedImageActorIndex]] position].y;
		//int actorW = [[[foregroundActor actors] objectAtIndex:[foregroundActor returnSelectedImageActorIndex]] size].width;
		//int actorH = [[[foregroundActor actors] objectAtIndex:[foregroundActor returnSelectedImageActorIndex]] size].height;
		
		// still return true
		return TRUE;
	}
	if ([foregroundActor touchEndedAtPoint:endPoint]) 
	{
		if(CGRectContainsPoint(CGRectMake(0,0,320,40), endPoint))
			[foregroundActor removeImageActorAtIndex:[foregroundActor returnSelectedImageActorIndex]];
		//[self lockForeground];
		return TRUE;
	}
	if ([backgroundActor touchEndedAtPoint:endPoint]) 
		return TRUE;
	
	return FALSE;
	 */
}

// render
- (void) render
{
	[backgroundActor render];
	if(![self locked])
		[deletionBar renderAtPoint:CGPointMake(0, 0) centerOfImage:YES];
	[foregroundActor render];
	[displayItemActor render];
}

// update
- (void) updateWithDelta:(GLfloat)delta;
{
	[backgroundActor updateWithDelta:delta];
	[foregroundActor updateWithDelta:delta];
	[displayItemActor updateWithDelta:delta];
}

@end
