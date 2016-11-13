//
//  AnimationActor.h
//  BadBadMonkey
//
//  Created by Dustin Atwood on 10/5/10.
//  Copyright 2010 Litlapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractActor.h"
#import "Common.h"
#import "Animation.h"

@interface AnimationActor : AbstractActor 
{
	Animation* animation;
}

@property (nonatomic, copy) Animation* animation;

// Init with Animation at Position with Width and Height
- (id) initWithAnimation:(Animation*)newAnimation atPosition:(CGPoint)newPosition withSize:(CGPoint)newSize;

@end
