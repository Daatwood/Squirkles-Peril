    //
//  ButtonViewController.m
//  BadBadMonkey
//
//  Created by Dustin Atwood on 6/20/10.
//  Copyright 2010 Litlapps. All rights reserved.
//

#import "LoadingViewController.h"
#import "EAGLView.h"

@implementation LoadingViewController

- (void)loadView 
{
	[super loadView];
	
    [self.view setBackgroundColor:[UIColor blackColor]];
	loadingScreenStarted = NO;
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:
														  [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Default.png"]]];
    [self.view addSubview:backgroundImage];
    
    [backgroundImage release];
	
	[[Director sharedDirector] setBackgroundSpinner:
	 [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LoadingOverlay.png"]]];
	[[Director sharedDirector] backgroundSpinner].frame = CGRectMake(0, 0, 320, 480);
	[[Director sharedDirector] setIndicatorSpinner:
	 [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"InterfaceLoading0.png"]]];
	
	[[Director sharedDirector] indicatorSpinner].animationImages = [NSArray arrayWithObjects:
																	[UIImage imageNamed:@"InterfaceLoading0.png"],
																	[UIImage imageNamed:@"InterfaceLoading1.png"],
																	[UIImage imageNamed:@"InterfaceLoading2.png"],
																	[UIImage imageNamed:@"InterfaceLoading3.png"],
																	[UIImage imageNamed:@"InterfaceLoading4.png"],
																	[UIImage imageNamed:@"InterfaceLoading5.png"],
																	[UIImage imageNamed:@"InterfaceLoading6.png"],
																	[UIImage imageNamed:@"InterfaceLoading7.png"],
																	[UIImage imageNamed:@"InterfaceLoading8.png"],
																	[UIImage imageNamed:@"InterfaceLoading9.png"],
                                                                    [UIImage imageNamed:@"InterfaceLoading10.png"],
																	nil];
	[[Director sharedDirector] indicatorSpinner].animationDuration = 1.0;
    
	[[Director sharedDirector] indicatorSpinner].frame = CGRectMake(-6.0, 320, 332, 72);
    
	[[[Director sharedDirector] backgroundSpinner] addSubview:[[Director sharedDirector] indicatorSpinner]];
	[self.view addSubview:[[Director sharedDirector] backgroundSpinner]];
    
	[[Director sharedDirector] startLoading];
}

- (void) displayLoadingScreen
{
	if(!loadingScreenStarted)
	{
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
    [[[Director sharedDirector] glView] performSelectorOnMainThread:@selector(mainGameLoop) withObject:nil waitUntilDone:NO];
	[self.view addSubview:[[Director sharedDirector] glView]];
	[[Director sharedDirector] stopLoading];
	[[[Director sharedDirector] backgroundSpinner] removeFromSuperview];
	[[[Director sharedDirector] glView] addSubview:[[Director sharedDirector] backgroundSpinner]];
	
	CFTimeInterval finishTime = CFAbsoluteTimeGetCurrent();
	NSLog(@"OpenGl Screen took %f seconds.", finishTime - startTime);
}

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
    
    [super dealloc];
}


@end
