//
//  StylizeScene.h
//  BadBadMonkey
//
//  Created by Dustin Atwood on 9/20/10.
//  Copyright 2010 Litlapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractScene.h"
#import "Indicator.h"
#import "IndicatorPlayer.h"
#import "AngelCodeFont.h"
#import "Common.h"
#import "ButtonControl.h"
#import "Image.h"
#import "PetActor.h"
#import "LabelControl.h"
#import "SliderControl.h"

@interface StylizeScene : AbstractScene
{
	Indicator* coinIndicatorCost;
	IndicatorPlayer* indicatorPlayer;
	
	NSString* colorString;
	NSString* customColorString;
	
	// Button Accept/Back
	//ButtonControl* buttonBack;
	//ButtonControl* buttonApply;
	
	// Button Icons
	//NSMutableArray* buttonIcons;
	
	// Button Icons
	//ButtonControl* buttonTopLeft;
	//ButtonControl* buttonMidLeft;
	//ButtonControl* buttonBottomLeft;
	//ButtonControl* buttonTopRight;
	//ButtonControl* buttonMidRight;
	//ButtonControl* buttonBottomRight;
	
	SliderControl* sliderRedColor;
	LabelControl* labelRedSlider;
	SliderControl* sliderGreenColor;
	LabelControl* labelGreenSlider;
	SliderControl* sliderBlueColor;
	LabelControl* labelBlueSlider;
	// Tab1 Control
	AbstractControl* buttonTabOne;
	Image* imageTabOne;
	LabelControl* labelFeatures;
	
	// Tab2 Control
	AbstractControl* buttonTabTwo;
	Image* imageTabTwo;
	LabelControl* labelColor;
	
	Image* imageBackgroundPet;
	
	PetActor* previewPet;
	
	// An Array of all available Items; An Array that is broken into parts for each category.
	NSArray* allItems;
	// An Array of items that are currently being previewed.
	NSMutableArray* previewItems;
	int selectedItemIndex;
	int selectedCategoryIndex;
	
	BOOL tutorialOn;
}

//
// -- Basic Functions
// 
// Attempts to purchase all previewed Items and the saves them as equipped
- (void) save;
// Loads the menu
- (void) loadMenuScene;

//
// -- Setting Up Different Tab Types
// 
// Show Color Tab
- (void) showColorTab;
// Show Custom Color Tab
- (void) showCustomColorTab;
// Show Feature Type Tab
- (void) showFeatureTypeTab;
// Show Feature Picker Tab
- (void) showFeaturePickerTab;

//
// -- Executing Buttons
// 
// Set To Red Color
- (void) setColorToRed;
// Set To Blue Color
- (void) setColorToBlue;
// Set To Yellow Color
- (void) setColorToYellow;
// Set To Purple Color
- (void) setColorToPurple;
// Set To Green Color
- (void) setColorToGreen;
// Set To Custom Color
- (void) setColorToCustom;
// Set Visible Feature for Selected Category
- (void) setVisibleFeatureForSelectedCategory;

// Set Visible Feature Antenna
- (void) setVisibleFeatureAntenna;
// Set Visible Feature Eyes
- (void) setVisibleFeatureEyes;
// Set Visible Feature Body Type
- (void) setVisibleFeatureBodyType;
// Set Feature to top left icon 
- (void) setFeatureToTopLeftIcon;
// Set Feature to top mid icon 
- (void) setFeatureToTopMidIcon;
// Set Feature to top right icon 
- (void) setFeatureToTopRightIcon;
// Set Feature to bottom left icon 
- (void) setFeatureToBottomLeftIcon;
// Set Feature to bottom mid icon 
- (void) setFeatureToBottomMidIcon;
// Set Feature to bottom right icon 
- (void) setFeatureToBottomRightIcon;

//
// -- Internal Functions
// 
// Sets the Custom Sliders based on color string
- (void) adjustSlidersToString:(NSString*)cStr;
// Update Preview Pet
- (void) updatePet;

@end
