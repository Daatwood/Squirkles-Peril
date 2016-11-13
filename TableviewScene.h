

#import <Foundation/Foundation.h>
#import "AbstractScene.h"

@class ButtonControl;
/*
 TableviewScene is a scene that contains a list of items 
 */
@interface TableviewScene : AbstractScene 
{
	NSMutableArray *tableItems;
	Image *backgroundImage;
}

@end
