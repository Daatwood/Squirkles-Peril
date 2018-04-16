//
//  Tutorial1AppDelegate.m
//  Tutorial1
//
//  Created by Dustin Atwood on 28/02/2009.
//  Copyright Dustin Atwood 2009. All rights reserved.
//

#import "OGLGameAppDelegate.h"
//#import "EAGLView.h"
#import "LoadingViewController.h"
#import "Director.h"

@implementation OGLGameAppDelegate


- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
    
	// Not using any NIB files anymore, we are creating the window and the
    // EAGLView manually.
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[window setUserInteractionEnabled:YES];
	[window setMultipleTouchEnabled:YES];
	
	//glView = [[[EAGLView alloc] initWithFrame:[UIScreen mainScreen].bounds] retain];
	loadingView = [[LoadingViewController alloc] init];
	
    // Add the glView to the window which has been defined
	[window addSubview:loadingView.view];
    [window setRootViewController:loadingView];
	[window makeKeyAndVisible];

	[loadingView displayLoadingScreen];
    
	// Since OS 3.0, just calling [glView mainGameLoop] did not work, you just got a black screen.
    // It appears that others have had the same problem and to fix it you need to use the 
    // performSelectorOnMainThread call below.
    //[glView performSelectorOnMainThread:@selector(mainGameLoop) withObject:nil waitUntilDone:NO]; 
}


- (void)applicationWillResignActive:(UIApplication *)application 
{
	//[[SettingManager sharedSettingManager] saveProfile];
	//[[[Director sharedDirector] currentScene] setSceneState:SceneState_Paused];]
	NSLog(@"Will Resign Active");
	[[NSNotificationCenter defaultCenter] postNotificationName:@"APPLICATION_RESIGN_ACTIVE" object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application 
{
	//[[SettingManager sharedSettingManager] saveProfile];
	NSLog(@"Will Terminate");
	[[NSNotificationCenter defaultCenter] postNotificationName:@"APPLICATION_WILL_TERMINATE" object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application 
{
	//[[[Director sharedDirector] currentScene] setSceneState:SceneState_Running];
	NSLog(@"Did Become Active");
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DID_BECOME_ACTIVE" object:nil];
}


- (void)dealloc {
	[window release];
	//[glView release];
	[loadingView release];
	[super dealloc];
}

@end
