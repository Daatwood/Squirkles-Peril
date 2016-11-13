//
//  BrowseScene.m
//  BadBadMonkey
//
//  Created by Dustin Atwood on 9/20/10.
//  Copyright 2010 Litlapps. All rights reserved.
//

#import "BrowseScene.h"


@implementation BrowseScene

- (id) init
{
	self = [super init];
	if (self != nil) 
	{
		NSLog(@"Store Scene Initializing...");
		
	}
	return self;
}

- (void) initialize
{
	if(isInitialized)
		return;
	
	NSLog(@"Store Scene Loading...");
	
	font = [[AngelCodeFont alloc] initWithFontImageNamed:@"Komikandy16" controlFile:@"Komikandy16" scale:1.0f filter:GL_LINEAR];
	// The Scene Header Image
	sceneHeaderImage = [[Image alloc] initWithImageNamed:@"Stylize"];
	[sceneHeaderImage setPosition:CGPointMake(0, 0)];
	// Scene Description Image
	sceneDescriptionImage = [[Image alloc] initWithImageNamed:@"BrowseDescription"];
	[sceneDescriptionImage setPosition:CGPointMake(160, 150)];
	// User Point Display
	//indicatorUserPoints = [[CurrencyIndicator alloc] initAtPosition:CGPointMake(IndicatorUserX, IndicatorUserPointsY) asType:0];
	// User Treat Display
	//indicatorUserTreats = [[CurrencyIndicator alloc] initAtPosition:CGPointMake(IndicatorUserX, IndicatorUserTreatsY) asType:1];
	
	// Tab Bar Buttons
	stageTabButton = [[ButtonControl alloc] initAsButtonImageNamed:@"StageTab" selectionImage:YES atPosition:CGPointMake(37.5, 35)];
	[stageTabButton setTarget:self andAction:@selector(switchCategoryToStage)];
	[stageTabButton setSticky:YES];
	gameTabButton = [[ButtonControl alloc] initAsButtonImageNamed:@"GameTab" selectionImage:YES atPosition:CGPointMake(101, 35)];
	[gameTabButton setTarget:self andAction:@selector(switchCategoryToGame)];
	[gameTabButton setSticky:YES];
	treatTabButton = [[ButtonControl alloc] initAsButtonImageNamed:@"TreatsTab" selectionImage:YES atPosition:CGPointMake(165, 35)];
	[treatTabButton setTarget:self andAction:@selector(switchCategoryToTreat)];
	[treatTabButton setSticky:YES];
	pointTabButton = [[ButtonControl alloc] initAsButtonImageNamed:@"PointsTab" selectionImage:YES atPosition:CGPointMake(229, 35)];
	[pointTabButton setTarget:self andAction:@selector(switchCategoryToPoint)];
	[pointTabButton setSticky:YES];
	// Sub Tab Bar Buttons
	stageMiniTabButton = [[ButtonControl alloc] initAsButtonImageNamed:@"StageMiniTab" selectionImage:YES atPosition:CGPointMake(57, 85)];
	[stageMiniTabButton setTarget:self andAction:@selector(switchCategoryToStage)];
	[stageMiniTabButton setSticky:YES];
	itemMiniTabButton = [[ButtonControl alloc] initAsButtonImageNamed:@"ItemMiniTab" selectionImage:YES atPosition:CGPointMake(160, 85)];
	[itemMiniTabButton setTarget:self andAction:@selector(switchCategoryToItem)];
	[itemMiniTabButton setSticky:YES];
	overlayMiniTabButton = [[ButtonControl alloc] initAsButtonImageNamed:@"OverlayMiniTab" selectionImage:YES atPosition:CGPointMake(263, 85)];
	[overlayMiniTabButton setTarget:self andAction:@selector(switchCategoryToOverlay)];
	[overlayMiniTabButton setSticky:YES];
	// Close Scene Button
	exitButton = [[ButtonControl alloc] initAsButtonImageNamed:@"CloseTab" selectionImage:YES atPosition:CGPointMake(291, 35)];
	[exitButton setTarget:self andAction:@selector(close)];
	// Scroll Buttons
	nextScrollButton = [[ButtonControl alloc] initAsButtonImageNamed:@"ScrollNextButton" selectionImage:NO atPosition:CGPointMake(290, 330)];
	[nextScrollButton setTarget:self andAction:@selector(showNextItem)];
	CGRect newSize = [nextScrollButton boundingBox];
	newSize.size = CGSizeMake(60, 180);
	nextScrollButton.boundingBox = newSize;
	
	previousScrollButton = [[ButtonControl alloc] initAsButtonImageNamed:@"ScrollPreviousButton" selectionImage:NO atPosition:CGPointMake(30, 330)];
	[previousScrollButton setTarget:self andAction:@selector(showPreviousItem)];
	newSize = [previousScrollButton boundingBox];
	newSize.size = CGSizeMake(60, 180);
	previousScrollButton.boundingBox = newSize;
	
	// Lock Image
	lockImage = [[Image alloc] initWithImageNamed:@"Lock"];
	[lockImage setPosition:CGPointMake(160, 215)];
	// Image Background
	backgroundImage = [[Image alloc] initWithImageNamed:@"BrowseItemBackground"];
	[backgroundImage setPosition:CGPointMake(160, 330)];
	// Unlock/Select Button
	selectionButton = [[ButtonControl alloc] initAsButtonImageNamed:@"UnlockButton" selectionImage:YES atPosition:CGPointMake(225, 215)];
	[selectionButton setTarget:self andAction:@selector(purchaseItem)];
	
	// Item Cost Indicator
	//indicatorCosts = [[CurrencyIndicator alloc] initAtPosition:CGPointMake(100, 215) asType:0];
	// Holds the selected item UID
	selectedItemIndex = 0;
	
	selectedCategory = 0;
	categoryItems = [[NSMutableArray alloc] initWithCapacity:1];
	
	[self switchCategoryToStage];
	
	[super startLoadScene];
}

