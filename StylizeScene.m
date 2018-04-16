//
//  StylizeScene.m
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 9/20/10.
//  Copyright 2010 Dustin Atwood. All rights reserved.
//

#define buttonBackX 60
#define buttonBackY 449
#define buttonApplyX 220
#define buttonApplyY 205
#define buttonSelCatX 160
#define buttonSelCatY 140
#define buttonPreCatX 60
#define buttonPreCatY 140
#define buttonNexCatX 260
#define buttonNexCatY 140
#define buttonSelItmX 160
#define buttonSelItmY 60
#define buttonPreItmX 60
#define buttonPreItmY 60
#define buttonNexItmX 260
#define buttonNexItmY 60
#define indicatorUserCurrencyX 222.5
#define indicatorUserCurrencyY 449
#define indicatorCostCurrencyX 100
#define indicatorCostCurrencyY 205
#define imagePreviewPetBackgroundX 160
#define imagePreviewPetBackgroundY 320

#import "StylizeScene.h"

@implementation StylizeScene

- (id) init
{
	self = [super init];
	if (self != nil) 
	{
		NSLog(@"Stylize Scene Initializing...");
		
	}
	return self;
}

- (void) startLoadScene
{
	NSLog(@"Stylize Scene Loading...");
	font = [[AngelCodeFont alloc] initWithFontImageNamed:FONT16 controlFile:FONT16 scale:1.0f filter:GL_LINEAR];
	
	coinIndicatorUser = [[Indicator alloc] initAtScreenPercentage:CGPointMake(71.5625, 96) withSize:2 
														 currencyType:CurrencyType_Coin leftsideIcon:YES];
	treatIndicator = [[Indicator alloc] initAtScreenPercentage:CGPointMake(89.84375, 87.8125) withSize:0 
													 currencyType:CurrencyType_Treat leftsideIcon:NO];
	coinIndicatorCost = [[Indicator alloc] initAtScreenPercentage:CGPointMake(50, 45.20) withSize:1 
													 currencyType:CurrencyType_Coin leftsideIcon:YES];						 
	
	// Setting Up Basic buttons
	buttonBack = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonSmall" withText:@"Back" selectionImage:NO 
													atPosition:CGPointMake(buttonBackX, buttonBackY)];
	[buttonBack setTarget:self andAction:@selector(loadMenu)];
	[buttonBack setButtonColourFilterRed:1.0 green:0.0 blue:0.0 alpha:1.0];
	buttonApply = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonSmall" withText:@"OK" selectionImage:NO
													 atPosition:CGPointMake(276.25, 250)];
	[buttonApply setTarget:self andAction:@selector(save)];
	[buttonApply setButtonColourFilterRed:0.0 green:1.0 blue:0.0 alpha:1.0];
	
	// Setting Up Icon Buttons
	// Top Left Icon
	buttonIcons = [[NSMutableArray alloc] initWithCapacity:1];
	ButtonControl* buttonIcon;
	buttonIcon = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonSmall" 
															 withText:@"" 
												   atScreenPercentage:CGPointMake(20, 23) 
															isRotated:NO];
	[buttonIcon setTarget:self andAction:@selector(setFeatureToTopLeftIcon)];
	[buttonIcons addObject:buttonIcon];
	[buttonIcon release];
	
	// Top Mid Icon
	buttonIcon = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonSmall" 
															 withText:@"" 
												   atScreenPercentage:CGPointMake(50, 23) 
															isRotated:NO];
	[buttonIcon setTarget:self andAction:@selector(setFeatureToTopMidIcon)];
	[buttonIcons addObject:buttonIcon];
	[buttonIcon release];
	// Top Right Icon
	buttonIcon = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonSmall" 
															 withText:@"" 
												   atScreenPercentage:CGPointMake(80, 23) 
															isRotated:NO];
	[buttonIcon setTarget:self andAction:@selector(setFeatureToTopRightIcon)];
	[buttonIcons addObject:buttonIcon];
	[buttonIcon release];
	// Bottom Left Icon
	buttonIcon = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonSmall" 
															 withText:@"" 
												   atScreenPercentage:CGPointMake(20, 8) 
															isRotated:NO];
	[buttonIcon setTarget:self andAction:@selector(setFeatureToBottomLeftIcon)];
	[buttonIcons addObject:buttonIcon];
	[buttonIcon release];
	// Bottom Mid Icon
	buttonIcon = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonSmall" 
															withText:@"" 
												  atScreenPercentage:CGPointMake(50, 8) 
														   isRotated:NO];
	[buttonIcon setTarget:self andAction:@selector(setFeatureToBottomMidIcon)];
	[buttonIcons addObject:buttonIcon];
	[buttonIcon release];
	// Bottom Right Icon
	buttonIcon = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonSmall" 
															  withText:@"Done" 
													atScreenPercentage:CGPointMake(80, 8) 
															 isRotated:NO];
	[buttonIcon setTarget:self andAction:@selector(showFeatureTypeTab)];
	[buttonIcon setButtonColourFilterRed:1.0 green:0.0 blue:0.0 alpha:1.0];
	[buttonIcons addObject:buttonIcon];
	[buttonIcon release];
	
	// Setting up Large Buttons
	buttonTopLeft = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonExtended"  withText:@"" selectionImage:NO 
														atPosition:CGPointMake(83.5, 130)];
	buttonMidLeft = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonExtended"  withText:@"" selectionImage:NO 
														atPosition:CGPointMake(83.5, 80)];
	buttonBottomLeft = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonExtended"  withText:@"" selectionImage:NO 
														atPosition:CGPointMake(83.5, 30)];
	buttonTopRight = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonExtended"  withText:@"" selectionImage:NO 
														   atPosition:CGPointMake(236, 130)];
	buttonMidRight = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonExtended"  withText:@"" selectionImage:NO 
														   atPosition:CGPointMake(236, 80)];
	buttonBottomRight = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonExtended" withText:@"" selectionImage:NO
														   atPosition:CGPointMake(236, 30)];
	// Setting up Tabs
	buttonTabOne = [[AbstractControl alloc] initWithCGRect:CGRectMake(80, 175, 160, 34)];
	[buttonTabOne setSticky:YES];
	[buttonTabOne setLocked:YES];
	imageTabOne = [[Image alloc] initWithImageNamed:@"imageStylizeTab1"];
	[imageTabOne setPosition:CGPointMake(160, 97)];
	buttonTabTwo = [[AbstractControl alloc] initWithCGRect:CGRectMake(240, 175, 160, 34)];
	[buttonTabTwo setSticky:YES];
	[buttonTabTwo setLocked:YES];
	imageTabTwo = [[Image alloc] initWithImageNamed:@"imageStylizeTab2"];
	[imageTabTwo setPosition:CGPointMake(160, 97)];
	
	sliderRedColor = [[SliderControl alloc] initAtPosition:CGPointMake(184.5, 88)];
	[sliderRedColor setTarget:self andAction:@selector(setColorToCustom)];
	labelRedSlider = [[LabelControl alloc] initWithFontName:FONT16];
	[labelRedSlider setText:@"Red" atSceenPercentage:CGPointMake(10, 18.33)];
	
	sliderGreenColor = [[SliderControl alloc] initAtPosition:CGPointMake(184.5, 52.5)];
	[sliderGreenColor setTarget:self andAction:@selector(setColorToCustom)];
	labelGreenSlider = [[LabelControl alloc] initWithFontName:FONT16];
	[labelGreenSlider setText:@"Green" atSceenPercentage:CGPointMake(10, 10.9375)];
	
	sliderBlueColor = [[SliderControl alloc] initAtPosition:CGPointMake(184.5, 17)];
	[sliderBlueColor setTarget:self andAction:@selector(setColorToCustom)];
	labelBlueSlider = [[LabelControl alloc] initWithFontName:FONT16];
	[labelBlueSlider setText:@"Blue" atSceenPercentage:CGPointMake(10, 3.54)];
	
	imagePreviewPetBackground = [[Image alloc] initWithImageNamed:@"imageBackgroundPet"];
	[imagePreviewPetBackground setPosition:CGPointMake(imagePreviewPetBackgroundX, imagePreviewPetBackgroundY)];
	imageBackground = [[Image alloc] initWithImageNamed:@"imageBackground"];
	[imageBackground setPosition:CGPointMake(160, 240)];
	
	labelFeatures = [[LabelControl alloc] initWithFontName:FONT21];
	[labelFeatures setText:@"Features" atSceenPercentage:CGPointMake(29, 37)];
	labelColor = [[LabelControl alloc] initWithFontName:FONT21];
	[labelColor setText:@"Color" atSceenPercentage:CGPointMake(71, 37)];
	
	// Gets all items for the pet slots.
	allItems = [[NSArray alloc] initWithObjects:
				[sharedSettingManager getItemsInBin:ItemBin_All ofType:ItemType_Topper],
				[sharedSettingManager getItemsInBin:ItemBin_All ofType:ItemType_Eyes],
				[sharedSettingManager getItemsInBin:ItemBin_All ofType:ItemType_Body_Pattern],
				[sharedSettingManager getItemsInBin:ItemBin_All ofType:ItemType_Body_Type],
				nil];
	
	previewItems = [[NSMutableArray alloc] initWithObjects:
					[[allItems objectAtIndex:ItemType_Topper] objectAtIndex:0],
					[[allItems objectAtIndex:ItemType_Eyes] objectAtIndex:0],
					nil];
	
	selectedCategoryIndex = 0;
	selectedItemIndex = 0;
	
	previewPet = [[PetActor alloc] initWithState:0];
	
	[previewPet adjustScale:0.5f];
	
	[self finishLoadScene];
}

