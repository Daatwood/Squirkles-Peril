//
//  StoreScene.m
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 2/8/11.
//  Copyright 2011 Dustin Atwood. All rights reserved.
//

#import "StoreScene.h"


@implementation StoreScene

- (id) init
{
	self = [super init];
	if (self != nil) 
	{
		NSLog(@"Store Scene Initializing...");
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCategoryCurrencyCoins) name:@"STORE_SHOW_COINS" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCategoryCurrencyTreats) name:@"STORE_SHOW_TREATS" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(attemptInAppPurchase:) name:@"NETWORK_RECIEVED_PRODUCT" object:nil];
		[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
	}
	return self;
}

- (void) startLoadScene
{
	NSLog(@"Store Scene Loading...");
	
	NSLog(@"Loading Labels...20");
	labelCategory = [[LabelControl alloc] initWithFontName:FONT21];
	labelDescription = [[LabelControl alloc] initWithFontName:FONT16];
	labelCost = [[LabelControl alloc] initWithFontName:FONT21];
	
	NSLog(@"Loading Indicators...40");
	coinIndicator = [[Indicator alloc] initAtScreenPercentage:CGPointMake(71.5625, 96) withSize:2 
													 currencyType:CurrencyType_Coin leftsideIcon:YES];
	treatIndicator = [[Indicator alloc] initAtScreenPercentage:CGPointMake(89.84375, 87.8125) withSize:0 
													  currencyType:CurrencyType_Treat leftsideIcon:NO];
	boostIndicator = [[Indicator alloc] initAtScreenPercentage:CGPointMake(60, 87.8125) withSize:0 
													  currencyType:CurrencyType_Boost leftsideIcon:YES];
	coinIndicatorCost = [[Indicator alloc] initAtScreenPercentage:CGPointMake(27, 28.7) withSize:1 
												 currencyType:CurrencyType_Coin leftsideIcon:YES];
	treatIndicatorCost = [[Indicator alloc] initAtScreenPercentage:CGPointMake(46, 34) withSize:0 
													  currencyType:CurrencyType_Treat leftsideIcon:NO];
	NSLog(@"Loading Buttons...60");
	buttonBack = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonSmall" withText:@"Back" 
											atScreenPercentage:CGPointMake(18.75, 93.54) isRotated:NO];
	[buttonBack setTarget:self andAction:@selector(loadMenuScene)];
	[buttonBack setButtonColourFilterRed:1.0 green:0.0 blue:0.0 alpha:1.0];
	
	buttonPrevious = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonSmall" withSubImageNamed:@"buttonPreviousArrow" 
												atScreenPercentage:CGPointMake(10.5, 56.67) isRotated:NO];
	[buttonPrevious setTarget:self andAction:@selector(showNext)];
	[buttonPrevious	setButtonColourFilterRed:0.5 green:0.5 blue:1.0 alpha:1.0];
	CGRect newSize = [buttonPrevious boundingBox];
	newSize.size = CGSizeMake(67.5, 185);
	buttonPrevious.boundingBox = newSize;
	
	buttonNext = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonSmall" withSubImageNamed:@"buttonNextArrow" 
												atScreenPercentage:CGPointMake(89.5, 56.67) isRotated:NO];
	[buttonNext setTarget:self andAction:@selector(showPrevious)];
	[buttonNext	setButtonColourFilterRed:0.5 green:0.5 blue:1.0 alpha:1.0];
	newSize = [buttonNext boundingBox];
	newSize.size = CGSizeMake(67.5, 185);
	buttonNext.boundingBox = newSize;
	
	buttonBuy = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonExtended" withText:@"Purchase" 
											  atScreenPercentage:CGPointMake(78, 30) isRotated:NO];
	[buttonBuy setTarget:self andAction:@selector(attemptPurchase)];
	[buttonBuy setButtonColourFilterRed:0.0 green:1.0 blue:0.0 alpha:1.0];
	
	buttonCategoryGame = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonSmall" withText:@"NYI" 
										   atScreenPercentage:CGPointMake(12.5, 7.5) isRotated:NO];
	[buttonCategoryGame setTarget:self andAction:@selector(showCategoryGame)];
	[buttonCategoryGame setButtonColourFilterRed:1.0 green:0.0 blue:0.0 alpha:1.0];
	[buttonCategoryGame setFontColourFilterRed:1.0 green:0.0 blue:0.0 alpha:1.0];
	
	buttonCategoryPower = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonSmall" withSubImageNamed:@"imageIconStorePower" 
													atScreenPercentage:CGPointMake(37.5, 7.5) isRotated:NO];
	[buttonCategoryPower setTarget:self andAction:@selector(showCategoryPower)];
	[buttonCategoryPower setButtonColourFilterRed:1.0 green:0.0 blue:1.0 alpha:1.0];
	[buttonCategoryPower setSubImageColourFilterRed:1.0 green:0.0 blue:1.0 alpha:1.0];
	
	buttonCategoryVIP = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonSmall" withText:@"NYI" 
													atScreenPercentage:CGPointMake(62.5, 7.5) isRotated:NO];
	[buttonCategoryVIP setTarget:self andAction:@selector(showCategoryVIP)];
	[buttonCategoryVIP setButtonColourFilterRed:1.0 green:1.0 blue:0.0 alpha:1.0];
	[buttonCategoryVIP setFontColourFilterRed:1.0 green:1.0 blue:0.0 alpha:1.0];
	
	buttonCategoryCurrency = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonSmall" withSubImageNamed:@"imageIconStoreCurrency" 
												   atScreenPercentage:CGPointMake(87.5, 7.5) isRotated:NO];
	[buttonCategoryCurrency setTarget:self andAction:@selector(showCategoryCurrencyCoins)];
	[buttonCategoryCurrency setButtonColourFilterRed:1.0 green:0.5 blue:0.0 alpha:1.0];
	[buttonCategoryCurrency setSubImageColourFilterRed:1.0 green:0.5 blue:0.0 alpha:1.0];
	
	buttonBuyOne = [[ButtonControl alloc] initAsButtonImageNamed:@"buttonStoreBoost1" withText:@"" 
											 atScreenPercentage:CGPointMake(36.33, 65.63) isRotated:NO];
	[buttonBuyOne setTarget:self andAction:@selector(attemptPurchaseOne)];
	NSLog(@"%F, %F", [buttonBuyOne boundingBox].size.width, [buttonBuyOne boundingBox].size.height );
	
	buttonBuyTwo = [[ButtonControl alloc] initAsButtonImageNamed:@"buttonStoreBoost5" withText:@"" 
											  atScreenPercentage:CGPointMake(63.67, 65.63) isRotated:NO];
	[buttonBuyTwo setTarget:self andAction:@selector(attemptPurchaseTwo)];
	
	buttonBuyThree = [[ButtonControl alloc] initAsButtonImageNamed:@"buttonStoreBoost25" withText:@"" 
											  atScreenPercentage:CGPointMake(36.33, 38.02) isRotated:NO];
	[buttonBuyThree setTarget:self andAction:@selector(attemptPurchaseThree)];
	
	buttonBuyFour = [[ButtonControl alloc] initAsButtonImageNamed:@"buttonStoreBoost100" withText:@"" 
											  atScreenPercentage:CGPointMake(63.67, 38.02) isRotated:NO];
	[buttonBuyFour setTarget:self andAction:@selector(attemptPurchaseFour)];
	
	NSLog(@"Loading Images...80");
	imagePreview = [[Image alloc] initWithImageNamed:@"CrystalPreview"];
	[imagePreview setPositionAtScreenPrecentage:CGPointMake(50, 58) isRotated:NO];

	NSLog(@"Loading Varibles...100");
	// Gets all items for the pet slots.
	allItems = [[NSArray alloc] initWithObjects:
				[NSArray arrayWithObjects:@"NYI",nil],
				[NSArray arrayWithObjects:@"BOOST",nil],
				[NSArray arrayWithObjects:@"NYI",nil],
				[NSArray arrayWithObjects:@"COIN",@"TREAT",nil],
				nil];
	//selectedCategoryIndex = 0;
	//selectedItemIndex = 0;
	
	[self finishLoadScene];
}

