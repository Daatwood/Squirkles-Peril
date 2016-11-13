//
//  StoreScene.h
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 2/8/11.
//  Copyright 2011 Litlapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractScene.h"
#import "Common.h"
#import "ButtonControl.h"
#import "LabelControl.h"
#import "Indicator.h"
#import "Image.h"
#import "NetworkManager.h"

@interface StoreScene : AbstractScene <SKPaymentTransactionObserver>
{	
	// For Multi Item
	ButtonControl* buttonBuyOne;
	ButtonControl* buttonBuyTwo;
	ButtonControl* buttonBuyThree;
	ButtonControl* buttonBuyFour;
	
	LabelControl* labelCategory;
	LabelControl* labelDescription;
	LabelControl* labelCost;
	
	Image* imageCurrencyCost;
	Image* imagePreview;
	
	Indicator* coinIndicator;
	Indicator* treatIndicator;
	Indicator* boostIndicator;
	Indicator* coinIndicatorCost;
	Indicator* treatIndicatorCost;
	
	NSArray* allItems;
	int selectedItemIndex;
	int selectedCategoryIndex;
}

- (void) loadMenuScene;

- (BOOL)canMakePurchases;
- (void)finalizePurchaseNamed:(NSString*)productName;

- (void) attemptInAppPurchase:(NSNotification*)productIdentifier;

- (void) attemptPurchase;
- (void) attemptPurchaseOne;
- (void) attemptPurchaseTwo;
- (void) attemptPurchaseThree;
- (void) attemptPurchaseFour;

- (void) showNext;
- (void) showPrevious;

- (void) showCategoryGame;
- (void) showCategoryPower;
- (void) showCategoryVIP;
- (void) showCategoryCurrency;

- (void) showCategoryCurrencyCoins;
- (void) showCategoryCurrencyTreats;

- (void) reloadScene;

- (void) reloadCategory;
@end
