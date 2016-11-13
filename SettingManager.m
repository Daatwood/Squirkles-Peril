
#import "SettingManager.h"
#import "mtiks.h"

@implementation SettingManager

@synthesize selectedProfileIndex;
@synthesize settingsCharacters;
@synthesize isPremium;

// Make this class a singleton class
SYNTHESIZE_SINGLETON_FOR_CLASS(SettingManager);

- (id)init 
{
	NSLog(@"Settings Manager Initializing...");
	
	gameProfile = [[NSMutableArray alloc] initWithCapacity:1];
	
	settingsApplication = [[NSMutableArray alloc] initWithCapacity:1];
	
	settingsPlayer = [[NSMutableArray alloc] initWithCapacity:1];
	
	settingsCharacters = [[NSMutableArray alloc] initWithCapacity:1];
    
   // [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"PREMIUM"];
   // [[NSUserDefaults standardUserDefaults] synchronize]; 
   /* 
    
    NSString* serialKey = [[NSString alloc] initWithString:[[UIDevice currentDevice] uniqueIdentifier]];
    NSString* premiumKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"PREMIUM"];
    if([premiumKey isEqualToString:serialKey])
        isPremium = TRUE;
    else
        isPremium = FALSE;
    */
    // Load user profile
	[self loadProfile];
    
    
    // Load Items Plist
	[self loadItems];

    // Load Sounds
    [[SoundManager sharedSoundManager] loadSoundWithKey:@"ButtonClick" fileName:@"Interface01" fileExt:@"caf"];
    [[SoundManager sharedSoundManager] loadSoundWithKey:@"JumpSound" fileName:@"Effect01" fileExt:@"caf"];
    [[SoundManager sharedSoundManager] loadSoundWithKey:@"JumpShortSound" fileName:@"Effect02" fileExt:@"caf"];
    
    [[mtiks sharedSession] postEvent:@"Profile" withAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [self for:FileType_Player get:ProfileKey_Character], @"Index",
      [self for:FileType_Character get:ProfileKey_Part1], @"Character", 
      [self for:FileType_Character get:ProfileKey_Power], @"Level", 
      [NSString stringWithFormat:@"%@.%@",[self for:FileType_Character get:ProfileKey_Level], [self for:FileType_Character get:ProfileKey_Stage]], @"Stage",
      nil]];
    
	return self;
}

- (BOOL) isPremium
{
    NSString* serialKey = [NSString stringWithString:[[UIDevice currentDevice] uniqueIdentifier]];
    NSString* premiumKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"PREMIUM"];
    if([premiumKey isEqualToString:serialKey])
        return TRUE;
    else
        return TRUE;
}

- (void) forSettingsSetSoundFxOff
{
	NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
	[settings setBool:NO forKey:@"sound_preference"];
	[settings synchronize];
}

- (void) forSettingsSetSoundFxOn
{
	NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
	[settings setBool:YES forKey:@"sound_preference"];
	[settings synchronize];
}

- (void) forSettingsSetMusicOff
{
	NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
	[settings setBool:NO forKey:@"music_preference"];
	[settings synchronize];
}

- (void) forSettingsSetMusicOn
{
	NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
	[settings setBool:YES forKey:@"music_preference"];
	[settings synchronize];
}

- (BOOL) forSettingsGetSoundFx
{
	return [[[NSUserDefaults standardUserDefaults] objectForKey:@"sound_preference"] boolValue];
}

- (BOOL) forSettingsGetMusic
{
	return [[[NSUserDefaults standardUserDefaults] objectForKey:@"music_preference"] boolValue];
}

// Loads all profiles into memory 
- (void) loadProfile
{
	// Loads all profiles into memory
	NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
	[gameProfile addObjectsFromArray:[settings objectForKey:@"Profile"]];
	
	[settingsApplication addObjectsFromArray:[settings objectForKey:@"APPLICATION"]];
	[settingsPlayer addObjectsFromArray:[settings objectForKey:@"PLAYER"]];
	[settingsCharacters addObjectsFromArray:[settings objectForKey:@"CHARACTERS"]];
	
	if(!settingsApplication || [settingsApplication count] == 0 || 
	   !settingsPlayer || [settingsPlayer count] == 0 || 
	   !settingsCharacters || [settingsCharacters count] == 0)
	{
		[self newProfile];
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"PLAYER_COLOR_CHANGE" object:nil];
}

