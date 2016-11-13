//
//  MenuScene.m
//  BadBadMonkey
//
//  Created by Dustin Atwood on 1/3/11.
//  Copyright 2011 Litlapps. All rights reserved.
//


#import "MenuScene.h"

@implementation MenuScene

- (id) init
{
	self = [super init];
	if (self != nil) 
	{
		NSLog(@"Menu Scene Initializing...");
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(attemptInAppPurchase:) name:@"NETWORK_RECIEVED_PRODUCT" object:nil];
		[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
	}
	return self;
}

// -----========-------

- (BOOL)canMakePurchases
{
	return [SKPaymentQueue canMakePayments];
}

- (void)finalizePurchaseNamed:(NSString*)productName
{
    if([productName rangeOfString:@"premium"].location != NSNotFound)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[[UIDevice currentDevice] uniqueIdentifier] forKey:@"PREMIUM"];
        [[NSUserDefaults standardUserDefaults] synchronize]; 
        [super removeControl:9999];
    }
}

- (void) attemptInAppPurchase:(NSNotification*)productIdentifier
{
	SKPayment *payment = [SKPayment paymentWithProductIdentifier:(NSString *)[productIdentifier object]];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    [self finalizePurchaseNamed:transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    [self finalizePurchaseNamed:transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    else
        // this is fine, the user just cancelled, so don’t notify
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{	
	if (buttonIndex == 1)
        [[NetworkManager sharedNetworkManager] requestPremium];
}

// -----========-------

- (void) startLoadScene
{
	NSLog(@"Menu Scene Loading...");
    
    ButtonControl* aButton;
	aButton = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonLarge" 
                                                        withText:@"Play" 
                                                    withFontName:FONT_LARGE
                                              atScreenPercentage:CGPointMake(50.0, 18)];
    [aButton setIdentifier:Button_Action];
	[aButton setTarget:self andAction:@selector(loadGameScene)];
	[aButton setButtonColourFilterRed:0.0 green:1.0 blue:0.0 alpha:1.0];
	[[super sceneControls] addObject:aButton];
	[aButton release];
    
    // Premium Controls
    if([[SettingManager sharedSettingManager] isPremium])
    {
        // Player is Premium
        
        // Character change Right Arrow
        aButton = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonSmall" 
                                              withSubImageNamed:@"InterfaceArrowRight"
                                             atScreenPercentage:CGPointMake(88, 62.5)];
        [aButton setTarget:self andAction:@selector(showNextProfile)];
        [aButton setButtonColourFilterRed:0.5 green:0.0 blue:1.0 alpha:1.0];
        [aButton setIdentifier:800];
        [[super sceneControls] addObject:aButton];
        [aButton release]; 
        
        // Character Change Left Arrow
        aButton = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonSmall" 
                                              withSubImageNamed:@"InterfaceArrowLeft"
                                             atScreenPercentage:CGPointMake(12, 62.5)];
        [aButton setTarget:self andAction:@selector(showPreviousProfile)];
        [aButton setButtonColourFilterRed:0.5 green:0.0 blue:1.0 alpha:1.0];
        [aButton setIdentifier:900];
        [[super sceneControls] addObject:aButton];
        [aButton release]; 
        
        // Skill/Boost Tree
    }
    // User is not Premium
    else
    {
        aButton = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonBar" 
                                                       withText:@"Upgrade to Premium"
                                                   withFontName:FONT21
                                             atScreenPercentage:CGPointMake(50.0, 5)];
        [aButton setTarget:[NetworkManager sharedNetworkManager] andAction:@selector(requestPremium)];
        [aButton setButtonColourFilterRed:0.0 green:0.0 blue:1.0 alpha:1.0];
        [aButton setIdentifier:9999];
        [[super sceneControls] addObject:aButton];
        [aButton release];
    }
    
	aButton = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonNormal"
                                                        withText:@"Stylize" withFontName:FONT21
                                              atScreenPercentage:CGPointMake(50.0, 38)];
	[aButton setTarget:self andAction:@selector(loadStylizeScene)];
	[aButton setButtonColourFilterRed:1.0 green:1.0 blue:0.0 alpha:1.0];
    [aButton setIdentifier:Button_Options];
	[[super sceneControls] addObject:aButton];
	[aButton release];
    
	Image* imageBackground = [[ResourceManager sharedResourceManager] getImageWithImageNamed:@"InterfacePortrait"
																			withinAtlasNamed:@"InterfaceAtlas"];
	[imageBackground setPositionAtScreenPrecentage:CGPointMake(50, 62.5)];
	[[super sceneImages] addObject:imageBackground];
	[imageBackground release];
	
	Image* imageHeader = [[Image alloc] initWithImageNamed:@"InterfaceTitle"];
	[imageHeader setPositionAtScreenPrecentage:CGPointMake(50, 88)];
	[[super sceneImages] addObject:imageHeader];
	[imageHeader release];
	
	playerPet = [[PetActor alloc] init];
    
    CGRect boundingBox = [playerPet boundingBox];
    boundingBox.origin.y += 20;
    [playerPet setBoundingBox:boundingBox];
    
    selectedCharacter = [[[SettingManager sharedSettingManager] for:FileType_Player get:ProfileKey_Character] intValue];
    
	[self finishLoadScene];
}