- (void) finishLoadScene
{
	NSLog(@"...Done");
	[self showCategoryCurrencyCoins];
	[self setIsInitialized:TRUE];
	[self transitioningToCurrentScene];
	[[Director sharedDirector] stopLoading];
}

- (void)transitioningToCurrentScene
{
	if(!isInitialized)
	{
		[[Director sharedDirector] startLoading];
		[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(startLoadScene) userInfo:nil repeats:NO];
	}
	[coinIndicator changeInitialValue:[[sharedSettingManager forProfileGet:ProfileKey_Coins]intValue]];
	[treatIndicator changeInitialValue:[[sharedSettingManager forProfileGet:ProfileKey_Treats]intValue]];
	[boostIndicator changeInitialValue:[[sharedSettingManager forProfileGet:ProfileKey_Boost]intValue]];
	
	[coinIndicatorCost changeInitialValue:0];
}

- (void) loadMenuScene
{
	[[Director sharedDirector] setCurrentSceneToSceneWithKey:SCENEKEY_MENU];
}

- (BOOL)canMakePurchases
{
	return [SKPaymentQueue canMakePayments];
}

- (void)finalizePurchaseNamed:(NSString*)productName
{
	if ([productName rangeOfString:@"coin"].location != NSNotFound) 
	{
		switch ([[productName substringFromIndex:[productName length] - 1] intValue]) 
		{
			case 1:
			{
				[[SettingManager sharedSettingManager] modifyCoinsBy:5000];
				[coinIndicator addValue:5000];
				break;
			}
			case 2:
			{
				[[SettingManager sharedSettingManager] modifyCoinsBy:25000];
				[coinIndicator addValue:25000];
				break;
			}
			case 3:
			{
				[[SettingManager sharedSettingManager] modifyCoinsBy:50000];
				[coinIndicator addValue:50000];
				break;
			}
			case 4:
			{
				[[SettingManager sharedSettingManager] modifyCoinsBy:200000];
				[coinIndicator addValue:200000];
				break;
			}
			default:
				break;
		}
	}
	else if ([productName rangeOfString:@"treat"].location != NSNotFound) 
	{
		switch ([[productName substringFromIndex:[productName length] - 1] intValue]) 
		{
			case 1:
			{
				[[SettingManager sharedSettingManager] modifyTreatsBy:5];
				[treatIndicator addValue:5];
				break;
			}
			case 2:
			{
				[[SettingManager sharedSettingManager] modifyTreatsBy:25];
				[treatIndicator addValue:25];
				break;
			}
			case 3:
			{
				[[SettingManager sharedSettingManager] modifyTreatsBy:50];
				[treatIndicator addValue:50];
				break;
			}
			case 4:
			{
				[[SettingManager sharedSettingManager] modifyTreatsBy:200];
				[treatIndicator addValue:200];
				break;
			}
			default:
				break;
		}
	}
	else
	{
		NSLog(@"Cannot Process Purchase: %@", productName);
	}
}

