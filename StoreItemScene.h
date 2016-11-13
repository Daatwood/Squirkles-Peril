

/*
 Store items contains 11 Elements: 6 Lables and 6 Images.
 The upper right corner is [buttonClose]
 Top centered is the name of the category [labelCategory]
 Underneath the [labelCategory] is the [labelProduct]
 Below the [labelProduct] and to the left side is the [imageProduct]
 To right of [imageProduct] and top are the [buttonBuy] and [buttonBanana]
 Below the 2 buttons is the [labelDescription]
 Bottom Left Corner is the [buttonPrevious]
 Bottom Right Corner is the [buttonNext]
*/
#import <Foundation/Foundation.h>
#import	"AbstractScene.h"
@class AngelCodeFont;
@class Image;
@interface StoreItemScene : AbstractScene 
{
	NSMutableArray *menuEntities;
	NSArray *storeItems;
	int currentItem;
	
	AngelCodeFont *font;
	
	NSString *labelCategory;
	NSString *labelProduct;
	NSString *labelDescription;
	Image *imageProduct;
}

-(id) initWithCategory:(NSString*)category products:(NSArray*)products;

@end