- (void) finishLoadScene
{
    
	NSLog(@"Finish Loading...");
	[self setIsInitialized:TRUE];
	[self transitioningToCurrentScene];
	//[[Director sharedDirector] stopLoading];
    
}

// Loads Stylize Scene
- (void) loadStylizeScene
{
    if([[SettingManager sharedSettingManager] isPremium])
    {
        [[SettingManager sharedSettingManager] for:FileType_Player 
         set:ProfileKey_Character 
         to:[[NSNumber numberWithInt:selectedCharacter] stringValue]];
        
        [[Director sharedDirector] setCurrentSceneToSceneWithKey:SCENEKEY_STYLIZE];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Premium Required" message:@"In order to access Stylize Option you must upgrade to Premium. Premium memberhip is permanent and grants you access to exclusive content in later updates!" delegate:self cancelButtonTitle:@"No Thanks" otherButtonTitles:@"Yes, Please!", nil];
        alert.tag = 1;
        alert.delegate = self;
        [alert show];
        [alert release];
    }
}
- (void) showNextProfile
{
    // Load the next character in the player's settings.
    // If there is no more characters then hide the right button and show a the Create Image.
    // Disable the Stylize Button and change the play button to a stylize.
    
    // Determine if the next character is an Unused Character.
    // This is done by checking to see if there is a cost "ProfileKey_Cost" which is index 0.
    
    int newSelection = selectedCharacter;
    
    newSelection++;
    if(newSelection > 9)  
        newSelection = 0;
    
    [[super control:900] setVisible:TRUE];
    
    // Sync Selected Character Index
    [[SettingManager sharedSettingManager] for:FileType_Player 
                                           set:ProfileKey_Character 
                                            to:[[NSNumber numberWithInt:newSelection] stringValue]];
    /*
    if([[[SettingManager sharedSettingManager] for:FileType_Character get:ProfileKey_Cost] intValue] > 0)
    {
        //[[super control:800] setVisible:FALSE];
        [playerPet loadNewCharacterCreation];
        
        [[SettingManager sharedSettingManager] for:FileType_Player 
         set:ProfileKey_Character 
         to:[[NSNumber numberWithInt:selectedCharacter] stringValue]];
        selectedCharacter = newSelection;
        
        [[super label:1] setVisible:TRUE];
        [[super control:Button_Action] setTarget:self andAction:@selector(loadStylizeScene)];
        [[super control:Button_Action] setText:@"Create"];
        [[super control:Button_Options] setVisible:FALSE];
    }
    else
    {
        [[super label:1] setVisible:FALSE];
        [playerPet loadPartsFromFile];
        selectedCharacter = newSelection;
        
        [[super label:1] setVisible:TRUE];
        [[super control:Button_Action] setTarget:self andAction:@selector(loadGameScene)];
        [[super control:Button_Action] setText:@"Play"];
        [[super control:Button_Options] setVisible:TRUE];
    }
    */
    if(![self updateSelection])
    {
        [[SettingManager sharedSettingManager] for:FileType_Player 
         set:ProfileKey_Character 
         to:[[NSNumber numberWithInt:selectedCharacter] stringValue]];
    }
    selectedCharacter = newSelection;
}

