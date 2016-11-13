//
//  ImageActor.h
//  BadBadMonkey
//
//  Created by Dustin Atwood on 10/5/10.
//  Copyright 2010 Litlapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import "AbstractControl.h"
#import "Image.h"

@interface ImageActor : AbstractControl
{
	Image* image;
}

// Init with Image Name at Position with Width and Height
- (id) initWithImageNamed:(NSString*)imageName atPosition:(CGPoint)newPosition;

- (void) setImage:(NSString*)imageName;
@end
