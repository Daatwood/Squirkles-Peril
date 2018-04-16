//
//  NetworkManager.h
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 1/28/11.
//  Copyright 2011 Dustin Atwood. All rights reserved.
//

/*
	The Shared network manager is in-charge of Facebook, Twitter, News Feed
 and In-App purchasing.
 
 
 
*/

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
#import "Common.h"
#import <StoreKit/StoreKit.h>

@interface NetworkManager : NSObject <SKProductsRequestDelegate>
{
	NSMutableData *responseData;
	NSString* latestNewsFeed;
	
	SKProduct *proUpgradeProduct;
    SKProductsRequest *productsRequest;
	
	BOOL awaitingInAppResponse;
}

@property(nonatomic, copy)NSString* latestNewsFeed;

+ (NetworkManager*)sharedNetworkManager;

- (void) fetchNewsFeed;

- (void) requestProduct:(NSString*)productName productIndex:(int)productIndex;

@end