- (void)transitioningToCurrentScene
{
	[self startLoadScene];
}

- (void) purchaseItem
{
	if([categoryItems count] == 0)
		return;
	
	if([sharedSettingManager purchased:[[categoryItems objectAtIndex:selectedItemIndex] intValue]])
	{
		// Attempting to equip Item
		[sharedSettingManager equipItem:[[categoryItems objectAtIndex:selectedItemIndex] intValue]];
	}
	else
	{
		// Attempting to purchase Item
		if([sharedSettingManager purchaseItem:[[categoryItems objectAtIndex:selectedItemIndex] intValue]])
		{
			// Attempting to equip item if purchase was successful
			[sharedSettingManager equipItem:[[categoryItems objectAtIndex:selectedItemIndex] intValue]];
		}
	}
	
	// Make any updates if needed
	[self updateSelectedItem];
}

- (void) showNextItem
{
	if([categoryItems count] == 0)
		return;
	
	// Increases the selected item index by 1, loops if needed
	selectedItemIndex++;
	if (selectedItemIndex > [categoryItems count] - 1) 
		selectedItemIndex = 0;
	
	[self updateSelectedItem];
}
- (void) showPreviousItem
{
	if([categoryItems count] == 0)
		return;
	
	// Decreases the selected item index by 1, loops if needed
	selectedItemIndex--;
	if (selectedItemIndex < 0) 
		selectedItemIndex = [categoryItems count] - 1;
	
	[self updateSelectedItem];
}	

- (void) close
{
	// Switch to Stage Scene
	[[Director sharedDirector] setCurrentSceneToSceneWithKey:SCENEKEY_MENU];
}

- (void) deselectAllTabs
{
	[stageTabButton setSelected:NO];
	[gameTabButton setSelected:NO];
	[treatTabButton setSelected:NO];
	[pointTabButton setSelected:NO];
	
	[stageMiniTabButton setSelected:NO];
	[itemMiniTabButton setSelected:NO];
	[overlayMiniTabButton setSelected:NO];
}

- (void) switchCategoryToStage
{
	[self deselectAllTabs];
	[stageTabButton setSelected:YES];
	[stageMiniTabButton setSelected:YES];
	[self displayItemsOfType:ItemType_Background];
}

- (void) switchCategoryToItem
{
	[self deselectAllTabs];
	[stageTabButton setSelected:YES];
	[itemMiniTabButton setSelected:YES];
	[self displayItemsOfType:ItemType_Foreground];
}

- (void) switchCategoryToOverlay
{
	[self deselectAllTabs];
	[stageTabButton setSelected:YES];
	[overlayMiniTabButton setSelected:YES];
	[self displayItemsOfType:ItemType_Overlay];
}

- (void) switchCategoryToGame
{
	[self deselectAllTabs];
	[gameTabButton setSelected:YES];
	[self displayItemsOfType:ItemType_Minigame];
}

- (void) switchCategoryToTreat
{
	[self deselectAllTabs];
	[treatTabButton setSelected:YES];
	[self displayItemsOfType:ItemType_Treat];
}

- (void) switchCategoryToPoint
{
	[self deselectAllTabs];
	[pointTabButton setSelected:YES];
	[self displayItemsOfType:ItemType_Currency];
}

