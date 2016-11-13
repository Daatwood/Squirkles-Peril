//
//  StoreScene.m
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 2/8/11.
//  Copyright 2011 Litlapps. All rights reserved.
//

#import "StoreScene.h"

#define Button_Prev 1
#define Button_Next 2
#define Button_Game 3
#define Button_Boost 4
#define Button_VIP 5
#define Button_Coin 6

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
	ButtonControl* button;
	
	button = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonSmall" withText:@"Back" withFontName:FONT21 
											atScreenPercentage:CGPointMake(18.75, 93.54)];
	[button setTarget:self andAction:@selector(loadMenuScene)];
	[button setButtonColourFilterRed:1.0 green:0.0 blue:0.0 alpha:1.0];
	[button setIdentifier:Button_Cancel];
	[[super sceneControls] addObject:button];
	[button release];
	
	button = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonSmall" withSubImageNamed:@"buttonPreviousArrow" 
												atScreenPercentage:CGPointMake(10.5, 56.67)];
	[button setTarget:self andAction:@selector(showNext)];
	[button	setButtonColourFilterRed:0.5 green:0.5 blue:1.0 alpha:1.0];
	CGRect newSize = [button boundingBox];
	newSize.size = CGSizeMake(67.5, 185);
	button.boundingBox = newSize;
	[button setIdentifier:Button_Next];
	[[super sceneControls] addObject:button];
	[button release];
	
	button = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonSmall" withSubImageNamed:@"buttonNextArrow" 
												atScreenPercentage:CGPointMake(89.5, 56.67)];
	[button setTarget:self andAction:@selector(showPrevious)];
	[button	setButtonColourFilterRed:0.5 green:0.5 blue:1.0 alpha:1.0];
	newSize = [button boundingBox];
	newSize.size = CGSizeMake(67.5, 185);
	button.boundingBox = newSize;
	[button setIdentifier:Button_Prev];
	[[super sceneControls] addObject:button];
	[button release];
	
	button = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonNormal" withText:@"Purchase" withFontName:FONT21
											  atScreenPercentage:CGPointMake(78, 30)];
	[button setTarget:self andAction:@selector(attemptPurchase)];
	[button setButtonColourFilterRed:0.0 green:1.0 blue:0.0 alpha:1.0];
	[button setIdentifier:Button_Action];
	[[super sceneControls] addObject:button];
	[button release];
	
	
	button = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonSmall" withText:@"NYI" withFontName:FONT21
										   atScreenPercentage:CGPointMake(12.5, 7.5)];
	[button setTarget:self andAction:@selector(showCategoryGame)];
	[button setButtonColourFilterRed:1.0 green:0.0 blue:0.0 alpha:1.0];
	[button setFontColourFilterRed:1.0 green:0.0 blue:0.0 alpha:1.0];
	[button setIdentifier:Button_Game];
	[[super sceneControls] addObject:button];
	[button release];
	
	button = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonSmall" withSubImageNamed:@"imageIconStorePower" 
													atScreenPercentage:CGPointMake(37.5, 7.5)];
	[button setTarget:self andAction:@selector(showCategoryPower)];
	[button setButtonColourFilterRed:1.0 green:0.0 blue:1.0 alpha:1.0];
	[button setImageColourFilterRed:1.0 green:0.0 blue:1.0 alpha:1.0];
	[button setIdentifier:Button_Boost];
	[[super sceneControls] addObject:button];
	[button release];
	
	button = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonSmall" withText:@"NYI" withFontName:FONT21
													atScreenPercentage:CGPointMake(62.5, 7.5)];
	[button setTarget:self andAction:@selector(showCategoryVIP)];
	[button setButtonColourFilterRed:1.0 green:1.0 blue:0.0 alpha:1.0];
	[button setFontColourFilterRed:1.0 green:1.0 blue:0.0 alpha:1.0];
	[button setIdentifier:Button_VIP];
	[[super sceneControls] addObject:button];
	[button release];
	
	button = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonSmall" withSubImageNamed:@"imageIconStoreCurrency" 
												   atScreenPercentage:CGPointMake(87.5, 7.5)];
	[button setTarget:self andAction:@selector(showCategoryCurrencyCoins)];
	[button setButtonColourFilterRed:1.0 green:0.5 blue:0.0 alpha:1.0];
	[button setImageColourFilterRed:1.0 green:0.5 blue:0.0 alpha:1.0];
	[button setIdentifier:Button_Coin];
	[[super sceneControls] addObject:button];
	[button release];
	
	buttonBuyOne = [[ButtonControl alloc] initAsButtonImageNamed:@"buttonStoreBoost1" withText:@"" withFontName:FONT21
											 atScreenPercentage:CGPointMake(36.33, 65.63)];
	[buttonBuyOne setTarget:self andAction:@selector(attemptPurchaseOne)];
	
	buttonBuyTwo = [[ButtonControl alloc] initAsButtonImageNamed:@"buttonStoreBoost5" withText:@"" withFontName:FONT21
											  atScreenPercentage:CGPointMake(63.67, 65.63)];
	[buttonBuyTwo setTarget:self andAction:@selector(attemptPurchaseTwo)];
	
	buttonBuyThree = [[ButtonControl alloc] initAsButtonImageNamed:@"buttonStoreBoost25" withText:@"" withFontName:FONT21
											  atScreenPercentage:CGPointMake(36.33, 38.02)];
	[buttonBuyThree setTarget:self andAction:@selector(attemptPurchaseThree)];
	
	buttonBuyFour = [[ButtonControl alloc] initAsButtonImageNamed:@"buttonStoreBoost100" withText:@"" withFontName:FONT21
											  atScreenPercentage:CGPointMake(63.67, 38.02)];
	[buttonBuyFour setTarget:self andAction:@selector(attemptPurchaseFour)];
	
	NSLog(@"Loading Images...80");
	imagePreview = [[Image alloc] initWithImageNamed:@"CrystalPreview"];
	[imagePreview setPositionAtScreenPrecentage:CGPointMake(50, 58)];

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
	[coinIndicator changeInitialValue:[[sharedSettingManager for:FileType_Player get:ProfileKey_Coins]intValue]];
	[boostIndicator changeInitialValue:[[sharedSettingManager for:FileType_Player get:ProfileKey_Boost]intValue]];
	
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
	/*
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
	 */
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
	/*
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
	 */
}
- (void) attemptPurchaseTwo
{
	/*
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
	 */
}
- (void) attemptPurchaseThree
{
	/*
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
	 */
}
- (void) attemptPurchaseFour
{
	/*
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
	 */
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
	[[super control:Button_Game] setFontColourFilterRed:1.0 green:1.0 blue:1.0 alpha:1.0];
	[[super control:Button_Boost] setImageColourFilterRed:1.0 green:0.0 blue:1.0 alpha:1.0];
	[[super control:Button_Coin] setImageColourFilterRed:1.0 green:0.5 blue:0.0 alpha:1.0];
	[[super control:Button_VIP] setFontColourFilterRed:1.0 green:1.0 blue:0.0 alpha:1.0];
	selectedCategoryIndex = 0;
	selectedItemIndex = 0;
	[self reloadScene];
}

