    //
//  SplashViewController.m
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 6/20/10.
//  Copyright 2010 Dustin Atwood. All rights reserved.
//

#import "SplashViewController.h"
#import "LoadingViewController.h"

@implementation SplashViewController

BOOL started;

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	NSLog(@"View Starting splash");
	
	[self.view setBackgroundColor:[UIColor darkGrayColor]];
	aButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 360, 480)];
	[aButton addTarget:self action:@selector(beginLoadingView) forControlEvents:UIControlEventAllEvents];
	[self.view addSubview:aButton];
	started = NO;
}

- (void) beginLoadingView
{
	loadingView = [[LoadingViewController alloc] init];
	[self.view addSubview:loadingView.view];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
