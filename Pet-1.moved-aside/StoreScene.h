

#import <Foundation/Foundation.h>
#import "AbstractScene.h"
@class AngelCodeFont;
@interface StoreScene : AbstractScene 
{
	NSMutableArray *menuEntities;
	AngelCodeFont *font;
	NSMutableArray *storeList;
	
	Image *titleBar;
	Image *menuBackground;
}

- (void)initStoreItems;

- (void)goToStoreItem;
@end