- (void) showPreviousProfile
{
    // Load the previous character in the player's settings.
    // If there is no more characters then hide the left button and show a the Create Image.
    // Disable the Stylize Button and change the play button to a stylize.
    
    // Determine if the next character is an Unused Character.
    // This is done by checking to see if there is a cost "ProfileKey_Cost" which is index 0.
    
    int newSelection = selectedCharacter;
    
    newSelection--;
    if(newSelection < 0)  
        newSelection = 9;
    
    [[super control:800] setVisible:TRUE];
    
    // Sync Selected Character Index
    [[SettingManager sharedSettingManager] for:FileType_Player 
                                           set:ProfileKey_Character 
                                            to:[[NSNumber numberWithInt:newSelection] stringValue]];
    /*
    if([[[SettingManager sharedSettingManager] for:FileType_Character get:ProfileKey_Cost] intValue] > 0)
    {
        //[[super control:900] setVisible:FALSE];
        [playerPet loadNewCharacterCreation];
        
        [[SettingManager sharedSettingManager] for:FileType_Player 
         set:ProfileKey_Character 
         to:[[NSNumber numberWithInt:selectedCharacter] stringValue]];
        selectedCharacter = newSelection;
        [[super label:1] setVisible:TRUE];
        
        [[super label:1] setVisible:TRUE];
        [[super control:Button_Action] setTarget:self andAction:@selector(loadStylizeScene)];
        [[super control:Button_Action] setText:@"Stylize"];
        [[super control:Button_Options] setVisible:FALSE];
    }
    else
    {
        [playerPet loadPartsFromFile];
        selectedCharacter = newSelection;
        [[super label:1] setVisible:FALSE];
        
        [[super label:1] setVisible:TRUE];
        [[super control:Button_Action] setTarget:self andAction:@selector(loadGameScene)];
        [[super control:Button_Action] setText:@"Play"];
        [[super control:Button_Options] setVisible:TRUE];
    }
    */
    
    
    
    if(![self updateSelection])
    {
        [[SettingManager sharedSettingManager] for:FileType_Player 
         set:ProfileKey_Character 
         to:[[NSNumber numberWithInt:selectedCharacter] stringValue]];
    }
    selectedCharacter = newSelection;
}

- (BOOL) updateSelection
{
    if([[[SettingManager sharedSettingManager] for:FileType_Character get:ProfileKey_Cost] intValue] > 0)
    {
        //[[super control:900] setVisible:FALSE];
        [playerPet loadNewCharacterCreation];
        
        [[super label:1] setVisible:TRUE];
        
        [[super label:1] setVisible:TRUE];
        [[super control:Button_Action] setTarget:self andAction:@selector(loadStylizeScene)];
        [[super control:Button_Action] setText:@"Stylize"];
        [[super control:Button_Options] setVisible:FALSE];
        return false;
    }
    else
    {
        [playerPet loadPartsFromFile];
        [[super label:1] setVisible:FALSE];
        
        [[super label:1] setVisible:TRUE];
        [[super control:Button_Action] setTarget:self andAction:@selector(loadGameScene)];
        [[super control:Button_Action] setText:@"Play"];
        [[super control:Button_Options] setVisible:TRUE];
        return true;
    } 
}

// Load Game Scene
- (void) loadGameScene
{
	[[Director sharedDirector] setCurrentSceneToSceneWithKey:GAMEKEY_SKY];
}

// Loads Character Scene
- (void) loadCharacterScene
{	
	[[Director sharedDirector] setCurrentSceneToSceneWithKey:SCENEKEY_CHARACTER];
}

// Shows the game's Options
- (void) showOptions
{
	//[[Director sharedDirector] setCurrentSceneToSceneWithKey:SCENEKEY_OPTIONS];
}

- (void)transitioningToCurrentScene
{
	if(!isInitialized)
	{
		//[[Director sharedDirector] startLoading];
		[self startLoadScene];
	}

    [self updateSelection];
    //[playerPet loadPartsFromFile];
}

- (void)updateWithDelta:(GLfloat)aDelta 
{
	if(!isInitialized)
		return;
	
	[super updateWithDelta:aDelta];
	
	switch (sceneState) 
	{
			// The Scene is in the forefront and running.
		case SceneState_Running:
		{
            [playerPet updateWithDelta:aDelta];
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
	if(!isInitialized)
		return;
	
	[super updateWithTouchLocationBegan:touches withEvent:event view:aView];
	
	switch (sceneState) 
	{
			// The Scene is in the forefront and running.
		case SceneState_Running:
		{
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

- (void)updateWithTouchLocationMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView 
{
	if(!isInitialized)
		return;
	
	[super updateWithTouchLocationMoved:touches withEvent:event view:aView];
	
	switch (sceneState) 
	{
			// The Scene is in the forefront and running.
		case SceneState_Running:
		{
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

- (BOOL)updateWithTouchLocationEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView 
{
	if(!isInitialized)
		return FALSE;
	
	BOOL touched = [super updateWithTouchLocationEnded:touches withEvent:event view:aView];
	
	switch (sceneState) 
	{
			// The Scene is in the forefront and running.
		case SceneState_Running:
		{
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
	return touched;
}

- (void)updateWithAccelerometer:(UIAcceleration*)aAcceleration 
{
	if(!isInitialized)
		return;
	
	[super updateWithAccelerometer:aAcceleration];
}

- (void)render 
{
	glPushMatrix();
	
	[super render];
	
	switch (sceneState) 
	{
			// The Scene is in the forefront and running.
		case SceneState_Running:
		{
			//if(indicatorPower)
              //  [indicatorPower render];
			
			if(playerPet)
				[playerPet render];
			
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
	
	glPopMatrix();
}

@end