//
//  StylizeScene.m
//  BadBadMonkey
//
//  Created by Dustin Atwood on 9/20/10.
//  Copyright 2010 Litlapps. All rights reserved.
//
/*
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
 */
#define Tutorial_Button 50
#define Tutorial_Label 51
#define Tutorial_Image 52

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

	NSLog(@"Creating Indicators");
	coinIndicatorCost = [[Indicator alloc] initAtScreenPercentage:CGPointMake(50, 45.20) withSize:1 
													 currencyType:CurrencyType_Coin leftsideIcon:YES];	
	
	indicatorPlayer = [[IndicatorPlayer alloc] init];
	
	NSLog(@"Creating Buttons");
	ButtonControl* button;
	
	button = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonSmall" 
												  withText:@"Back" 
											  withFontName:FONT21
										atScreenPercentage:CGPointMake(15, 93.54)];
	[button setTarget:self andAction:@selector(loadMenuScene)];
	[button setButtonColourFilterRed:1.0 green:0.0 blue:0.0 alpha:1.0];
	[button setIdentifier:Button_Cancel];
	[[super sceneControls] addObject:button];
	[button release];
	
	button = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonSmall" 
												  withText:@"OK" 
											  withFontName:FONT21
										atScreenPercentage:CGPointMake(86, 52)];
	[button setTarget:self andAction:@selector(save)];
	[button setButtonColourFilterRed:0.0 green:1.0 blue:0.0 alpha:1.0];
	[button setIdentifier:Button_Action];
	[[super sceneControls] addObject:button];
	[button release];

	// Setting Up Icon Buttons
	// Top Left Icon
	
	button = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonSmall" 
															 withText:@"" 
			  withFontName:FONT21
												   atScreenPercentage:CGPointMake(20, 23)];
	[button setTarget:self andAction:@selector(setFeatureToTopLeftIcon)];
    [button setButtonColourFilterRed:0.5 green:0.5 blue:1.0 alpha:1.0];
	[button setIdentifier:1];
	[[super sceneControls] addObject:button];
	[button release];
	
	// Top Mid Icon
	button = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonSmall" 
												  withText:@"" 
											  withFontName:FONT21
										atScreenPercentage:CGPointMake(50, 23)];
	[button setTarget:self andAction:@selector(setFeatureToTopMidIcon)];
	[button setButtonColourFilterRed:0.5 green:0.5 blue:1.0 alpha:1.0];
    [button setIdentifier:2];
	[[super sceneControls] addObject:button];
	[button release];
	// Top Right Icon
	button = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonSmall" 
															 withText:@"" 
			  withFontName:FONT21
												   atScreenPercentage:CGPointMake(80, 23)];
	[button setTarget:self andAction:@selector(setFeatureToTopRightIcon)];
	[button setButtonColourFilterRed:0.5 green:0.5 blue:1.0 alpha:1.0];
    [button setIdentifier:3];
	[[super sceneControls] addObject:button];
	[button release];
	// Bottom Left Icon
	button = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonSmall" 
															 withText:@"" 
			  withFontName:FONT21
												   atScreenPercentage:CGPointMake(20, 8)];
	[button setTarget:self andAction:@selector(setFeatureToBottomLeftIcon)];
	[button setButtonColourFilterRed:0.5 green:0.5 blue:1.0 alpha:1.0];
    [button setIdentifier:4];
	[[super sceneControls] addObject:button];
	[button release];
	// Bottom Mid Icon
	button = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonSmall" 
															withText:@"" 
			  withFontName:FONT21
												  atScreenPercentage:CGPointMake(50, 8)];
	[button setTarget:self andAction:@selector(setFeatureToBottomMidIcon)];
	[button setButtonColourFilterRed:0.5 green:0.5 blue:1.0 alpha:1.0];
    [button setIdentifier:5];
	[[super sceneControls] addObject:button];
	[button release];
	// Bottom Right Icon
	button = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonSmall" 
															  withText:@"Done" 
			  withFontName:FONT21
													atScreenPercentage:CGPointMake(80, 8)];
	[button setTarget:self andAction:@selector(showFeatureTypeTab)];
	[button setButtonColourFilterRed:0.5 green:0.5 blue:1.0 alpha:1.0];
    [button setIdentifier:6];
	[button setButtonColourFilterRed:1.0 green:0.0 blue:0.0 alpha:1.0];
	[[super sceneControls] addObject:button];
	[button release];
	
	// Setting up Large Buttons
    
    button = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonNormal" 
                                              withText:@""
                                          withFontName:FONT21 
                                    atScreenPercentage:CGPointMake(26.1, 27.08)];
	[button setIdentifier:11];
	[[super sceneControls] addObject:button];
	[button release];
	
	button = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonNormal"  
												  withText:@"" 
                                              withFontName:FONT21
										atScreenPercentage:CGPointMake(26.1, 16.7)];
	[button setIdentifier:22];
	[[super sceneControls] addObject:button];
	[button release];
	
	button = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonNormal"  
												  withText:@"" 
                                                   withFontName:FONT21
										atScreenPercentage:CGPointMake(26.1, 6.25)];
	[button setIdentifier:33];
	[[super sceneControls] addObject:button];
	[button release];
	
	button = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonNormal"  
												  withText:@"" 
                                                   withFontName:FONT21
										atScreenPercentage:CGPointMake(73.75, 27.08)];
	[button setIdentifier:44];
	[[super sceneControls] addObject:button];
	[button release];
	
	button = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonNormal"  
												  withText:@"" 
                                              withFontName:FONT21
										atScreenPercentage:CGPointMake(73.75, 16.7)];
	[button setIdentifier:55];
	[[super sceneControls] addObject:button];
	[button release];
	
	button = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonNormal"  
												  withText:@"" 
                                                   withFontName:FONT21
										atScreenPercentage:CGPointMake(73.75, 6.25)];
	[button setIdentifier:66];
	[[super sceneControls] addObject:button];
	[button release];
	
	
	 // Setting up Tabs
	buttonTabOne = [[AbstractControl alloc] initWithCGRect:CGRectMake(80, 175, 160, 34)];
	[buttonTabOne setSticky:YES];
	[buttonTabOne setLocked:YES];
	imageTabOne = [[ResourceManager sharedResourceManager] getImageWithImageNamed:@"InterfaceTabOne" 
																 withinAtlasNamed:@"InterfaceAtlas"];
	[imageTabOne setPositionImage:CGPointMake(160, 97)];
	buttonTabTwo = [[AbstractControl alloc] initWithCGRect:CGRectMake(240, 175, 160, 34)];
	[buttonTabTwo setSticky:YES];
	[buttonTabTwo setLocked:YES];
	imageTabTwo = [[ResourceManager sharedResourceManager] getImageWithImageNamed:@"InterfaceTabTwo" 
																 withinAtlasNamed:@"InterfaceAtlas"];
	[imageTabTwo setPositionImage:CGPointMake(160, 97)];
	
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
	
	imageBackgroundPet = [[ResourceManager sharedResourceManager] getImageWithImageNamed:@"InterfacePortrait" withinAtlasNamed:@"InterfaceAtlas"];
	[imageBackgroundPet setPositionAtScreenPrecentage:CGPointMake(50, 66.7)];
	
	labelFeatures = [[LabelControl alloc] initWithFontName:FONT21];
	[labelFeatures setText:@"Features" atSceenPercentage:CGPointMake(29, 37)];
	labelColor = [[LabelControl alloc] initWithFontName:FONT21];
	[labelColor setText:@"Color" atSceenPercentage:CGPointMake(71, 37)];
	
	// Gets all items for the pet slots.
	allItems = [[NSArray alloc] initWithObjects: 
				[sharedSettingManager getItemsInBin:ItemBin_All ofType:ItemKey_Character],
				[sharedSettingManager getItemsInBin:ItemBin_All ofType:ItemKey_Antenna],
				[sharedSettingManager getItemsInBin:ItemBin_All ofType:ItemKey_Eyes],
				nil];
	
	previewItems = [[NSMutableArray alloc] initWithObjects:
					[[allItems objectAtIndex:0] objectAtIndex:0],
					[[allItems objectAtIndex:1] objectAtIndex:0],
					[[allItems objectAtIndex:2] objectAtIndex:0],
					nil];
	
	selectedCategoryIndex = 0;
	selectedItemIndex = 0;
	
	previewPet = [[PetActor alloc] init];
	
    CGRect boundingBox = [previewPet boundingBox];
    boundingBox.origin.y += 40;
    [previewPet setBoundingBox:boundingBox];
	
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
	else
	{
		[indicatorPlayer refresh];
		colorString = [[NSString stringWithString:[sharedSettingManager for:FileType_Character get:ProfileKey_Color]] retain];
		
		// Parts are now defined in an array....
        
        // Character Type
        [previewItems replaceObjectAtIndex:ItemKey_Character withObject:
		 [[SettingManager sharedSettingManager] for:FileType_Character get:ProfileKey_Part1]];
        // Checking to make sure the Part1 is a valid Atlas.
        if ([[previewItems objectAtIndex:0] isEqualToString:@"1000"])
            [previewItems replaceObjectAtIndex:ItemKey_Character withObject:@"Squirkle"];
        
        // Antenna Type
        [previewItems replaceObjectAtIndex:ItemKey_Antenna withObject:
		 [[SettingManager sharedSettingManager] for:FileType_Character get:ProfileKey_Part2]];
        // Checking to make sure the Part2 is a valid part.
        if ([[previewItems objectAtIndex:1] isEqualToString:@"1002"])
            [previewItems replaceObjectAtIndex:ItemKey_Antenna withObject:@"Antenna1"];
        
        // Eyes Type
		[previewItems replaceObjectAtIndex:ItemKey_Eyes withObject:
		 [[SettingManager sharedSettingManager] for:FileType_Character get:ProfileKey_Part3]];
        // Checking to make sure the Part3 is a valid part.
        if ([[previewItems objectAtIndex:2] isEqualToString:@"1005"])
            [previewItems replaceObjectAtIndex:ItemKey_Eyes withObject:@"Eyes3"];
		
		[imageTabOne setColourWithString:colorString];
		[imageTabTwo setColourWithString:colorString];
		
		[previewPet setColorCharacter:colorString];
		[previewPet loadPart:ProfileKey_Part1 withUID:[previewItems objectAtIndex:0] characterUID:[previewItems objectAtIndex:0]];
		[previewPet loadPart:ProfileKey_Part2 withUID:[previewItems objectAtIndex:1] characterUID:[previewItems objectAtIndex:0]];
		[previewPet loadPart:ProfileKey_Part3 withUID:[previewItems objectAtIndex:2] characterUID:[previewItems objectAtIndex:0]];
		
		[coinIndicatorCost changeInitialValue:0];
		[self showFeatureTypeTab];
        
        [previewPet setRenderPet:TRUE];
	}
} 

