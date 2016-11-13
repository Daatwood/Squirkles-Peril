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
 1.Item Type
 2.Image Name
 
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
#import "ResourceManager.h"
#import "SoundManager.h"

@interface SettingManager : NSObject <UIAlertViewDelegate>
{
    BOOL isPremium; 
    
	NSMutableArray* settingsApplication;
	NSMutableArray* settingsPlayer;
	NSMutableArray* settingsCharacters;
	
	
	// All Saved User Profile;
	NSMutableArray* gameProfile;
	
	// An entire list of items; uid for the key which contains an arry of attributes.
	NSArray *items;
	
	// Array of all purchased UIDs
	NSMutableArray *purchasedItems; 
	
	// Dictionary of In-use Items, contains the UIDs; They keys are the item types
	NSMutableDictionary *equippedItems;
	
	int lastUIAlertType;
}
@property(nonatomic) int selectedProfileIndex;
@property(nonatomic, readonly) NSMutableArray* settingsCharacters;
@property(nonatomic) BOOL isPremium;

+ (SettingManager*)sharedSettingManager;

- (BOOL) isPremium;

- (void) forSettingsSetSoundFxOff;

- (void) forSettingsSetSoundFxOn;

- (void) forSettingsSetMusicOff;

- (void) forSettingsSetMusicOn;

- (BOOL) forSettingsGetSoundFx;

- (BOOL) forSettingsGetMusic;

// Loads all body parts into the game
- (void) loadItems;

// Load the settings from memory
- (void) loadProfile;

// Save a copy of the settings
- (void) saveProfile;

// Creates a new profile
- (void) newProfile;

// Returns the string for the provided property in given file
- (NSString*) for:(SettingsFileType)file get:(uint)property;

// Sets the string for the provided property in given file
- (void) for:(SettingsFileType)file set:(uint)property to:(NSString*)newValue;

// Attempts to modify player coins by amount, returns false if unable to change
- (BOOL) forPlayerAdjustCoinsBy:(int)newValue;

// Attempts to modify player boost by amount, returns false if unable to change
- (BOOL) forPlayerAdjustBoostBy:(int)newValue;

// Attempts to modify selected characters experience by amount, returns false if unable to change
- (BOOL) forPlayerAdjustExperienceBy:(int)newValue;

// Returns a profile attribute for the current selected profile
//- (NSString*) forProfileGet:(uint)profile_attribute;

// Sets the current profile attribute to newValue
//- (void) forProfileSet:(uint)profile_attribute to:(NSString*)newValue;

//- (BOOL) modifyCoinsBy:(int)amount;

//- (BOOL) modifyTreatsBy:(int)amount;

//- (BOOL) modifyCoinsBy:(int)amountCoins andTreatsBy:(int)amountTreats;

//- (void) modifyHappinessBy:(int)amount;

//- (void) modifyBoostBy:(int)amount;

//- (void) createDebugItems;

// Gets a Item Attribute listed under a unique identification number
- (NSString*) get:(uint)attribute withUID:(NSString*)uid;

// Returns True or False if the item has been purchased
- (BOOL) purchased:(NSString*)uid;

// Attempts to purchse the uid, returning true or false if the purchase was successful
// When an item is purchased it is immediately added to the stored items.
- (BOOL) purchaseItem:(NSString*)uid;

// Returns an array of items of type in either: equiped, stored, all
- (NSArray*) getItemsInBin:(uint)bin ofType:(uint)type;

// Return equipped item of a specific type
- (uint) getEquippedItemOfType:(uint)type;

// Attepmts to equiped item.
- (void) equipItem:(NSString*)uid;

// Returns True or False if the item is equipped
- (BOOL) equipped:(NSString*)uid;

// Returns true or false if the item can be equipped
- (BOOL) equippable:(NSString*)uid;

- (void) showDialogHelpCoins;

- (void) showDialogHelpTreats;

- (void) showDialogChangeName;

@end