- (void) displayItemsOfType:(uint)type
{
	[categoryItems removeAllObjects];
	[categoryItems addObjectsFromArray:[sharedSettingManager getItemsInBin:ItemBin_All ofType:type]];
	NSLog(@"# of Items: %D", [categoryItems count]);
	selectedItemIndex = 0;
	[self updateSelectedItem];
}

- (void) adjustIndicatorCost
{
	//[indicatorCosts enable];
	
	if([categoryItems count] == 0)
	{
		//[indicatorCosts setType:0];
		//[indicatorCosts setValue:9999];
		return;
	}
	
	// Adjust the indicator costs to match the current selected UID
	int cost;
	cost = [[sharedSettingManager get:ItemKey_PCost withUID:[[categoryItems objectAtIndex:selectedItemIndex] intValue]] intValue];
	if(cost > 0)
	{
		//[indicatorCosts setValue:cost];
		//[indicatorCosts setType:0];
	}
	else 
	{
		cost = [[sharedSettingManager get:ItemKey_TCost withUID:[[categoryItems objectAtIndex:selectedItemIndex] intValue]] intValue];
		//[indicatorCosts setValue:cost];
		//[indicatorCosts setType:1];
	}
}

- (void) updateSelectedItem
{
	if([categoryItems count] == 0)
	{
		[backgroundImage release];
		backgroundImage = [[Image alloc] initWithImageNamed:@"BrowseItemBackground"];
		//[backgroundImage setScale:1.0];
		[backgroundImage setPosition:CGPointMake(160, 330)];
		
		[selectionButton setButtonImage:@"UnlockButton" withSelectionImage:YES]; 
		[selectionButton setEnabled:YES];
		
		CGRect newBox = [selectionButton boundingBox];
		newBox.origin.x = 225;
		[selectionButton setBoundingBox:newBox];
		
		[self adjustIndicatorCost];
	}
	else
	{
		int uid = [[categoryItems objectAtIndex:selectedItemIndex] intValue];
		
		[backgroundImage release];
		
		backgroundImage = [[Image alloc] initWithImageNamed:[NSString stringWithFormat:@"%@Preview", [sharedSettingManager get:ItemKey_Image withUID:uid]]];
		//[backgroundImage setScale:0.40];
		[backgroundImage setPosition:CGPointMake(160, 330)];
		
		BOOL purchased = [sharedSettingManager purchased:uid];
		
		if (purchased)
		{
			//[indicatorCosts disable];
			
			CGRect newBox = [selectionButton boundingBox];
			newBox.origin.x = 160;
			[selectionButton setBoundingBox:newBox];
			
			BOOL equippable = [sharedSettingManager equippable:uid];
			if(equippable)
			{
				BOOL equipped = [sharedSettingManager equipped:uid];
				
				if(equipped)
				{
					[selectionButton setButtonImage:@"CurrentSelectionImage" withSelectionImage:NO]; 
					[selectionButton setEnabled:NO];
				}
				else
				{
					[selectionButton setButtonImage:@"SelectButton" withSelectionImage:YES]; 
					[selectionButton setEnabled:YES];
				}
			}
			else 
			{
				[selectionButton setButtonImage:@"AlreadyPurchasedImage" withSelectionImage:NO]; 
				[selectionButton setEnabled:NO];
			}	
		}
		else
		{
			[selectionButton setButtonImage:@"UnlockButton" withSelectionImage:YES]; 
			[selectionButton setEnabled:YES];
			
			CGRect newBox = [selectionButton boundingBox];
			newBox.origin.x = 225;
			[selectionButton setBoundingBox:newBox];
			[self adjustIndicatorCost];
		}	
	}
}

- (void)updateWithDelta:(GLfloat)aDelta 
{
	[super updateWithDelta:aDelta];
	switch (sceneState) 
	{
			// The Scene is in the forefront and running.
		case SceneState_Running:
		{
			// Indicators
			[indicatorUserPoints updateWithDelta:aDelta];
			[indicatorUserTreats updateWithDelta:aDelta];
			[indicatorCosts updateWithDelta:aDelta];
			// Updates Tab Bar
			[stageTabButton updateWithDelta:aDelta];
			[gameTabButton updateWithDelta:aDelta];
			[treatTabButton updateWithDelta:aDelta];
			[pointTabButton updateWithDelta:aDelta];
			[stageMiniTabButton updateWithDelta:aDelta];
			[itemMiniTabButton updateWithDelta:aDelta];
			[overlayMiniTabButton updateWithDelta:aDelta];
			[exitButton updateWithDelta:aDelta];
			[selectionButton updateWithDelta:aDelta];
			// Scroll Buttons
			[nextScrollButton updateWithDelta:aDelta];
			[previousScrollButton updateWithDelta:aDelta];
			break;
		}
			// The scene is phasing out.
		case SceneState_TransitionOut:
		{
			break;
		}
			// The scene is phasing in.
		case SceneState_TransitionIn:
		{
			break;
		}
		default:
		{
			NSLog(@"ERROR: BrowseScene has no valid state.");
			break;
		}
	}
}

