//
//  CurrencyControl.m
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 1/3/11.
//  Copyright 2011 Dustin Atwood. All rights reserved.
//

#import "CurrencyControl.h"
@implementation CurrencyControl

@synthesize infoCoins, infoTreats;

- (id) initWithCoins:(int)coins andTreats:(int)treats atPosition:(CGPoint)position
{
	if(self = [super init])
	{
		[self changeCoins:coins];
		[self changeTreats:treats];
		background = [[Image alloc] initWithImageNamed:@"Nothing"];
		font = [[AngelCodeFont alloc] initWithFontImageNamed:FONT16 controlFile:FONT16 scale:1.0f filter:GL_LINEAR];
		infoPosition = position;
		//textPosition.x = super.boundingBox.origin.x - ([font getWidthForString:text] / 2);
		//textPosition.y = super.boundingBox.origin.y + ([font getHeightForString:text] / 2);
	}
	return self;
}

- (void) changeCoins:(int)coins andTreats:(int)treats
{
	[self changeCoins:coins];
	[self changeTreats:treats];
}

- (void) changeCoins:(int)coins
{
	infoCoins = coins;
}

- (void) changeTreats:(int)treats
{
	infoTreats = treats;
}

- (void) render
{
	
	[background renderAtPoint:infoPosition centerOfImage:YES];
	[font drawStringAt:CGPointMake(infoPosition.x - 35, infoPosition.y+16) text:[[NSNumber numberWithInt:infoCoins] stringValue]];
	[font drawStringAt:CGPointMake(infoPosition.x + 32.5, infoPosition.y+16) text:[[NSNumber numberWithInt:infoTreats] stringValue]];
}

@end