- (void) finishLoadScene
{
	NSLog(@"Finish Loading...");
	
	[self setIsInitialized:TRUE];
	[self transitioningToCurrentScene];
	[[Director sharedDirector] stopLoading];
}

- (void)transitioningToCurrentScene
{
	if(!isInitialized)
	{
		[[Director sharedDirector] startLoading];
		//[self startLoadScene];
		[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(startLoadScene) userInfo:nil repeats:NO];
		//[self performSelectorOnMainThread:@selector(startLoadScene) withObject:nil waitUntilDone:NO];
	}
	[coinIndicatorUser changeInitialValue:[[sharedSettingManager forProfileGet:ProfileKey_Coins]intValue]];
	[treatIndicator changeInitialValue:[[sharedSettingManager forProfileGet:ProfileKey_Treats]intValue]];
	
	colorString = [[NSString stringWithString:[sharedSettingManager forProfileGet:ProfileKey_Pet_Color]] retain];
	[previewItems replaceObjectAtIndex:ItemType_Topper withObject:
	 [[SettingManager sharedSettingManager] forProfileGet:Profilekey_Pet_Antenna]];
	[previewItems replaceObjectAtIndex:ItemType_Eyes withObject:
	 [[SettingManager sharedSettingManager] forProfileGet:ProfileKey_Pet_Eyes]];
	
	[previewPet adjustImagesWithUID:previewItems andColor:colorString];
	[coinIndicatorCost changeInitialValue:0];
	[self showFeatureTypeTab];
}

