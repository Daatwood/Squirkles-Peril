//
//  CurrencyControl.h
//  BadBadMonkey
//
//  Created by Dustin Atwood on 1/3/11.
//  Copyright 2011 Litlapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Image.h"
#import "AngelCodeFont.h"

@interface CurrencyControl : NSObject 
{
	int infoCoins;
	int infoTreats;
	Image* background;
	AngelCodeFont* font;
	CGPoint textPosition;
	CGPoint infoPosition;
}

@property(nonatomic) int infoCoins, infoTreats;

- (id) initWithCoins:(int)coins andTreats:(int)treats atPosition:(CGPoint)position;

- (void) changeCoins:(int)coins andTreats:(int)treats;

- (void) changeCoins:(int)coins;

- (void) changeTreats:(int)treats;

- (void) render;

@end