// Creates a new profile
- (void) newProfile
{
	if(!settingsApplication || [settingsApplication count] == 0)
	{
        // Set M
		[settingsApplication addObject:@"1"];
		[settingsApplication addObject:@"1"];
	}
	if(!settingsPlayer || [settingsPlayer count] == 0)
	{
		[settingsPlayer addObject:@"0"];
		[settingsPlayer addObject:@"0"];
		[settingsPlayer addObject:@"0"];
	}
	if(!settingsCharacters || [settingsCharacters count] == 0)
	{
		NSMutableArray* newCharacter = [[NSMutableArray alloc] initWithObjects:
										// Cost
										@"0",
										// Color String
										@"{0.0, 0.64, 0.32}",
										// Parts: 1,2,3
										@"Squirkle",@"Antenna1",@"Eyes3",
										// Power: L,E
										@"1",@"0",
										// Distance: L,S,D
										@"1",@"1",@"0", nil];
		[settingsCharacters addObject:newCharacter];
		for (int i = 1; i < 10; i++) 
		{
			[settingsCharacters addObject:[NSMutableArray arrayWithObjects:
										   // Cost
										   @"1000",
										   // Color String
										   @"{0.0, 0.64, 0.32}",
										   // Parts: 1,2,3
										   @"Squirkle",@"Antenna1",@"Eyes3",
										   // Power: L,E
										   @"1",@"0",
										   // Distance: L,S,D
										   @"1",@"1",@"0", nil]];
		}
		[newCharacter release];
	}
	[self saveProfile];
}

// Saves the current selected profile
- (void) saveProfile
{
	// Saves the currently selected profile 
	NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
	//[gameProfile replaceObjectAtIndex:ProfileKey_Time withObject:[NSDate dateWithTimeIntervalSinceNow:0]];
    //[settings setObject:gameProfile forKey:@"Profile"];
	[settings setObject:settingsApplication forKey:@"APPLICATION"];
	[settings setObject:settingsPlayer forKey:@"PLAYER"];
	[settings setObject:settingsCharacters forKey:@"CHARACTERS"];
	[settings synchronize];
	
}

// Returns the string for the provided property in given file
- (NSString*) for:(SettingsFileType)file get:(uint)property
{
	switch (file) 
	{
		case FileType_Application:
			return [settingsApplication objectAtIndex:property];
		case FileType_Player:
			return [settingsPlayer objectAtIndex:property];
		case FileType_Character:
			return [[settingsCharacters objectAtIndex: 
					 [[settingsPlayer objectAtIndex:ProfileKey_Character] intValue]] objectAtIndex:property];
		default:
			return nil;
	}
}

// Sets the string for the provided property in given file
- (void) for:(SettingsFileType)file set:(uint)property to:(NSString*)newValue
{
	switch (file) 
	{
		case FileType_Application:
		{
			[settingsApplication replaceObjectAtIndex:property withObject:newValue];
			break;
		}
		case FileType_Player:
		{
			[settingsPlayer replaceObjectAtIndex:property withObject:newValue];
			
			if(property == ProfileKey_Character)
				[[NSNotificationCenter defaultCenter] postNotificationName:@"PLAYER_COLOR_CHANGE" object:nil];
			
			break;
		}
		case FileType_Character:
		{
			int currentIndex = [[settingsPlayer objectAtIndex:ProfileKey_Character] intValue];
			
            //NSLog(@"Replacing on Pet, Property: %d, with %@", property, newValue);
            
			[[settingsCharacters objectAtIndex:currentIndex] replaceObjectAtIndex:property withObject:newValue];
			
			if(property == ProfileKey_Color)
				[[NSNotificationCenter defaultCenter] postNotificationName:@"PLAYER_COLOR_CHANGE" object:nil];
			break;
		}
		default:
			break;
	}
	
	[self saveProfile];
}

// Attempts to modify player coins by amount, returns false if unable to change
- (BOOL) forPlayerAdjustCoinsBy:(int)newValue
{
	int currentCoins = [[self for:FileType_Player get:ProfileKey_Coins] intValue];
	if(newValue < 0 && (currentCoins + newValue) < 0)
		return FALSE;
	
	int coins = currentCoins + newValue;
	[self for:FileType_Player set:ProfileKey_Coins to:[[NSNumber numberWithInt:coins] stringValue]];
	return TRUE;
}