// Attempts to purchase all previewed Items and the saves them as equipped
- (void) save
{
	if([[SettingManager sharedSettingManager] modifyCoinsBy:-[coinIndicatorCost returnTotalPoints]])
	{
		[sharedSettingManager forProfileSet:Profilekey_Pet_Antenna to:[previewItems objectAtIndex:ItemType_Topper]];
		[sharedSettingManager forProfileSet:ProfileKey_Pet_Eyes to:[previewItems objectAtIndex:ItemType_Eyes]];
		[sharedSettingManager forProfileSet:ProfileKey_Pet_Color to:colorString];
		[coinIndicatorCost changeInitialValue:0];
		[self loadMenu];
	}
}

//
// -- Setting Up Different Tab Types
// 
// Show Feature Type Tab
- (void) showFeatureTypeTab
{
	// Show 1st Tab
	[buttonTabOne setSelected:TRUE];
	//[buttonTabOne setEnabled:TRUE];
	[buttonTabTwo setSelected:FALSE];
	//[buttonTabTwo setEnabled:FALSE];
	// Hide all Icon Buttons
	for (ButtonControl* iconButton in buttonIcons) 
	{
		[iconButton setEnabled:FALSE];
	}

	// Hide Color Picker
	[sliderRedColor setEnabled:FALSE];
	[labelRedSlider setEnabled:FALSE];
	[sliderGreenColor setEnabled:FALSE];
	[labelGreenSlider setEnabled:FALSE];
	[sliderBlueColor setEnabled:FALSE];
	[labelBlueSlider setEnabled:FALSE];
	// Adjust Large Buttons
	[buttonTopLeft setEnabled:TRUE];
	[buttonTopLeft setText:@"Antenna"];
	[buttonTopLeft setTarget:self andAction:@selector(setVisibleFeatureAntenna)];
	[buttonTopLeft setButtonColourFilterRed:1.0 green:0.8 blue:0.2 alpha:1.0];
	[buttonMidLeft setEnabled:FALSE];
	[buttonBottomLeft setEnabled:TRUE];
	[buttonBottomLeft setText:@"Body Type"];
	[buttonBottomLeft setTarget:self andAction:@selector(setVisibleFeatureBodyType)];
	[buttonBottomLeft setButtonColourFilterRed:1.0 green:0.8 blue:0.2 alpha:1.0];
	[buttonTopRight setEnabled:TRUE];
	[buttonTopRight setText:@"Eyes"];
	[buttonTopRight setTarget:self andAction:@selector(setVisibleFeatureEyes)];
	[buttonTopRight setButtonColourFilterRed:1.0 green:0.8 blue:0.2 alpha:1.0];
	[buttonMidRight setEnabled:FALSE];
	[buttonBottomRight setEnabled:TRUE];
	[buttonBottomRight setText:@"Pattern"];
	[buttonBottomRight setTarget:self andAction:@selector(setVisibleFeaturePattern)];
	[buttonBottomRight setButtonColourFilterRed:1.0 green:0.8 blue:0.2 alpha:1.0];
}
// Show Feature Picker Tab
- (void) showFeaturePickerTab
{
	// Show 1st Tab
	[buttonTabOne setSelected:TRUE];
	//[buttonTabOne setEnabled:TRUE];
	[buttonTabTwo setSelected:FALSE];
	//[buttonTabTwo setEnabled:FALSE];
	// Hide all Icon Buttons
	for (ButtonControl* iconButton in buttonIcons) 
	{
		[iconButton setEnabled:FALSE];
	}
	[[buttonIcons objectAtIndex:5] setEnabled:TRUE];
	// Hide Color Picker
	[sliderRedColor setEnabled:FALSE];
	[labelRedSlider setEnabled:FALSE];
	[sliderGreenColor setEnabled:FALSE];
	[labelGreenSlider setEnabled:FALSE];
	[sliderBlueColor setEnabled:FALSE];
	[labelBlueSlider setEnabled:FALSE];
	// Adjust Large Buttons
	[buttonTopLeft setEnabled:FALSE];
	[buttonMidLeft setEnabled:FALSE];
	[buttonBottomLeft setEnabled:FALSE];
	[buttonTopRight setEnabled:FALSE];
	[buttonMidRight setEnabled:FALSE];
	[buttonBottomRight setEnabled:FALSE];
}
// Show Color Tab
- (void) showColorTab
{
	// Show 1st Tab
	[buttonTabOne setSelected:FALSE];
	//[buttonTabOne setEnabled:FALSE];
	[buttonTabTwo setSelected:TRUE];
	//[buttonTabTwo setEnabled:TRUE];
	// Hide all Icon Buttons
	for (ButtonControl* iconButton in buttonIcons) 
	{
		[iconButton setEnabled:FALSE];
	}
	// Hide Color Picker
	[sliderRedColor setEnabled:FALSE];
	[labelRedSlider setEnabled:FALSE];
	[sliderGreenColor setEnabled:FALSE];
	[labelGreenSlider setEnabled:FALSE];
	[sliderBlueColor setEnabled:FALSE];
	[labelBlueSlider setEnabled:FALSE];
	// Adjust Large Buttons
	[buttonTopLeft setEnabled:TRUE];
	[buttonTopLeft setText:@"Red"];
	[buttonTopLeft setTarget:self andAction:@selector(setColorToRed)];
	[buttonTopLeft setButtonColourFilterRed:1.0 green:0.0 blue:0.0 alpha:1.0];
	[buttonMidLeft setEnabled:FALSE];
	[buttonMidLeft setText:@"Blue"];
	[buttonMidLeft setTarget:self andAction:@selector(setColorToBlue)];
	[buttonMidLeft setButtonColourFilterRed:0.0 green:0.68 blue:0.94 alpha:1.0];
	[buttonBottomLeft setEnabled:TRUE];
	[buttonBottomLeft setText:@"Yellow"];
	[buttonBottomLeft setTarget:self andAction:@selector(setColorToYellow)];
	[buttonBottomLeft setButtonColourFilterRed:1.0 green:0.95 blue:0.0 alpha:1.0];
	[buttonTopRight setEnabled:TRUE];
	[buttonTopRight setText:@"Purple"];
	[buttonTopRight setTarget:self andAction:@selector(setColorToPurple)];
	[buttonTopRight setButtonColourFilterRed:0.93 green:0.16 blue:0.48 alpha:1.0];
	[buttonMidRight setEnabled:FALSE];
	[buttonMidRight setText:@"Green"];
	[buttonMidRight setTarget:self andAction:@selector(setColorToGreen)];
	[buttonMidRight setButtonColourFilterRed:0.0 green:0.65 blue:0.32 alpha:1.0];
	[buttonBottomRight setEnabled:TRUE];
	[buttonBottomRight setText:@"Custom"];
	[buttonBottomRight setTarget:self andAction:@selector(showCustomColorTab)];
	[buttonBottomRight setButtonColourWithString:colorString];
}
// Show Custom Color Tab
- (void) showCustomColorTab
{
	// Show 1st Tab
	[buttonTabOne setSelected:FALSE];
	//[buttonTabOne setEnabled:FALSE];
	[buttonTabTwo setSelected:TRUE];
	//[buttonTabTwo setEnabled:TRUE];
	// Hide all Icon Buttons
	for (ButtonControl* iconButton in buttonIcons) 
	{
		[iconButton setEnabled:FALSE];
	}

	// Show Color Picker
	[sliderRedColor setEnabled:TRUE];
	[labelRedSlider setEnabled:TRUE];
	[sliderGreenColor setEnabled:TRUE];
	[labelGreenSlider setEnabled:TRUE];
	[sliderBlueColor setEnabled:TRUE];
	[labelBlueSlider setEnabled:TRUE];
	// Set the sliders to current Color
	[self adjustSlidersToString:colorString];
	// Hide Large Buttons
	[buttonTopLeft setEnabled:TRUE];
	[buttonTopLeft setText:@"Done"];
	[buttonTopLeft setTarget:self andAction:@selector(showColorTab)];
	[buttonTopLeft setButtonColourFilterRed:1.0 green:0.0 blue:0.0 alpha:1.0];
	[buttonMidLeft setEnabled:FALSE];
	[buttonBottomLeft setEnabled:FALSE];
	[buttonTopRight setEnabled:FALSE];
	[buttonMidRight setEnabled:FALSE];
	[buttonBottomRight setEnabled:FALSE];
}

