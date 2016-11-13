//
//  ButtonViewController.h
//  BadBadMonkey
//
//  Created by Dustin Atwood on 6/20/10.
//  Copyright 2010 Litlapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class Director;

@interface LoadingViewController : UIViewController 
{
    @private
        BOOL loadingScreenStarted;
}

- (void) displayLoadingScreen;

- (void) startGlView;
@end