- (void) attemptInAppPurchase:(NSNotification*)productIdentifier
{
	SKPayment *payment = [SKPayment paymentWithProductIdentifier:(NSString *)[productIdentifier object]];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

/*
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    /*
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    if (wasSuccessful)
    {
        // send out a notification that we’ve finished the transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:@"STORE_PURCHASE_FINISH" object:self userInfo:userInfo];
    }
    else
    {
        // send out a notification for the failed transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:@"STORE_PURCHASE_FAILED" object:self userInfo:userInfo];
    }
	 
}
*/
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    [self finalizePurchaseNamed:transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
	NSLog(@"Transaction Success");
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    [self finalizePurchaseNamed:transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
	NSLog(@"Transaction Success");
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
		NSLog(@"Transaction Failed");
    }
    else
    {
        // this is fine, the user just cancelled, so don’t notify
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
		NSLog(@"Transaction Cancelled");
    }
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

- (void) attemptPurchase
{
	
}
- (void) attemptPurchaseOne
{
	switch (selectedCategoryIndex) 
	{
		case 1:
		{
			if([[SettingManager sharedSettingManager] modifyCoinsBy:-500])
			{
				[[SettingManager sharedSettingManager] modifyBoostBy:1];
				[coinIndicator addValue:-500];
				[boostIndicator addValue:1];
			}
			break;
		}
		case 3:
		{
			switch (selectedItemIndex) 
			{
				case 0:
				{
					[[NetworkManager sharedNetworkManager] requestProduct:@"coin" productIndex:1];
					
					//[[SettingManager sharedSettingManager] modifyCoinsBy:5000];
					//[coinIndicator addValue:5000];
					break;
				}
				case 1:
				{
					[[NetworkManager sharedNetworkManager] requestProduct:@"treat" productIndex:1];
					
					//[[SettingManager sharedSettingManager] modifyTreatsBy:5];
					//[treatIndicator addValue:5];
					break;
				}
				default:
					break;
			}
		}
		default:
			break;
	}
}
- (void) attemptPurchaseTwo
{
	switch (selectedCategoryIndex) 
	{
		case 1:
		{
			if([[SettingManager sharedSettingManager] modifyCoinsBy:-2000])
			{
				[[SettingManager sharedSettingManager] modifyBoostBy:5];
				[coinIndicator addValue:-2000];
				[boostIndicator addValue:5];
			}
			break;
		}
		case 3:
		{
			switch (selectedItemIndex) 
			{
				case 0:
				{
					[[NetworkManager sharedNetworkManager] requestProduct:@"coin" productIndex:2];
					
					//[[SettingManager sharedSettingManager] modifyCoinsBy:25000];
					//[coinIndicator addValue:25000];
					break;
				}
				case 1:
				{
					[[NetworkManager sharedNetworkManager] requestProduct:@"treat" productIndex:2];
					
					//[[SettingManager sharedSettingManager] modifyTreatsBy:25];
					//[treatIndicator addValue:25];
					break;
				}
				default:
					break;
			}
			break;
		}
		default:
			break;
	}
}
- (void) attemptPurchaseThree
{
	switch (selectedCategoryIndex) 
	{
		case 1:
		{
			if([[SettingManager sharedSettingManager] modifyCoinsBy:-3500])
			{
				[[SettingManager sharedSettingManager] modifyBoostBy:25];
				[coinIndicator addValue:-3500];
				[boostIndicator addValue:25];
			}
			break;
		}
		case 3:
		{
			switch (selectedItemIndex) 
			{
				case 0:
				{
					[[NetworkManager sharedNetworkManager] requestProduct:@"coin" productIndex:3];
					
					//[[SettingManager sharedSettingManager] modifyCoinsBy:50000];
					//[coinIndicator addValue:50000];
					break;
				}
				case 1:
				{
					[[NetworkManager sharedNetworkManager] requestProduct:@"treat" productIndex:3];
					
					//[[SettingManager sharedSettingManager] modifyTreatsBy:50];
					//[treatIndicator addValue:50];
					break;
				}
				default:
					break;
			}
			break;
		}
		default:
			break;
	}
}
- (void) attemptPurchaseFour
{
	switch (selectedCategoryIndex) 
	{
		case 1:
		{
			//if([[SettingManager sharedSettingManager] modifyCoinsBy:-7500])
			//{
				[[SettingManager sharedSettingManager] modifyBoostBy:100];
			//	[coinIndicator addValue:-7500];
				[boostIndicator addValue:100];
			//}
			break;
		}
		case 3:
		{
			switch (selectedItemIndex) 
			{
				case 0:
				{
					[[NetworkManager sharedNetworkManager] requestProduct:@"coin" productIndex:4];
					
					//[[SettingManager sharedSettingManager] modifyCoinsBy:200000];
					//[coinIndicator addValue:200000];
					break;
				}
				case 1:
				{
					[[NetworkManager sharedNetworkManager] requestProduct:@"treat" productIndex:4];
					
					//[[SettingManager sharedSettingManager] modifyTreatsBy:200];
					//[treatIndicator addValue:200];
					break;
				}
				default:
					break;
			}
			break;
		}
		default:
			break;
	}
}

- (void) showNext
{
	if([[allItems objectAtIndex:selectedCategoryIndex] count] <= 1)
		return;
	
	// Increases the selected item index by 1, loops if needed
	selectedItemIndex++;
	if (selectedItemIndex > [[allItems objectAtIndex:selectedCategoryIndex] count] - 1) 
		selectedItemIndex = 0;
	
	[self reloadCategory];
}

- (void) showPrevious
{
	if([[allItems objectAtIndex:selectedCategoryIndex] count] <= 1)
		return;
	
	// Increases the selected item index by 1, loops if needed
	selectedItemIndex--;
	if (selectedItemIndex < 0) 
		selectedItemIndex = [[allItems objectAtIndex:selectedCategoryIndex] count] - 1;
	
	[self reloadCategory];
}

- (void) showCategoryGame
{
	[buttonCategoryGame setFontColourFilterRed:1.0 green:1.0 blue:1.0 alpha:1.0];
	[buttonCategoryPower setSubImageColourFilterRed:1.0 green:0.0 blue:1.0 alpha:1.0];
	[buttonCategoryCurrency setSubImageColourFilterRed:1.0 green:0.5 blue:0.0 alpha:1.0];
	[buttonCategoryVIP setFontColourFilterRed:1.0 green:1.0 blue:0.0 alpha:1.0];
	selectedCategoryIndex = 0;
	selectedItemIndex = 0;
	[self reloadScene];
}

- (void) showCategoryPower
{
	[buttonCategoryGame setFontColourFilterRed:1.0 green:0.0 blue:0.0 alpha:1.0];
	[buttonCategoryPower setSubImageColourFilterRed:1.0 green:1.0 blue:1.0 alpha:1.0];
	[buttonCategoryCurrency setSubImageColourFilterRed:1.0 green:0.5 blue:0.0 alpha:1.0];
	[buttonCategoryVIP setFontColourFilterRed:1.0 green:1.0 blue:0.0 alpha:1.0];
	selectedCategoryIndex = 1;
	selectedItemIndex = 0;
	[self reloadScene];
}

- (void) showCategoryVIP
{
	[buttonCategoryGame setFontColourFilterRed:1.0 green:0.0 blue:0.0 alpha:1.0];
	[buttonCategoryPower setSubImageColourFilterRed:1.0 green:0.0 blue:1.0 alpha:1.0];
	[buttonCategoryCurrency setSubImageColourFilterRed:1.0 green:0.5 blue:0.0 alpha:1.0];
	[buttonCategoryVIP setFontColourFilterRed:1.0 green:1.0 blue:1.0 alpha:1.0];
	selectedCategoryIndex = 2;
	selectedItemIndex = 0;
	[self reloadScene];
}

- (void) showCategoryCurrency
{
	[buttonCategoryGame setFontColourFilterRed:1.0 green:0.0 blue:0.0 alpha:1.0];
	[buttonCategoryPower setSubImageColourFilterRed:1.0 green:0.0 blue:1.0 alpha:1.0];
	[buttonCategoryCurrency setSubImageColourFilterRed:1.0 green:1.0 blue:1.0 alpha:1.0];
	[buttonCategoryVIP setFontColourFilterRed:1.0 green:1.0 blue:0.0 alpha:1.0];
	selectedCategoryIndex = 3;
	[self reloadScene];
}

- (void) showCategoryCurrencyCoins
{
	selectedItemIndex = 0;
	[self showCategoryCurrency];
}
- (void) showCategoryCurrencyTreats
{
	selectedItemIndex = 1;
	[self showCategoryCurrency];
}

- (void) reloadScene
{
	if([[allItems objectAtIndex:selectedCategoryIndex] count] > 1)
	{
		[buttonNext setEnabled:YES];
		[buttonPrevious setEnabled:YES];
	}
	else
	{
		[buttonNext setEnabled:NO];
		[buttonPrevious setEnabled:NO];
	}
	switch (selectedCategoryIndex) 
	{
		case 0:
		{
			[labelCategory setText:@"Game Extras (NNF)" atSceenPercentage:CGPointMake(50, 81.5)];
			[labelDescription setText:@"Awesome little extras!" atSceenPercentage:CGPointMake(50, 19)];
			[coinIndicatorCost setIsEnabled:NO];
			[treatIndicatorCost setIsEnabled:NO];
			[buttonBuy setEnabled:NO];
			[buttonBuyOne setEnabled:NO];
			[buttonBuyTwo setEnabled:NO];
			[buttonBuyThree setEnabled:NO];
			[buttonBuyFour setEnabled:NO];
			break;
		}
		case 1:
		{
			[labelCategory setText:@"Power Ups" atSceenPercentage:CGPointMake(50, 81.5)];
			[labelDescription setText:@"Use Boost to summon your SpaceShip!" atSceenPercentage:CGPointMake(50, 19)];
			[coinIndicatorCost setIsEnabled:NO];
			[treatIndicatorCost setIsEnabled:NO];
			[buttonBuy setEnabled:NO];
			[buttonBuyOne setEnabled:YES];
			[buttonBuyTwo setEnabled:YES];
			[buttonBuyThree setEnabled:YES];
			[buttonBuyFour setEnabled:YES];
			break;
		}
		case 2:
		{
			[labelCategory setText:@"VIP Area (NNF)" atSceenPercentage:CGPointMake(50, 81.5)];
			[labelDescription setText:@"Very Important People Only!" atSceenPercentage:CGPointMake(50, 19)];
			[coinIndicatorCost setIsEnabled:YES];
			[treatIndicatorCost setIsEnabled:YES];
			[buttonBuy setEnabled:YES];
			[buttonBuyOne setEnabled:NO];
			[buttonBuyTwo setEnabled:NO];
			[buttonBuyThree setEnabled:NO];
			[buttonBuyFour setEnabled:NO];
			break;
		}
		case 3:
		{
			[labelCategory setText:@"Coins and Treats" atSceenPercentage:CGPointMake(50, 81.5)];
			[labelDescription setText:@"Use Coins and Treats to Unlock Stuff!" atSceenPercentage:CGPointMake(50, 19)];
			[coinIndicatorCost setIsEnabled:NO];
			[treatIndicatorCost setIsEnabled:NO];
			[buttonBuy setEnabled:NO];
			[buttonBuyOne setEnabled:YES];
			[buttonBuyTwo setEnabled:YES];
			[buttonBuyThree setEnabled:YES];
			[buttonBuyFour setEnabled:YES];
			break;
		}
		default:
			break;
	}
	[self reloadCategory];
}

- (void) reloadCategory
{
	switch (selectedCategoryIndex) 
	{
		case 0:
		{
			break;
		}
		case 1:
		{
			switch (selectedItemIndex) 
			{
				case 0:
				{
					[buttonBuyOne setButtonImage:@"buttonStoreBoost1" withSelectionImage:NO];
					[buttonBuyTwo setButtonImage:@"buttonStoreBoost5" withSelectionImage:NO];
					[buttonBuyThree setButtonImage:@"buttonStoreBoost25" withSelectionImage:NO];
					[buttonBuyFour setButtonImage:@"buttonStoreBoost100" withSelectionImage:NO];
					break;
				}
				default:
					break;
			}
			break;
		}
		case 2:
		{
			break;
		}
		case 3:
		{
			switch (selectedItemIndex) 
			{
				case 0:
				{
					[buttonBuyOne setButtonImage:@"buttonStoreCoin1" withSelectionImage:NO];
					[buttonBuyTwo setButtonImage:@"buttonStoreCoin2" withSelectionImage:NO];
					[buttonBuyThree setButtonImage:@"buttonStoreCoin3" withSelectionImage:NO];
					[buttonBuyFour setButtonImage:@"buttonStoreCoin4" withSelectionImage:NO];
					break;
				}
				case 1:
				{
					[buttonBuyOne setButtonImage:@"buttonStoreTreat1" withSelectionImage:NO];
					[buttonBuyTwo setButtonImage:@"buttonStoreTreat2" withSelectionImage:NO];
					[buttonBuyThree setButtonImage:@"buttonStoreTreat3" withSelectionImage:NO];
					[buttonBuyFour setButtonImage:@"buttonStoreTreat4" withSelectionImage:NO];
					break;
				}
				default:
					break;
			}
			
			break;
		}
		default:
			break;
	}
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
			[coinIndicator updateWithDelta:aDelta];
			[treatIndicator updateWithDelta:aDelta];
			[boostIndicator updateWithDelta:aDelta];
			[coinIndicatorCost updateWithDelta:aDelta];
			[treatIndicatorCost updateWithDelta:aDelta];
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
			NSLog(@"ERROR: StoreScene has no valid state.");
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
			[buttonBack touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
			[buttonPrevious touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
			[buttonNext touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
			[buttonBuy touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
			[buttonCategoryGame touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
			[buttonCategoryPower touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
			[buttonCategoryVIP touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
			[buttonCategoryCurrency touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
			
			[buttonBuyOne touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
			[buttonBuyTwo touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
			[buttonBuyThree touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
			[buttonBuyFour touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
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
			NSLog(@"ERROR: StoreScene has no valid state.");
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
			[buttonBack touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			[buttonPrevious touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			[buttonNext touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			[buttonBuy touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			[buttonCategoryGame touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			[buttonCategoryPower touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			[buttonCategoryVIP touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			[buttonCategoryCurrency touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			
			[buttonBuyOne touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			[buttonBuyTwo touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			[buttonBuyThree touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			[buttonBuyFour touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
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
			NSLog(@"ERROR: StoreScene has no valid state.");
			break;
		}
	}
}

- (void)updateWithTouchLocationEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView 
{
	if(!isInitialized)
		return;
	
	[super updateWithTouchLocationEnded:touches withEvent:event view:aView];
	
	switch (sceneState) 
	{
			// The Scene is in the forefront and running.
		case SceneState_Running:
		{
			[buttonBack touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			[buttonPrevious touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			[buttonNext touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			[buttonBuy touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			[buttonCategoryGame touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			[buttonCategoryPower touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			[buttonCategoryVIP touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			[buttonCategoryCurrency touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			
			[buttonBuyOne touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			[buttonBuyTwo touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			[buttonBuyThree touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			[buttonBuyFour touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
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
			NSLog(@"ERROR: StoreScene has no valid state.");
			break;
		}
	}
}

- (void)updateWithAccelerometer:(UIAcceleration*)aAcceleration 
{
	if(!isInitialized)
		return;
	
	[super updateWithAccelerometer:aAcceleration];
}

- (void)render 
{
	if(!isInitialized)
		return;
	
	glPushMatrix();
	switch (sceneState) 
	{
			// The Scene is in the forefront and running.
		case SceneState_Running:
		{
			[buttonBack render];
			[buttonPrevious render];
			[buttonNext render];
			[buttonBuy render];
			[buttonCategoryGame render];
			[buttonCategoryPower render];
			[buttonCategoryVIP render];
			[buttonCategoryCurrency render];
			
			[buttonBuyOne render];
			[buttonBuyTwo render];
			[buttonBuyThree render];
			[buttonBuyFour render];
			
			[coinIndicator render];
			[treatIndicator render];
			[boostIndicator render];
			[coinIndicatorCost render];
			[treatIndicatorCost render];
			
			[labelCategory render];
			[labelDescription render];
			
			//[imagePreview render];
			
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
			NSLog(@"ERROR: StoreScene has no valid state.");
			break;
		}
	}
	glPopMatrix();
}

@end