//
// -- Executing Buttons
// 
// Set To Red Color
- (void) setColorToRed
{
	colorString = @"{1.0, 0.0, 0.0}";
	[buttonBottomRight setButtonColourWithString:colorString];
	[self updatePet];
}
// Set To Blue Color
- (void) setColorToBlue
{
	colorString = @"{0.0, 0.68, 0.94}";
	[buttonBottomRight setButtonColourWithString:colorString];
	[self updatePet];
}
// Set To Yellow Color
- (void) setColorToYellow
{
	colorString = @"{1.0, 0.95, 0.0}";
	[buttonBottomRight setButtonColourWithString:colorString];
	[self updatePet];
}
// Set To Purple Color
- (void) setColorToPurple
{
	colorString = @"{0.93, 0.16, 0.48}";
	[buttonBottomRight setButtonColourWithString:colorString];
	[self updatePet];
}
// Set To Green Color
- (void) setColorToGreen
{
	colorString = @"{0.0, 0.65, 0.32}";
	[buttonBottomRight setButtonColourWithString:colorString];
	[self updatePet];
}
// Set To Custom Color
- (void) setColorToCustom
{
	
	colorString = [[NSString stringWithFormat:@"{%f, %f, %f}", 
					[sliderRedColor returnButtonPosition], 
					[sliderGreenColor returnButtonPosition], 
					[sliderBlueColor returnButtonPosition]] retain];
	[self updatePet];
}

