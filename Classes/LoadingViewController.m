    //
//  ButtonViewController.m
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 6/20/10.
//  Copyright 2010 Dustin Atwood. All rights reserved.
//

#import "LoadingViewController.h"
#import "EAGLView.h"

@implementation LoadingViewController
BOOL loadingScreenStarted;

/*/
 While the application is loading itself into memory display a default image,
 Once the application is loaded take that default image and set it as the
 background of the application. Then display a progress circle until the
 splash screen is loaded then display it for 3 seconds or until a touch is
 recieved at which point remove the splash screen and display a loading screen
 with a progress circle again then begin loading the glView. Once glView is
 loaded remove the loading screen. At which point the current view stacks should
 be Window->This->glView. This begining the main view controller of the application.
 Followed by glView which has a game view controller managing everything under that.
/*/

// Begin loading the hierachy of screens to be displayed,
- (void)viewDidLoad
{
	[super viewDidLoad];
    NSLog(@"LoadingView DidLoad");
	
	// Set the default color of the view to black, for loading screen purposes
	[self.view setBackgroundColor:[UIColor blackColor]];
	loadingScreenStarted = NO;
	// Setup and display the background image, for preloading screen purposes
	//backgroundImage = [[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"LoadingScreen.png"]] retain];
	backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:
														  [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Default.png"]]];
	//backgroundImage = [UIImage imageNamed:@"LoadingScreen.png"];
	//UIImage *image = [UIImage imageNamed:@"LoadingScreen.png"];
	//UIImageView *image = [[UIImageView imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"LoadingScreen.png"]] retain];
	[self.view addSubview:backgroundImage];
	
	[[Director sharedDirector] setBackgroundSpinner:
	 [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loadingBackground.png"]]];
	[[Director sharedDirector] backgroundSpinner].frame = CGRectMake(0, 0, 320, 480);
	//[[Director sharedDirector] backgroundSpinner].frame = CGRectMake(10, 180, 300, 90);
	[[Director sharedDirector] setIndicatorSpinner:
	 [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loadingProgress0.png"]]];
	
	[[Director sharedDirector] indicatorSpinner].animationImages = [NSArray arrayWithObjects:
																	[UIImage imageNamed:@"loadingProgress0.png"],
																	[UIImage imageNamed:@"loadingProgress1.png"],
																	[UIImage imageNamed:@"loadingProgress2.png"],
																	[UIImage imageNamed:@"loadingProgress3.png"],
																	[UIImage imageNamed:@"loadingProgress5.png"],
																	[UIImage imageNamed:@"loadingProgress6.png"],
																	[UIImage imageNamed:@"loadingProgress7.png"],
																	[UIImage imageNamed:@"loadingProgress8.png"],
																	[UIImage imageNamed:@"loadingProgress9.png"],
																	[UIImage imageNamed:@"loadingProgress10.png"],
																	nil];
	[[Director sharedDirector] indicatorSpinner].animationDuration = 1.5;
	//[[[Director sharedDirector] indicatorSpinner] setBackgroundColor:[UIColor clearColor]];
	[[Director sharedDirector] indicatorSpinner].frame = CGRectMake(32.5, 240, 255, 30);
	//[[Director sharedDirector] indicatorSpinner].tag  = 1;
	[[[Director sharedDirector] backgroundSpinner] addSubview:[[Director sharedDirector] indicatorSpinner]];
	[self.view addSubview:[[Director sharedDirector] backgroundSpinner]];
	// Begin animating because soon the splash screen will be loaded. Once loaded will stop animating
	[[Director sharedDirector] startLoading];
	//[[[Director sharedDirector] indicatorSpinner] startAnimating];
	
	//loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(320 / 2 - 40, 480 - 325, 80, 50)];
	//[loadingLabel setText:@"Loading"]; 
	//[loadingLabel setTextColor:[UIColor whiteColor]];
	//[loadingLabel setBackgroundColor:[UIColor blackColor]];
	
	
	//[self.view addSubview:loadingLabel];
	
}

// Setup and display the Splashscreen
- (void) displaySplashScreen
{
	NSLog(@"Displaying Splash Screen");
	// Init the splashScreen
	splashScreen = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	// If pressed early just hide it.
	[splashScreen addTarget:self action:@selector(hideSplashScreen) forControlEvents:UIControlEventAllEvents];
	
	[splashScreen setBackgroundImage:[UIImage imageWithContentsOfFile:
									  [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Splash.png"]] forState:UIControlStateNormal];
	
	//[splashScreen setBackgroundColor:[UIColor blueColor]];
	// Add to view
	[self.view addSubview:splashScreen];
	// Once timer finishes the splash screen will be removed
	//[NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(removeSplashScreen) userInfo:nil repeats:NO];
	// Splash screen is loaded stop animating
	[[Director sharedDirector] stopLoading];
}

- (void) hideSplashScreen
{
	if(![splashScreen isHidden])
	{
		NSLog(@"Hiding Splash Screen");
		[splashScreen setHidden:YES];
		[self displayLoadingScreen];
	}
}

- (void) removeSplashScreen
{
	NSLog(@"Removing Splash Screen");
	[splashScreen removeFromSuperview];
	[self displayLoadingScreen];
}

- (void) displayLoadingScreen
{
	// Make sure the glView can only be loaded ONCE
	if(!loadingScreenStarted)
	{
		NSLog(@"Displaying Loading Screen");
		//[backgroundImage setHidden:YES];
		
		[self.view bringSubviewToFront:[[Director sharedDirector] indicatorSpinner]];
		[[Director sharedDirector] startLoading];
		loadingScreenStarted = TRUE;
		[NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(startGlView) userInfo:nil repeats:NO];
	}
}

- (void) startGlView
{
	CFTimeInterval startTime = CFAbsoluteTimeGetCurrent();
	
	
	[[Director sharedDirector] setGlView:[[EAGLView alloc] initWithFrame:[UIScreen mainScreen].bounds]];
	//[[[Director sharedDirector] glView] performSelectorInBackground:@selector(mainRenderLoop) withObject:nil];
	[[[Director sharedDirector] glView] performSelectorOnMainThread:@selector(mainGameLoop) withObject:nil waitUntilDone:NO];
	[self.view addSubview:[[Director sharedDirector] glView]];
	[[Director sharedDirector] stopLoading];
	[[[Director sharedDirector] backgroundSpinner] removeFromSuperview];
	[[[Director sharedDirector] glView] addSubview:[[Director sharedDirector] backgroundSpinner]];
	
	CFTimeInterval finishTime = CFAbsoluteTimeGetCurrent();
	NSLog(@"OpenGl Screen took %f seconds.", finishTime - startTime);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
	NSLog(@"Loading view is removed");
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
	NSLog(@"Loading view is removed");
    [super dealloc];
}


@end