// Attempts to modify player coins by amount, returns false if unable to change
- (BOOL) forPlayerAdjustBoostBy:(int)newValue
{
	int currentBoost = [[self for:FileType_Player get:ProfileKey_Boost] intValue];
	if(newValue < 0 && (currentBoost + newValue) < 0)
		return FALSE;
	
	int boost = currentBoost + newValue;
	[self for:FileType_Player set:ProfileKey_Boost to:[[NSNumber numberWithInt:boost] stringValue]];
	return TRUE;
}

// Attempts to modify selected characters experience by amount, returns false if unable to change
- (BOOL) forPlayerAdjustExperienceBy:(int)newValue
{
	int currentExp = [[self for:FileType_Character get:ProfileKey_Experience] intValue];
	int currentPower = [[self for:FileType_Character get:ProfileKey_Power] intValue];
	
	
	int exp = currentExp + newValue;
	
	if(exp < 0)
		exp = 0;
	
	if(exp > (currentPower * 30 * 1.10))
	{
		//NSLog(@"Level up!");
		exp -= currentPower * 30 * 1.10;
		currentPower++;
        [self forPlayerAdjustBoostBy:2];
	}
	
	[self for:FileType_Character set:ProfileKey_Experience to:[[NSNumber numberWithInt:exp] stringValue]];
	[self for:FileType_Character set:ProfileKey_Power to:[[NSNumber numberWithInt:currentPower] stringValue]];
	return TRUE;
}

- (void) loadItems
{
	NSString* path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Items.plist" ];
	/*
    NSArray* loadedItems = [[NSArray arrayWithContentsOfFile: path]retain];
	
	NSMutableArray* keys = [[NSMutableArray alloc] initWithCapacity:1];
	for (int i = 0; i < [loadedItems count]; i++) 
	{
		//[keys addObject:[NSNumber numberWithInt:1000+RANDOM(8999)]];
		[keys addObject:[NSNumber numberWithInt:1000+i]];
	}
	
	items = [[NSDictionary alloc] initWithObjects:loadedItems forKeys:keys];
	[loadedItems release];
	[keys release];
     */
    items = [[NSArray alloc] initWithContentsOfFile:path];
	NSLog(@"%@", [items description]);
    
}

// Gets a Item Attribute listed under a unique identification number

// Now Returns the item name when given the item type and index
- (NSString*) get:(uint)attribute withUID:(NSString*)uid
{
    /*
    return [[items 
    
    
    
    NSLog(@">> %@ at %d", uid, attribute);
    NSLog(@"items: %@", [items description]);
    NSLog(@"item index: %@", [[items objectForKey:uid] description]);
	NSLog(@"<< %@", [[items objectForKey:uid] objectAtIndex:attribute]);
	return [[items objectForKey:uid] objectAtIndex:attribute];
             */
    return nil;
}

// Returns True or False if the item has been purchased
- (BOOL) purchased:(NSString*)uid
{
	return [purchasedItems containsObject:uid];
}

// Attempts to purchse the uid, returning true or false if the purchase was successful
- (BOOL) purchaseItem:(NSString*)uid
{
	
	// If the item is already on the list then exit
	if ([purchasedItems containsObject:uid]) 
		return NO;
	
	// if the user cannot afford the item, exit
	if (![self forPlayerAdjustCoinsBy:100])
		return NO;
    
	// Move the uid to the purchased list
	[purchasedItems addObject:uid];

	return YES;
}