// Set Visible Feature for Selected Category
- (void) setVisibleFeatureForSelectedCategory
{
	[self showFeaturePickerTab];
	for (int i = 0; i < [[allItems objectAtIndex:selectedCategoryIndex] count] && i < 6; i++) 
	{
		if([[[allItems objectAtIndex:selectedCategoryIndex] objectAtIndex:i] intValue] ==
		   [[[SettingManager sharedSettingManager] forProfileGet:selectedCategoryIndex + 9] intValue])
		{
			[[buttonIcons objectAtIndex:i] setButtonColourFilterRed:0.0 green:1.0 blue:0.0 alpha:1.0];
		}
		else
		{
			[[buttonIcons objectAtIndex:i] setButtonColourFilterRed:1.0 green:1.0 blue:1.0 alpha:1.0];
		}
		
		[[buttonIcons objectAtIndex:i] setText:[NSString stringWithFormat:@"%D",i]];
		[[buttonIcons objectAtIndex:i] setEnabled:TRUE];
	}
}

// Set Visible Feature Antenna
- (void) setVisibleFeatureAntenna
{
	//[self showFeaturePickerTab];
	selectedCategoryIndex = ItemType_Topper;
	[self setVisibleFeatureForSelectedCategory];
	
}
// Set Visible Feature Eyes
- (void) setVisibleFeatureEyes
{
	//[self showFeaturePickerTab];
	selectedCategoryIndex = ItemType_Eyes;
	[self setVisibleFeatureForSelectedCategory];
	
}
// Set Visible Feature Pattern
- (void) setVisibleFeaturePattern
{
	//[self showFeaturePickerTab];
	selectedCategoryIndex = ItemType_Body_Pattern;
	[self setVisibleFeatureForSelectedCategory];

}
// Set Visible Feature Body Type
- (void) setVisibleFeatureBodyType
{
	//[self showFeaturePickerTab];
	selectedCategoryIndex = ItemType_Body_Type;
	[self setVisibleFeatureForSelectedCategory];
	
}
// Set Feature to top left icon 
- (void) setFeatureToTopLeftIcon
{
	// Index is 0
	[previewItems replaceObjectAtIndex:selectedCategoryIndex withObject:
	 [[allItems objectAtIndex:selectedCategoryIndex] objectAtIndex:0]];
	[self updatePet];
}
// Set Feature to top mid icon 
- (void) setFeatureToTopMidIcon
{
	// Index is 1
	[previewItems replaceObjectAtIndex:selectedCategoryIndex withObject:
	 [[allItems objectAtIndex:selectedCategoryIndex] objectAtIndex:1]];
	[self updatePet];
}
// Set Feature to top right icon 
- (void) setFeatureToTopRightIcon
{
	// Index is 2
	[previewItems replaceObjectAtIndex:selectedCategoryIndex withObject:
	 [[allItems objectAtIndex:selectedCategoryIndex] objectAtIndex:2]];
	[self updatePet];
}
// Set Feature to bottom left icon 
- (void) setFeatureToBottomLeftIcon
{
	// Index is 3
	[previewItems replaceObjectAtIndex:selectedCategoryIndex withObject:
	 [[allItems objectAtIndex:selectedCategoryIndex] objectAtIndex:3]];
	[self updatePet];
}
// Set Feature to bottom mid icon 
- (void) setFeatureToBottomMidIcon
{
	// Index is 4
	[previewItems replaceObjectAtIndex:selectedCategoryIndex withObject:
	 [[allItems objectAtIndex:selectedCategoryIndex] objectAtIndex:4]];
	[self updatePet];
}
// Set Feature to bottom right icon 
- (void) setFeatureToBottomRightIcon
{
	// Index is 5
	[previewItems replaceObjectAtIndex:selectedCategoryIndex withObject:
	 [[allItems objectAtIndex:selectedCategoryIndex] objectAtIndex:5]];
	[self updatePet];
}