// Attempts to purchase all previewed Items and the saves them as equipped
- (void) save
{
    [[SettingManager sharedSettingManager] for:FileType_Character set:ProfileKey_Cost to:@"0"]; 
    
    [sharedSettingManager for:FileType_Character set:ProfileKey_Color to:colorString];
    [sharedSettingManager for:FileType_Character set:ProfileKey_Part1 to:[previewItems objectAtIndex:0]];
    [sharedSettingManager for:FileType_Character set:ProfileKey_Part2 to:[previewItems objectAtIndex:1]];
    [sharedSettingManager for:FileType_Character set:ProfileKey_Part3 to:[previewItems objectAtIndex:2]];
    [coinIndicatorCost changeInitialValue:0];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PLAYER_COLOR_CHANGE" object:nil];
    
    [self loadMenuScene];
}

//
// -- Setting Up Different Tab Types
// 
// Show Feature Type Tab
- (void) showFeatureTypeTab
{
	[[labelFeatures font] setColourFilterRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
	[[labelColor font] setColourFilterRed:0.5f green:0.5f blue:0.5f alpha:1.0f];
	
	// By Default Disable All buttons then renabled as needed
	for (ButtonControl* button in [super sceneControls]) 
	{
		[button setVisible:FALSE];
	}
	
    [[super control:Button_Cancel] setVisible:TRUE];
	
    [[super control:Button_Action] setVisible:TRUE];
	
	// Show 1st Tab
	[buttonTabOne setSelected:TRUE];
	[buttonTabTwo setSelected:FALSE];
	
	// Hide Color Picker
	[sliderRedColor setVisible:FALSE];
	[labelRedSlider setVisible:FALSE];
	[sliderGreenColor setVisible:FALSE];
	[labelGreenSlider setVisible:FALSE];
	[sliderBlueColor setVisible:FALSE];
	[labelBlueSlider setVisible:FALSE];
	
	// Adjust Large Buttons
	[[super control:11] setText:@"Body Type"];
	[[super control:11] setTarget:self andAction:@selector(setVisibleFeatureBodyType)];
	[[super control:11] setButtonColourFilterRed:0.5 green:0.5 blue:1.0 alpha:1.0];
	
	[[super control:33] setText:@"Antenna"];
	[[super control:33] setTarget:self andAction:@selector(setVisibleFeatureAntenna)];
    [[super control:33] setButtonColourFilterRed:0.5 green:0.5 blue:1.0 alpha:1.0];
	
	//[[super control:44] setText:@"Body Type"];
	//[[super control:44] setTarget:self andAction:@selector(setVisibleFeatureBodyType)];
	//[[super control:44] setButtonColourFilterRed:0.5 green:0.5 blue:1.0 alpha:1.0];
    
    [[super control:66] setText:@"Eyes"];
	[[super control:66] setTarget:self andAction:@selector(setVisibleFeatureEyes)];
	[[super control:66] setButtonColourFilterRed:0.5 green:0.5 blue:1.0 alpha:1.0];
}
// Show Feature Picker Tab
- (void) showFeaturePickerTab
{
	[[labelFeatures font] setColourFilterRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
	[[labelColor font] setColourFilterRed:0.5f green:0.5f blue:0.5f alpha:1.0f];
	
	// Show 1st Tab
	[buttonTabOne setSelected:TRUE];
	[buttonTabTwo setSelected:FALSE];
	
	// By Default Disable All buttons then renabled as needed
	for (ButtonControl* button in [super sceneControls]) 
	{
		[button setVisible:FALSE];
	}
	
    [[super control:Button_Cancel] setVisible:TRUE];
	
	[[super control:6] setVisible:TRUE];
	
	// Hide Color Picker
	[sliderRedColor setVisible:FALSE];
	[labelRedSlider setVisible:FALSE];
	[sliderGreenColor setVisible:FALSE];
	[labelGreenSlider setVisible:FALSE];
	[sliderBlueColor setVisible:FALSE];
	[labelBlueSlider setVisible:FALSE];
}
// Show Color Tab
- (void) showColorTab
{
	[[labelColor font] setColourFilterRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
	[[labelFeatures font] setColourFilterRed:0.5f green:0.5f blue:0.5f alpha:1.0f];
	
	// Show 1st Tab
	[buttonTabOne setSelected:FALSE];
	[buttonTabTwo setSelected:TRUE];
	
	// By Default Disable All buttons then renabled as needed
	for (ButtonControl* button in [super sceneControls]) 
	{
		[button setVisible:FALSE];
	}
	
    [[super control:Button_Cancel] setVisible:TRUE];
	
    [[super control:Button_Action] setVisible:TRUE];
	
	// Hide Color Picker
	[sliderRedColor setVisible:FALSE];
	[labelRedSlider setVisible:FALSE];
	[sliderGreenColor setVisible:FALSE];
	[labelGreenSlider setVisible:FALSE];
	[sliderBlueColor setVisible:FALSE];
	[labelBlueSlider setVisible:FALSE];
	
	// Adjust Large Buttons
	[[super control:11] setText:@"Red"];
	[[super control:11] setTarget:self andAction:@selector(setColorToRed)];
	[[super control:11] setButtonColourFilterRed:1.0 green:0.0 blue:0.0 alpha:1.0];
	
	[[super control:22] setText:@"Blue"];
	[[super control:22] setTarget:self andAction:@selector(setColorToBlue)];
	[[super control:22] setButtonColourFilterRed:0.0 green:0.68 blue:0.94 alpha:1.0];
	
	[[super control:33] setText:@"Yellow"];
	[[super control:33] setTarget:self andAction:@selector(setColorToYellow)];
	[[super control:33] setButtonColourFilterRed:1.0 green:0.95 blue:0.0 alpha:1.0];
	
	[[super control:44] setText:@"Purple"];
	[[super control:44] setTarget:self andAction:@selector(setColorToPurple)];
	[[super control:44] setButtonColourFilterRed:0.93 green:0.16 blue:0.48 alpha:1.0];
	
	[[super control:55] setText:@"Green"];
	[[super control:55] setTarget:self andAction:@selector(setColorToGreen)];
	[[super control:55] setButtonColourFilterRed:0.0 green:0.65 blue:0.32 alpha:1.0];
	
	[[super control:66] setText:@"Custom"];
	[[super control:66] setTarget:self andAction:@selector(showCustomColorTab)];
	[[super control:66] setButtonColourWithString:colorString];
}
// Show Custom Color Tab
- (void) showCustomColorTab
{
	[[labelColor font] setColourFilterRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
	[[labelFeatures font] setColourFilterRed:0.5f green:0.5f blue:0.5f alpha:1.0f];
	
	// Show 1st Tab
	[buttonTabOne setSelected:FALSE];
	[buttonTabTwo setSelected:TRUE];

	// By Default Disable All buttons then renabled as needed
	for (ButtonControl* button in [super sceneControls]) 
	{
		[button setVisible:FALSE];
	}
	
    [[super control:Button_Cancel] setVisible:TRUE];
	
    [[super control:Button_Action] setVisible:TRUE];

	// Show Color Picker
	[sliderRedColor setVisible:TRUE];
	[labelRedSlider setVisible:TRUE];
	[sliderGreenColor setVisible:TRUE];
	[labelGreenSlider setVisible:TRUE];
	[sliderBlueColor setVisible:TRUE];
	[labelBlueSlider setVisible:TRUE];
	// Set the sliders to current Color
	[self adjustSlidersToString:colorString];
	// Hide Large Buttons
	[[super control:11] setText:@"Done"];
	[[super control:11] setTarget:self andAction:@selector(showColorTab)];
	[[super control:11] setButtonColourFilterRed:1.0 green:0.0 blue:0.0 alpha:1.0];
}

//
// -- Executing Buttons
// 
// Set To Red Color
- (void) setColorToRed
{
	colorString = @"{1.0, 0.0, 0.0}";
	[[super control:66] setButtonColourWithString:colorString];
	[self updatePet];
}
// Set To Blue Color
- (void) setColorToBlue
{
	colorString = @"{0.0, 0.68, 0.94}";
	[[super control:66] setButtonColourWithString:colorString];
	[self updatePet];
}
// Set To Yellow Color
- (void) setColorToYellow
{
	colorString = @"{1.0, 0.95, 0.0}";
	[[super control:66] setButtonColourWithString:colorString];
	[self updatePet];
}
// Set To Purple Color
- (void) setColorToPurple
{
	colorString = @"{0.93, 0.16, 0.48}";
	[[super control:66] setButtonColourWithString:colorString];
	[self updatePet];
}
// Set To Green Color
- (void) setColorToGreen
{
	colorString = @"{0.0, 0.65, 0.32}";
	[[super control:66] setButtonColourWithString:colorString];
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
    //NSLog(@"AllItems: %@", allItems);
    
	[self showFeaturePickerTab];
	for (int i = 0; i < [[allItems objectAtIndex:selectedCategoryIndex] count] && i < 6; i++) 
	{
		[[super control:i + 1] setText:[NSString stringWithFormat:@"%D",i]];
		[[super control:i + 1] setVisible:TRUE];
	}
}

// Set Visible Feature Body Type
- (void) setVisibleFeatureBodyType
{
	//[self showFeaturePickerTab];
	selectedCategoryIndex = 0;
	[self setVisibleFeatureForSelectedCategory];
	
}

// Set Visible Feature Antenna
- (void) setVisibleFeatureAntenna
{
	//[self showFeaturePickerTab];
	selectedCategoryIndex = 1;
	[self setVisibleFeatureForSelectedCategory];
	
}

// Set Visible Feature Eyes
- (void) setVisibleFeatureEyes
{
	//[self showFeaturePickerTab];
	selectedCategoryIndex = 2;
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
- (void) loadMenuScene
{
	[[Director sharedDirector] setCurrentSceneToSceneWithKey:SCENEKEY_MENU];
}

// Update Preview Pet
- (void) updatePet
{
	[previewPet setColorCharacter:colorString];
	[previewPet loadPart:ProfileKey_Part1 withUID:[previewItems objectAtIndex:0] characterUID:[previewItems objectAtIndex:0]];
	[previewPet loadPart:ProfileKey_Part2 withUID:[previewItems objectAtIndex:1] characterUID:[previewItems objectAtIndex:0]];
	[previewPet loadPart:ProfileKey_Part3 withUID:[previewItems objectAtIndex:2] characterUID:[previewItems objectAtIndex:0]];
	int cost = 0;
	
	if([[[SettingManager sharedSettingManager] for:FileType_Character get:ProfileKey_Part2] intValue]  != 
		 [[previewItems objectAtIndex:1] intValue])
	{
		cost += 25;
	}
	if([[[SettingManager sharedSettingManager] for:FileType_Character get:ProfileKey_Part3] intValue] !=
		 [[previewItems objectAtIndex:2] intValue])
	{
		cost += 25;
	}
	if(![[[SettingManager sharedSettingManager] for:FileType_Character get:ProfileKey_Color] 
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
			[indicatorPlayer updateWithDelta:aDelta];
			[coinIndicatorCost updateWithDelta:aDelta];
            [previewPet updateWithDelta:aDelta];
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
	
	[buttonTabOne touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];

	[buttonTabTwo touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];

	[sliderRedColor touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
	[sliderGreenColor touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
	[sliderBlueColor touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
}

- (void)updateWithTouchLocationMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView 
{
	[super updateWithTouchLocationMoved:touches withEvent:event view:aView];
	
	[buttonTabOne touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
	[buttonTabTwo touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
	[sliderRedColor touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
	[sliderGreenColor touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
	[sliderBlueColor touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];	
}

- (BOOL)updateWithTouchLocationEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView 
{
	BOOL touched = [super updateWithTouchLocationEnded:touches withEvent:event view:aView];
	
	[buttonTabOne touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
	[buttonTabTwo touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];

	[sliderRedColor touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
	[sliderGreenColor touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
	[sliderBlueColor touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
	
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
	
	return touched;
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
	
	[imageBackgroundPet render];
	[previewPet render];
	
	[indicatorPlayer render];
	
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
	
	[sliderRedColor render];
	[labelRedSlider render];
	[sliderGreenColor render];
	[labelGreenSlider render];
	[sliderBlueColor render];
	[labelBlueSlider render];

	[labelColor render];
	[labelFeatures render];
	//[coinIndicatorCost render];
	
	[super render];
	
	glPopMatrix();
}

@end