// Get equiped or all items with a type
- (NSArray*) getItemsInBin:(uint)bin ofType:(uint)type;
{
	NSMutableArray* filterItems = [[NSMutableArray alloc] initWithCapacity:1];
	//int indexType;
	switch (bin) 
	{
		case ItemBin_All:
		{
			for (int i = 0; i < [[items objectAtIndex:type] count]; i++) 
			{
                [filterItems addObject:[[items objectAtIndex:type] objectAtIndex:i]];
                
                
				//if([[[[items allValues] objectAtIndex:i] objectAtIndex:ItemKey_Type] intValue] == type)
				//	[filterItems addObject:[[items allKeys] objectAtIndex:i]];
			}
			break;
		}
		case ItemBin_Equipped:
		{
			// There is only ever 1 item per type equipped.
			NSString* equippedUID = [equippedItems valueForKey:[NSString stringWithFormat:@"%D",type]];
			
			if(equippedUID != nil)
				[filterItems addObject:equippedUID];
			break;
		}
		case ItemBin_Stored:
		{
            /*
			for (int i = 0; i < [items count]; i++) 
			{
				// Returns a comparable itemType 
				indexType = [[[[items allValues] objectAtIndex:i] objectAtIndex:ItemKey_Type] intValue];
				// Checks to make sure the type is correct and has been purchased.
				if(indexType == type && [self purchased:[[items allKeys] objectAtIndex:i]])
				{
					[filterItems addObject:[[items allKeys] objectAtIndex:i]];
				}
			}
			break;
             */
		}
		default:
			break;
	}
    //NSLog(@"Filter: %@", filterItems);
	return [filterItems autorelease];
}

// Return equipped item of a specific type
- (uint) getEquippedItemOfType:(uint)type
{
	NSString* equippedUID = [equippedItems valueForKey:[NSString stringWithFormat:@"%D",type]];
	
	if(equippedUID != nil)
		return [equippedUID intValue];
	
	return -1;
}

// Attepmts to equiped item.
- (void) equipItem:(NSString*)uid
{
	if(![self purchased:uid])
		return;
	
	if(![self equippable:uid])
		return;
	
	// Equips the item replacing any items currently at its spot
//	[equippedItems setValue:uid forKey:
//	 [NSString stringWithFormat:@"%@",[self get:ItemKey_Type withUID:uid]]];
}

- (BOOL) equippable:(NSString*)uid
{
    /*
	int type = [[self get:ItemKey_Type withUID:uid] intValue];
	
	if(type == ItemType_Invalid)
		return NO;
	
	if(type == ItemType_Foreground)
		return NO;
	
	if(type == ItemType_Display)
		return NO;
	
	if(type == ItemType_Treat)
		return NO;
	
	if(type == ItemType_Minigame)
		return NO;
	
	if(type == ItemType_Currency)
		return NO;
	*/
	return YES;
}

- (BOOL) equipped:(NSString*)uid
{
    /*
    int type = [[self get:ItemKey_Type withUID:uid] intValue];
	
	NSString* equippedUID = [equippedItems valueForKey:[NSString stringWithFormat:@"%D",type]];
	if(equippedUID != nil)
	{
		int eUID = [equippedUID intValue];
		
		if(eUID == [uid intValue])
			return TRUE;
	}
     */
	return FALSE;
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{	
	if (buttonIndex == 1)
	{
		switch (actionSheet.tag) 
		{
			case 0:
			{
				[[NSNotificationCenter defaultCenter] postNotificationName:@"STORE_SHOW_COINS" object:nil];
				[[Director sharedDirector] setCurrentSceneToSceneWithKey:SCENEKEY_STORE];
				break;
			}
			case 1:
			{
				[[NSNotificationCenter defaultCenter] postNotificationName:@"STORE_SHOW_TREATS" object:nil];
				[[Director sharedDirector] setCurrentSceneToSceneWithKey:SCENEKEY_STORE];
				break;
			}
			default:
				break;
		}
		
		
	}
}

- (void) showDialogHelpCoins
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Enough Coins!" message:@"You need more Squirkle Coins for this. Would you like to buy some now?" delegate:self cancelButtonTitle:@"No Thanks" otherButtonTitles:@"Yes Please", nil];
	alert.tag = 0;
	[alert show];
	[alert release];
	
}

- (void) showDialogHelpTreats
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Enough Treats!" message:@"You need more Squirkle Treats for this. Would you like to buy some now?" delegate:self cancelButtonTitle:@"No Thanks" otherButtonTitles:@"Yes Please", nil];
	alert.tag = 1;
	[alert show];
	[alert release];
	
}

- (void) showDialogChangeName
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter New Profile Name" message:@"Message" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Enter", nil];
	alert.tag = 2;
	UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
	textField.tag = 75;
	[textField setPlaceholder:@"Profile Name"];
	textField.textAlignment = UITextAlignmentCenter;
	[textField setBackgroundColor:[UIColor whiteColor]];
	[alert addSubview:textField];
	[alert show];
	[textField becomeFirstResponder];
	[alert release];
    [textField release];
}

@end