- (void) adjustSlidersToString:(NSString*)cStr
{
	NSString *cString = [cStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  
	
    // Proper color strings are denoted with braces  
    if (![cString hasPrefix:@"{"])
	{
		[sliderRedColor setButtonPosition:1.0];
		[sliderGreenColor setButtonPosition:1.0];
		[sliderBlueColor setButtonPosition:1.0];
		return;
	}
    if (![cString hasSuffix:@"}"]) 
	{
		[sliderRedColor setButtonPosition:1.0];
		[sliderGreenColor setButtonPosition:1.0];
		[sliderBlueColor setButtonPosition:1.0];
		return;
	}
	
    // Remove braces      
    cString = [cString substringFromIndex:1];  
    cString = [cString substringToIndex:([cString length] - 1)];  
    //CFShow(cString);  
	
    // Separate into components by removing commas and spaces  
    NSArray *components = [cString componentsSeparatedByString:@", "];
	
    if ([components count] != 3) 
	{
		[sliderRedColor setButtonPosition:1.0];
		[sliderGreenColor setButtonPosition:1.0];
		[sliderBlueColor setButtonPosition:1.0];
		return;
	}
	
	[sliderRedColor setButtonPosition:[[components objectAtIndex:0] floatValue]];
	[sliderGreenColor setButtonPosition:[[components objectAtIndex:1] floatValue]];
	[sliderBlueColor setButtonPosition:[[components objectAtIndex:2] floatValue]];
}

// Closes the scene and returns to stage. Does not save.
- (void) loadMenu
{
	[[Director sharedDirector] setCurrentSceneToSceneWithKey:SCENEKEY_MENU];
}

// Update Preview Pet
- (void) updatePet
{
	[previewPet adjustImagesWithUID:previewItems andColor:colorString];
	int cost = 0;
	
	if([[[SettingManager sharedSettingManager] forProfileGet:Profilekey_Pet_Antenna] intValue]  != 
		 [[previewItems objectAtIndex:ItemType_Topper] intValue])
	{
		cost += 25;
	}
	if([[[SettingManager sharedSettingManager] forProfileGet:ProfileKey_Pet_Eyes] intValue] !=
		 [[previewItems objectAtIndex:ItemType_Eyes] intValue])
	{
		cost += 25;
	}
	if(![[[SettingManager sharedSettingManager] forProfileGet:ProfileKey_Pet_Color] 
		 isEqualToString:colorString])
	{
		cost += 25;
	}
	[coinIndicatorCost changeInitialValue:cost];
}

- (void)updateWithDelta:(GLfloat)aDelta 
{
	[super updateWithDelta:aDelta];
	switch (sceneState) 
	{
			// The Scene is in the forefront and running.
		case SceneState_Running:
		{
			[coinIndicatorUser updateWithDelta:aDelta];
			[treatIndicator updateWithDelta:aDelta];
			[coinIndicatorCost updateWithDelta:aDelta];
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
			NSLog(@"ERROR: StylizeScene has no valid state.");
			break;
		}
	}
}

- (void)updateWithTouchLocationBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView 
{
	[super updateWithTouchLocationBegan:touches withEvent:event view:aView];
	
	[buttonBack touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
	[buttonApply touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
	
	[buttonTabOne touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];

	[buttonTabTwo touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
	
	for (ButtonControl* iconButton in buttonIcons) 
	{
		[iconButton touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
	}

	[sliderRedColor touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
	[sliderGreenColor touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
	[sliderBlueColor touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];

	[buttonTopLeft touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
	[buttonMidLeft touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
	[buttonBottomLeft touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
	[buttonTopRight touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
	[buttonMidRight touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
	[buttonBottomRight touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
}

- (void)updateWithTouchLocationMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView 
{
	[super updateWithTouchLocationMoved:touches withEvent:event view:aView];
	
	[buttonBack touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
	[buttonApply touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];

	[buttonTabOne touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
	[buttonTabTwo touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
	for (ButtonControl* iconButton in buttonIcons) 
	{
		[iconButton touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
	}
	
	[sliderRedColor touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
	[sliderGreenColor touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
	[sliderBlueColor touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
	
	[buttonTopLeft touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
	[buttonMidLeft touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
	[buttonBottomLeft touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
	[buttonTopRight touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
	[buttonMidRight touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
	[buttonBottomRight touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];	
}

- (void)updateWithTouchLocationEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView 
{
	[super updateWithTouchLocationEnded:touches withEvent:event view:aView];
	
	[buttonBack touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
	[buttonApply touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
	[buttonTabOne touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
	[buttonTabTwo touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
	for (ButtonControl* iconButton in buttonIcons) 
	{
		[iconButton touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
	}

	[sliderRedColor touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
	[sliderGreenColor touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
	[sliderBlueColor touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
	
	[buttonTopLeft touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
	[buttonMidLeft touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
	[buttonBottomLeft touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
	[buttonTopRight touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
	[buttonMidRight touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
	[buttonBottomRight touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];	
	
	if([buttonTabOne activated] && [buttonTabOne enabled])
	{
		[buttonTabOne setActivated:FALSE];
		[self showFeatureTypeTab];
	}
		
	if([buttonTabTwo activated] && [buttonTabTwo enabled])
	{
		[buttonTabTwo setActivated:FALSE];
		[self showColorTab];
	}
}

- (void)updateWithAccelerometer:(UIAcceleration*)aAcceleration 
{
	[super updateWithAccelerometer:aAcceleration];
}

- (void)render 
{
	if(!isInitialized)
		return;
	
	glPushMatrix();
	[imagePreviewPetBackground render];
	[previewPet render];
	
	[coinIndicatorUser render];
	[treatIndicator render];
	
	[buttonBack render];
	[buttonApply render];
	
	if([buttonTabOne selected])
	{
		[imageTabTwo render];
		[imageTabOne render];
	}
	if([buttonTabTwo selected])
	{
		[imageTabOne render];
		[imageTabTwo render];
	}
	for (ButtonControl* iconButton in buttonIcons) 
	{
		[iconButton render];
	}
	
	[sliderRedColor render];
	[labelRedSlider render];
	[sliderGreenColor render];
	[labelGreenSlider render];
	[sliderBlueColor render];
	[labelBlueSlider render];
	
	[buttonTopLeft render];
	[buttonMidLeft render];
	[buttonBottomLeft render];
	[buttonTopRight render];
	[buttonMidRight render];
	[buttonBottomRight render];	

	[labelColor render];
	[labelFeatures render];
	[coinIndicatorCost render];
	glPopMatrix();
}

@end