- (void) showCategoryPower
{
	[[super control:Button_Game] setFontColourFilterRed:1.0 green:0.0 blue:0.0 alpha:1.0];
	[[super control:Button_Boost] setImageColourFilterRed:1.0 green:1.0 blue:1.0 alpha:1.0];
	[[super control:Button_Coin] setImageColourFilterRed:1.0 green:0.5 blue:0.0 alpha:1.0];
	[[super control:Button_VIP] setFontColourFilterRed:1.0 green:1.0 blue:0.0 alpha:1.0];
	selectedCategoryIndex = 1;
	selectedItemIndex = 0;
	[self reloadScene];
}

- (void) showCategoryVIP
{
	[[super control:Button_Game] setFontColourFilterRed:1.0 green:0.0 blue:0.0 alpha:1.0];
	[[super control:Button_Boost] setImageColourFilterRed:1.0 green:0.0 blue:1.0 alpha:1.0];
	[[super control:Button_Coin] setImageColourFilterRed:1.0 green:0.5 blue:0.0 alpha:1.0];
	[[super control:Button_VIP] setFontColourFilterRed:1.0 green:1.0 blue:1.0 alpha:1.0];
	selectedCategoryIndex = 2;
	selectedItemIndex = 0;
	[self reloadScene];
}

- (void) showCategoryCurrency
{
	[[super control:Button_Game] setFontColourFilterRed:1.0 green:0.0 blue:0.0 alpha:1.0];
	[[super control:Button_Boost] setImageColourFilterRed:1.0 green:0.0 blue:1.0 alpha:1.0];
	[[super control:Button_Coin] setImageColourFilterRed:1.0 green:1.0 blue:1.0 alpha:1.0];
	[[super control:Button_VIP] setFontColourFilterRed:1.0 green:1.0 blue:0.0 alpha:1.0];
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
		[[super control:Button_Next] setEnabled:YES];
		[[super control:Button_Prev] setEnabled:YES];
	}
	else
	{
		[[super control:Button_Next] setVisible:NO];
		[[super control:Button_Prev] setVisible:NO];
	}
	switch (selectedCategoryIndex) 
	{
		case 0:
		{
			[labelCategory setText:@"Game Extras" atSceenPercentage:CGPointMake(50, 81.5)];
			[labelDescription setText:@"Further Customize your Squirkle!" atSceenPercentage:CGPointMake(50, 19)];
			[coinIndicatorCost setIsEnabled:NO];
			[treatIndicatorCost setIsEnabled:NO];
			[[super control:Button_Action] setVisible:NO];
			[buttonBuyOne setVisible:NO];
			[buttonBuyTwo setVisible:NO];
			[buttonBuyThree setVisible:NO];
			[buttonBuyFour setVisible:NO];
			break;
		}
		case 1:
		{
			[labelCategory setText:@"Power Ups" atSceenPercentage:CGPointMake(50, 81.5)];
			[labelDescription setText:@"Use Boost to summon your SpaceShip!" atSceenPercentage:CGPointMake(50, 19)];
			[coinIndicatorCost setIsEnabled:NO];
			[treatIndicatorCost setIsEnabled:NO];
			[[super control:Button_Action] setVisible:NO];
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
			[[super control:Button_Action] setEnabled:YES];
			[buttonBuyOne setVisible:NO];
			[buttonBuyTwo setVisible:NO];
			[buttonBuyThree setVisible:NO];
			[buttonBuyFour setVisible:NO];
			break;
		}
		case 3:
		{
			[labelCategory setText:@"Coins and Treats" atSceenPercentage:CGPointMake(50, 81.5)];
			[labelDescription setText:@"Use Coins and Treats to Unlock Stuff!" atSceenPercentage:CGPointMake(50, 19)];
			[coinIndicatorCost setIsEnabled:NO];
			[treatIndicatorCost setIsEnabled:NO];
			[[super control:Button_Action] setVisible:NO];
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
					[buttonBuyOne setButtonImageNamed:@"buttonStoreBoost1" withSubImageNamed:nil];
					[buttonBuyTwo setButtonImageNamed:@"buttonStoreBoost5" withSubImageNamed:nil];
					[buttonBuyThree setButtonImageNamed:@"buttonStoreBoost25" withSubImageNamed:nil];
					[buttonBuyFour setButtonImageNamed:@"buttonStoreBoost100" withSubImageNamed:nil];
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
					[buttonBuyOne setButtonImageNamed:@"buttonStoreCoin1" withSubImageNamed:nil];
					[buttonBuyTwo setButtonImageNamed:@"buttonStoreCoin2" withSubImageNamed:nil];
					[buttonBuyThree setButtonImageNamed:@"buttonStoreCoin3" withSubImageNamed:nil];
					[buttonBuyFour setButtonImageNamed:@"buttonStoreCoin4" withSubImageNamed:nil];
					break;
				}
				case 1:
				{
					[buttonBuyOne setButtonImageNamed:@"buttonStoreTreat1" withSubImageNamed:nil];
					[buttonBuyTwo setButtonImageNamed:@"buttonStoreTreat2" withSubImageNamed:nil];
					[buttonBuyThree setButtonImageNamed:@"buttonStoreTreat3" withSubImageNamed:nil];
					[buttonBuyFour setButtonImageNamed:@"buttonStoreTreat4" withSubImageNamed:nil];
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
	if(!isInitialized)
		return;
	
	glPushMatrix();

	switch (sceneState) 
	{
			// The Scene is in the forefront and running.
		case SceneState_Running:
		{
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
	
	[super render];
	
	glPopMatrix();
}

@end
