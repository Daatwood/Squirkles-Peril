//
//  NetworkManager.m
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 1/28/11.
//  Copyright 2011 Dustin Atwood. All rights reserved.
//

#import "NetworkManager.h"
#import "JSON.h"

@implementation NetworkManager

@synthesize latestNewsFeed;

// Make this class a singleton class
SYNTHESIZE_SINGLETON_FOR_CLASS(NetworkManager);

- (id)init 
{
	NSLog(@"Network Manager Initializing...");
	[self setLatestNewsFeed:@""];
	[self fetchNewsFeed];
	awaitingInAppResponse = FALSE;
	return self;
}

- (void) fetchNewsFeed
{
	responseData = [[NSMutableData data] retain];
	NSURLRequest *request = [NSURLRequest requestWithURL:
							 [NSURL URLWithString:@"http://api.twitter.com/1/statuses/user_timeline.json?screen_name=SquirklePeril&include_entities=false&trim_user=true&count=1"]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response 
{
	[responseData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
	[responseData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
	
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[responseData release];
	
	[self setLatestNewsFeed:[[[responseString JSONValue] objectAtIndex:0] objectForKey:@"text"]];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"NEWS_FEED_LOADED" object:nil];
	//NSLog(@"News Feed Recieved");
}

- (void) requestProduct:(NSString*)productName productIndex:(int)productIndex;
{
	if(awaitingInAppResponse)
	{
		//NSLog(@"Still Processing Request...");
		return;
	}
	
	NSLog(@"Sending product id: %@" , [NSString stringWithFormat:@"com.atwooddustin.squirkle.%@.%D", productName, productIndex]);
    NSSet *productIdentifiers = [NSSet setWithObject:
								 [NSString stringWithFormat:@"com.atwooddustin.squirkle.%@.%D", productName, productIndex]];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
	awaitingInAppResponse = TRUE;
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *products = response.products;
	//SKProduct* returnedProduct = [products count] == 1 ? [[products firstObject] retain] : nil;
    if ([products count] >= 1)
    {
       // NSLog(@"Product title: %@" , [[products objectAtIndex:0] localizedTitle]);
       // NSLog(@"Product description: %@" , [[products objectAtIndex:0] localizedDescription]);
       // NSLog(@"Product price: %@" , [[products objectAtIndex:0] price]);
        //NSLog(@"Product id: %@" , [[products objectAtIndex:0] productIdentifier]);
		[[NSNotificationCenter defaultCenter] postNotificationName:@"NETWORK_RECIEVED_PRODUCT" object:[[products objectAtIndex:0] productIdentifier] userInfo:nil];
    }
    
    for (NSString *invalidProductId in response.invalidProductIdentifiers)
    {
        NSLog(@"Invalid product id: %@" , invalidProductId);
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:@"This In-App Purchase cannot be made." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];
    }
    
    // finally release the reqest we alloc/init’ed in requestProUpgradeProductData
	 [productsRequest release];
	awaitingInAppResponse = FALSE;
    
    
}

@end
