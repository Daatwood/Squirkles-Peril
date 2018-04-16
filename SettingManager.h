/*/
 Settings Manager
 
 Saved Information:
 Application Settings (Sound,Music,Vibrate,FavColor)
 Purchased Items (Array of Item IDs)
 In-use Items (Array of Item IDs and related information)
 
 Tasks:
 Saving - Saves information reguarding the application
 Loading - Loads information reguarding the application
 Purchasing - Buys Items
 Equiping Items - Moves items to in-use list
 Previewing Items - Display items 
 
 Items:
 1.Point Cost
 2.Treat Cost
 3.Type (Eyes,Antenna,Body,Background,Foreground,DisplayItem,Overlay,Treat,Minigame)
 Color (For Recolored Items) 
 Text (Name of the item) NSString
 ID (A unique identification number) 
 Image (To locate the actual image to display) NSString
 
 ID->{...}
 Get <Trait> Given ID.
 get:(uint)attribute withUID:(uint)uid
 
 In-Use Item:
 [Type]
  ID -> Position (The center position of the item)
 
 
 
 On First Time use the Item IDs are randomly generated and the item list is saved.
 /*/
#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
#import "Common.h"
#import "Director.h"

@interface SettingManager : NSObject <UIAlertViewDelegate>
{
	// All Saved User Profile;
	NSMutableArray* gameProfile;
	
	// An entire list of items; uid for the key which contains an arry of attributes.
	NSDictionary *items;
	
	// Array of all purchased UIDs
	NSMutableArray *purchasedItems; 
	
	// Dictionary of In-use Items, contains the UIDs; They keys are the item types
	NSMutableDictionary *equippedItems;
	
	int lastUIAlertType;
}
@property(nonatomic) int selectedProfileIndex;

+ (SettingManager*)sharedSettingManager;

// ITEM MANAGEMENT
- (void) loadItems;

- (void) createNewItems;

// PROFILE MANAGEMENT

- (void) newProfile;

// Creates a new profile with given name
- (void) resetProfile;

// Loads all profiles into memory 
- (void) loadProfile;

// Saves the current selected profile
- (void) saveProfile;

// Save Game File
- (void) saveGameFileWithVariables:(NSArray*)gameVariables;

// Load Games File
- (void) loadPreviousGameFile;

// Erase Game File
- (void) eraseGameFile;

// Returns a profile attribute for the current selected profile
- (NSString*) forProfileGet:(uint)profile_attribute;

// Sets the current profile attribute to newValue
- (void) forProfileSet:(uint)profile_attribute to:(NSString*)newValue;

- (BOOL) modifyCoinsBy:(int)amount;

- (BOOL) modifyTreatsBy:(int)amount;

- (BOOL) modifyCoinsBy:(int)amountCoins andTreatsBy:(int)amountTreats;

- (void) modifyHappinessBy:(int)amount;

- (void) modifyBoostBy:(int)amount;

//- (void) createDebugItems;

// Gets a Item Attribute listed under a unique identification number
- (NSString*) get:(uint)attribute withUID:(uint)uid;

// Returns True or False if the item has been purchased
- (BOOL) purchased:(uint)uid;

// Attempts to purchse the uid, returning true or false if the purchase was successful
// When an item is purchased it is immediately added to the stored items.
- (BOOL) purchaseItem:(uint)uid;

// Returns an array of items of type in either: equiped, stored, all
- (NSArray*) getItemsInBin:(uint)bin ofType:(uint)type;

// Return equipped item of a specific type
- (uint) getEquippedItemOfType:(uint)type;

// Attepmts to equiped item.
- (void) equipItem:(uint)uid;

// Returns True or False if the item is equipped
- (BOOL) equipped:(uint)uid;

// Returns true or false if the item can be equipped
- (BOOL) equippable:(uint)uid;

- (void) showDialogHelpCoins;

- (void) showDialogHelpTreats;

- (void) showDialogChangeName;

@end