- (void)updateWithTouchLocationBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView 
{
	[super updateWithTouchLocationBegan:touches withEvent:event view:aView];
	switch (sceneState) 
	{
			// The Scene is in the forefront and running.
		case SceneState_Running:
		{
			// Scroll Buttons
			[nextScrollButton touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
			[previousScrollButton touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
			// Updates Tab Bar
			[stageTabButton touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
			[gameTabButton touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
			[treatTabButton touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
			[pointTabButton touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
			[stageMiniTabButton touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
			[itemMiniTabButton touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
			[overlayMiniTabButton touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
			[exitButton touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
			[selectionButton touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
			break;
		}
			// The scene is phasing out.
		case SceneState_TransitionOut:
		{
			break;
		}
			// The scene is phasing in.
		case SceneState_TransitionIn:
		{
			break;
		}
		default:
		{
			NSLog(@"ERROR: BrowseScene has no valid state.");
			break;
		}
	}
}

- (void)updateWithTouchLocationMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView 
{
	[super updateWithTouchLocationMoved:touches withEvent:event view:aView];
	switch (sceneState) 
	{
			// The Scene is in the forefront and running.
		case SceneState_Running:
		{
			// Scroll Buttons
			[nextScrollButton touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			[previousScrollButton touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			// Updates Tab Bar
			[stageTabButton touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			[gameTabButton touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			[treatTabButton touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			[pointTabButton touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			[stageMiniTabButton touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			[itemMiniTabButton touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			[overlayMiniTabButton touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			[exitButton touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			[selectionButton touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			break;
		}
			// The scene is phasing out.
		case SceneState_TransitionOut:
		{
			break;
		}
			// The scene is phasing in.
		case SceneState_TransitionIn:
		{
			break;
		}
		default:
		{
			NSLog(@"ERROR: BrowseScene has no valid state.");
			break;
		}
	}
}

- (void)updateWithTouchLocationEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView 
{
	[super updateWithTouchLocationEnded:touches withEvent:event view:aView];
	switch (sceneState) 
	{
			// The Scene is in the forefront and running.
		case SceneState_Running:
		{
			// Scroll Buttons
			[nextScrollButton touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			[previousScrollButton touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			if([nextScrollButton activated] || [previousScrollButton activated])
				break;
			// Updates Tab Bar
			[stageTabButton touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			[gameTabButton touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			[treatTabButton touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			[pointTabButton touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			[stageMiniTabButton touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			[itemMiniTabButton touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			[overlayMiniTabButton touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			[exitButton touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			[selectionButton touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			break;
		}
			// The scene is phasing out.
		case SceneState_TransitionOut:
		{
			break;
		}
			// The scene is phasing in.
		case SceneState_TransitionIn:
		{
			break;
		}
		default:
		{
			NSLog(@"ERROR: BrowseScene has no valid state.");
			break;
		}
	}
}

- (void)updateWithAccelerometer:(UIAcceleration*)aAcceleration 
{
	
}

- (void)transitionToSceneWithKey:(NSString*)aKey 
{
	
}

- (void)render 
{
	glPushMatrix();
	[sceneHeaderImage render];
	[sceneDescriptionImage render];
	[backgroundImage render];
	// Draw the currently selected item; scale by 0.40

	//if ([indicatorCosts isEnabled]) 
	//{
	//	[lockImage render];
	//	[indicatorCosts render];
	//}
	[indicatorUserPoints render];
	[indicatorUserTreats render];
			
	// Scroll Buttons
	
	if ([categoryItems count] > 1)
	{
		[nextScrollButton render];
		[previousScrollButton render];
	}
	// Updates Tab Bar
	[stageTabButton render];
	[gameTabButton render];
	[treatTabButton render];
	[pointTabButton render];
	if([stageTabButton selected])
	{
		[stageMiniTabButton render];
		[itemMiniTabButton render];
		[overlayMiniTabButton render];
	}
	[exitButton render];
	[selectionButton render];
	glPopMatrix();
	[font drawStringAt:CGPointMake(5, 450) text:[NSString stringWithFormat:@"FPS: %1.0f", [[Director sharedDirector] framesPerSecond]]];
}

@end
