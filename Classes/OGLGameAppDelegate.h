//
//  Tutorial1.h
//  OGLGame
//
//  Created by Dustin Atwood on 28/02/2009.
//  Copyright Dustin Atwood 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class EAGLView;
@class LoadingViewController;

@interface OGLGameAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    //EAGLView *glView;
	LoadingViewController *loadingView;
}

@end

