//
//  BrowseScene.h
//  Pet
//
//  Created by Dustin Atwood on 9/20/10.
//  Copyright 2010 Dustin Atwood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractScene.h"
#import "Common.h"
#import "AngelCodeFont.h"
#import "CurrencyIndicator.h"
#import "ButtonControl.h"
#import "Image.h"

@interface BrowseScene : AbstractScene 
{
	// Main Browsing Elements
	// Font Drawing
	AngelCodeFont* font;
	// The Scene Header Image
	Image* sceneHeaderImage;
	// Scene Description Image
	Image* sceneDescriptionImage;
	// User Point Display
	CurrencyIndicator* indicatorUserPoints;
	// User Treat Display
	CurrencyIndicator* indicatorUserTreats;
	
	// Tab Bar Buttons
	ButtonControl* stageTabButton;
	ButtonControl* gameTabButton;
	ButtonControl* treatTabButton;
	ButtonControl* pointTabButton;
	// Sub Tab Bar Buttons
	ButtonControl* stageMiniTabButton;
	ButtonControl* itemMiniTabButton;
	ButtonControl* overlayMiniTabButton;
	// Close Scene Button
	ButtonControl* exitButton;
	
	// Scroll Buttons
	ButtonControl* nextScrollButton;
	ButtonControl* previousScrollButton;
	
	// Lock Image
	Image* lockImage;
	// Image Background
	Image* backgroundImage;
	// Unlock/Select Button
	ButtonControl* selectionButton;
	// Item Cost Indicator
	CurrencyIndicator* indicatorCosts;
	
	// Holds the selected item index of category
	int selectedItemIndex;
	
	// Selected Category
	int selectedCategory;
	
	// An Array of UIDs for the current category;
	NSMutableArray* categoryItems;
}

- (void) purchaseItem;

- (void) showNextItem;

- (void) showPreviousItem;

- (void) close;

- (void) deselectAllTabs;

- (void) switchCategoryToStage;

- (void) switchCategoryToItem;

- (void) switchCategoryToOverlay;

- (void) switchCategoryToGame;

- (void) switchCategoryToTreat;

- (void) switchCategoryToPoint;

- (void) adjustIndicatorCost;

- (void) updateSelectedItem;

- (void) displayItemsOfType:(uint)type;

@end
