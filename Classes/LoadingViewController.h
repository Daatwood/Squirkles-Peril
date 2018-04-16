//
//  ButtonViewController.h
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 6/20/10.
//  Copyright 2010 Dustin Atwood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class Director;

@interface LoadingViewController : UIViewController 
{

	UIButton *splashScreen;
	UIImageView *backgroundImage;
	UIActivityIndicatorView *loadingView;
	UILabel *loadingLabel;
	Director *sharedDirector;
}

- (void) displaySplashScreen;

- (void) displayLoadingScreen;

- (void) startGlView;
@end
