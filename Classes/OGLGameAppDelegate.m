//
//  Tutorial1AppDelegate.m
//  Tutorial1
//
//  Created by Michael Daley on 28/02/2009.
//  Copyright Michael Daley 2009. All rights reserved.
//

#import "OGLGameAppDelegate.h"
#import "LoadingViewController.h"
#import "Director.h"
#import "mtiks.h"
@implementation OGLGameAppDelegate


- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
    application.idleTimerDisabled = YES; // we don't want the screen to sleep during our game 
    [[mtiks sharedSession] start:MTIKS_KEY];

    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[window setUserInteractionEnabled:YES];
	[window setMultipleTouchEnabled:YES];
    loadingView = [[LoadingViewController alloc] init];
	[window addSubview:loadingView.view];
	[window makeKeyAndVisible];
	[loadingView displayLoadingScreen];
}


- (void)applicationWillResignActive:(UIApplication *)application 
{
    [[mtiks sharedSession] stop];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"APPLICATION_RESIGN_ACTIVE" object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application 
{
    [[mtiks sharedSession] stop];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"APPLICATION_WILL_TERMINATE" object:nil]; 
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[mtiks sharedSession] start:MTIKS_KEY];
    NSLog(@"Will enter foreground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application 
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DID_BECOME_ACTIVE" object:nil];
}


- (void)dealloc 
{
	[window release];
	[loadingView release];
	[super dealloc];
}

@end
