//
//  main.m
//  Squirkle's Peril
//
//  Created by Boltline on 12/7/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) 
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, @"OGLGameAppDelegate");
    [pool release];
    return retVal;
}
