
#import "SettingManager.h"


@implementation SettingManager

@synthesize selectedProfileIndex;

// Make this class a singleton class
SYNTHESIZE_SINGLETON_FOR_CLASS(SettingManager);

- (id)init 
{
	NSLog(@"Settings Manager Initializing...");
	
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadPreviousGameFile) name:@"DID_BECOME_ACTIVE" object:nil];
	
	gameProfile = [[NSMutableArray alloc] initWithCapacity:1];
	
	//[self newProfile];
	// Initialize the arrays to be used within the state manager
	//[self createDebugItems];
	//[self createNewItems];

	[self createNewItems];
	[self loadProfile];
	
	return self;
}

// Creates a new profile with given name
- (void) newProfile
{
	/*
	 ProfileKey_Name = 0,
	 ProfileKey_Time = 1,
	 ProfileKey_Vibrate = 2,
	 ProfileKey_Effects = 3,
	 ProfileKey_Music = 4,
	 ProfileKey_Coins = 5,
	 ProfileKey_Treats = 6,
	 ProfileKey_Boost = 7,
	 ProfileKey_Pet_Color = 8,
	 Profilekey_Pet_Antenna = 9,
	 ProfileKey_Pet_Eyes = 10,
	 ProfileKey_Sky_HiScore = 11,
	 ProfileKey_Sky_Level1 = 12,
	 ProfileKey_Sky_Level2 = 13,
	 ProfileKey_Sky_Level3 = 14,
	 ProfileKey_Sky_Level4 = 15,
	 ProfileKey_Sky_Level5 = 16,
	 ProfileKey_Escape_HiScore = 17,
	 ProfileKey_Sky_Level1 = 18,
	 ProfileKey_Sky_Level2 = 19,
	 ProfileKey_Sky_Level3 = 20,
	 ProfileKey_Sky_Level4 = 21,
	 ProfileKey_Sky_Level5 = 22,
	 ProfileKey_Crystal_HiScore = 23,
	 ProfileKey_Sky_Level1 = 24,
	 ProfileKey_Sky_Level2 = 25,
	 ProfileKey_Sky_Level3 = 26,
	 ProfileKey_Sky_Level4 = 27,
	 ProfileKey_Sky_Level5 = 28
	 */
	
	// Name
	[gameProfile addObject:@"GamePlayer"];
	// Time
	[gameProfile addObject:[NSDate dateWithTimeIntervalSinceNow:0]];
	// Vibrate
	[gameProfile addObject:@"1"];
	// Effects
	[gameProfile addObject:@"1"];
	// Music
	[gameProfile addObject:@"1"];
	// Coins
	[gameProfile addObject:@"100"];
	// Treats
	[gameProfile addObject:@"1"];
	// Boost
	[gameProfile addObject:@"1"];
	// Color
	[gameProfile addObject:[NSString stringWithFormat:@"{%F, %F, %F}", RANDOM_0_TO_1(), RANDOM_0_TO_1(), RANDOM_0_TO_1()]]; 
	// Antenna
	[gameProfile addObject:@"1000"];
	// Eyes
	[gameProfile addObject:@"1004"];
	
	// High Score sky
	[gameProfile addObject:@"0"];
	// Level1
	[gameProfile addObject:@"1"];
	// Level2
	[gameProfile addObject:@"0"];
	// Level3
	[gameProfile addObject:@"0"];
	// Level4
	[gameProfile addObject:@"0"];
	// Level5
	[gameProfile addObject:@"0"];
	
	// High Score escape
	[gameProfile addObject:@"0"];
	// Level1
	[gameProfile addObject:@"1"];
	// Level2
	[gameProfile addObject:@"0"];
	// Level3
	[gameProfile addObject:@"0"];
	// Level4
	[gameProfile addObject:@"0"];
	// Level5
	[gameProfile addObject:@"0"];
	
	// High Score crystal
	[gameProfile addObject:@"0"];
	// Level1
	[gameProfile addObject:@"1"];
	// Level2
	[gameProfile addObject:@"0"];
	// Level3
	[gameProfile addObject:@"0"];
	// Level4
	[gameProfile addObject:@"0"];
	// Level5
	[gameProfile addObject:@"0"];
	[self saveProfile];
}

// Creates a new profile with given name
- (void) resetProfile
{
    [gameProfile replaceObjectAtIndex:ProfileKey_Name withObject:@"GamePlayer"];
	[gameProfile replaceObjectAtIndex:ProfileKey_Coins withObject:@"100"];
	[gameProfile replaceObjectAtIndex:ProfileKey_Treats withObject:@"1"];
	[gameProfile replaceObjectAtIndex:ProfileKey_Pet_Color withObject:[NSString stringWithFormat:@"{%F, %F, %F}", RANDOM_0_TO_1(), RANDOM_0_TO_1(), RANDOM_0_TO_1()]];
	[gameProfile replaceObjectAtIndex:Profilekey_Pet_Antenna withObject:@"1000"];
	[gameProfile replaceObjectAtIndex:ProfileKey_Pet_Eyes withObject:@"1004"];
	[gameProfile replaceObjectAtIndex:ProfileKey_Boost withObject:@"1"];
	[gameProfile replaceObjectAtIndex:ProfileKey_Time withObject:[NSDate dateWithTimeIntervalSinceNow:0]];
	[gameProfile replaceObjectAtIndex:ProfileKey_Sky_HiScore withObject:@"0"];
	[gameProfile replaceObjectAtIndex:ProfileKey_Sky_Level1 withObject:@"1"];
	[gameProfile replaceObjectAtIndex:ProfileKey_Sky_Level2 withObject:@"0"];
	[gameProfile replaceObjectAtIndex:ProfileKey_Sky_Level3 withObject:@"0"];
	[gameProfile replaceObjectAtIndex:ProfileKey_Sky_Level4 withObject:@"0"];
	[gameProfile replaceObjectAtIndex:ProfileKey_Sky_Level5 withObject:@"0"];
	[gameProfile replaceObjectAtIndex:ProfileKey_Escape_HiScore withObject:@"0"];
	[gameProfile replaceObjectAtIndex:ProfileKey_Escape_Level1 withObject:@"1"];
	[gameProfile replaceObjectAtIndex:ProfileKey_Escape_Level2 withObject:@"0"];
	[gameProfile replaceObjectAtIndex:ProfileKey_Escape_Level3 withObject:@"0"];
	[gameProfile replaceObjectAtIndex:ProfileKey_Escape_Level4 withObject:@"0"];
	[gameProfile replaceObjectAtIndex:ProfileKey_Escape_Level5 withObject:@"0"];
	[gameProfile replaceObjectAtIndex:ProfileKey_Crystal_HiScore withObject:@"0"];
	[gameProfile replaceObjectAtIndex:ProfileKey_Crystal_Level1 withObject:@"1"];
	[gameProfile replaceObjectAtIndex:ProfileKey_Crystal_Level2 withObject:@"0"];
	[gameProfile replaceObjectAtIndex:ProfileKey_Crystal_Level3 withObject:@"0"];
	[gameProfile replaceObjectAtIndex:ProfileKey_Crystal_Level4 withObject:@"0"];
	[gameProfile replaceObjectAtIndex:ProfileKey_Crystal_Level5 withObject:@"0"];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"PLAYER_COLOR_CHANGE" object:nil];
	[self saveProfile];
}

// Loads all profiles into memory 
- (void) loadProfile
{
	// Loads all profiles into memory
	NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
	[gameProfile addObjectsFromArray:[settings objectForKey:@"Profile"]];
	if([gameProfile count] == 0)
		[self newProfile];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"PLAYER_COLOR_CHANGE" object:nil];
}

// Saves the current selected profile
- (void) saveProfile
{
	// Saves the currently selected profile 
	
	NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
	//[gameProfile replaceObjectAtIndex:ProfileKey_Time withObject:[NSDate dateWithTimeIntervalSinceNow:0]];
    [settings setObject:gameProfile forKey:@"Profile"];
	[settings synchronize];
	
}

- (void) changeProfileName
{
	UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Enter Profile Name" message:@"Profile Name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
	UITextField *myTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
	[myTextField setBackgroundColor:[UIColor whiteColor]];
	[myAlertView addSubview:myTextField];
	//CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0.0, 130.0);
	//[myAlertView setTransform:myTransform];
	[myAlertView show];
	[myAlertView release];
}

- (void) saveGameFileWithVariables:(NSArray*)gameVariables;
{
	NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setObject:gameVariables forKey:@"Game"];
	[settings synchronize];
}

- (void) loadPreviousGameFile
{
	NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
	if([settings boolForKey:@"GAME"])
	{
		NSLog(@"Game Found");
		[[Director sharedDirector] setCurrentSceneToSceneWithKey:GAMEKEY_SKY];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"LOAD_SKY_GAME" object:nil];
	}
	else
	{
		NSLog(@"Game Not Found");
	}
	/*
	if([settings objectForKey:@"Game"])
	{
		NSLog(@"Game found");
		[[Director sharedDirector] setCurrentSceneToSceneWithKey:GAMEKEY_SKY];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"LOAD_SKY_GAME" object:[settings arrayForKey:@"Game"]];
	}
	 */
}

- (void) eraseGameFile
{
	NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
	[settings removeObjectForKey:@"Game"];
    [settings synchronize];
}

// Returns a profile attribute for the current selected profile
- (NSString*) forProfileGet:(uint)profile_attribute
{
	return [gameProfile objectAtIndex:profile_attribute];
}

// Sets the current profile attribute to newValue
- (void) forProfileSet:(uint)profile_attribute to:(NSString*)newValue
{
	[gameProfile replaceObjectAtIndex:profile_attribute withObject:newValue];
	
	if(profile_attribute == ProfileKey_Pet_Color)
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:@"PLAYER_COLOR_CHANGE" object:nil];
	}
	
	[self saveProfile];
}

- (BOOL) modifyCoinsBy:(int)amount
{
	int currentCoins = [[self forProfileGet:ProfileKey_Coins] intValue];
	
	if(amount < 0 && (currentCoins + amount) < 0)
	{
		[self showDialogHelpCoins];
		return FALSE;
	}
	
	int coins = currentCoins + amount;
	[self forProfileSet:ProfileKey_Coins to:[[NSNumber numberWithInt:coins] stringValue]];
	
	return TRUE;
}

- (BOOL) modifyTreatsBy:(int)amount
{
	int currentTreats = [[self forProfileGet:ProfileKey_Treats] intValue];
	
	if(amount < 0 && (currentTreats + amount) < 0)
	{
		[self showDialogHelpTreats];
		return FALSE;
	}
	
	int treats = currentTreats + amount;
	[self forProfileSet:ProfileKey_Treats to:[[NSNumber numberWithInt:treats] stringValue]];
	
	return TRUE;
}

- (BOOL) modifyCoinsBy:(int)amountCoins andTreatsBy:(int)amountTreats
{
	int currentCoins = [[self forProfileGet:ProfileKey_Coins] intValue];
	int currentTreats = [[self forProfileGet:ProfileKey_Treats] intValue];
	
	if(amountCoins < 0 && (currentCoins + amountCoins) < 0)
	{
		[self showDialogHelpCoins];
		return FALSE;
	}
	
	if(amountTreats < 0 && (currentTreats + amountTreats) < 0)
	{
		[self showDialogHelpTreats];
		return FALSE;
	}
	
	int coins = currentCoins + amountCoins;
	[self forProfileSet:ProfileKey_Coins to:[[NSNumber numberWithInt:coins] stringValue]];
	
	int treats = currentTreats + amountTreats;
	[self forProfileSet:ProfileKey_Treats to:[[NSNumber numberWithInt:treats] stringValue]];
	
	return TRUE;
}


- (void) modifyHappinessBy:(int)amount
{
	int happiness = [[self forProfileGet:ProfileKey_Pet_Color] intValue] + amount;
	
	[self forProfileSet:ProfileKey_Pet_Color to:[[NSNumber numberWithInt:happiness] stringValue]];
}

- (void) modifyBoostBy:(int)amount
{
	int boost = [[self forProfileGet:ProfileKey_Boost] intValue] + amount;
	
	[self forProfileSet:ProfileKey_Boost to:[[NSNumber numberWithInt:boost] stringValue]];
}

- (void) loadItems
{
	// Loads all items into memory
	NSUserDefaults *itemSettings = [NSUserDefaults standardUserDefaults];
	items = [[NSDictionary alloc] initWithDictionary:[itemSettings dictionaryForKey:@"Items"]];
	
	if(items == nil || [items count] == 0)
	{
		[self createNewItems];
	}
}

- (void) createNewItems
{
	//purchasedItems = [[NSMutableArray alloc] initWithCapacity:1];
	//equippedItems = [[NSMutableDictionary alloc] initWithCapacity:1];
	
	NSString* path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: @"GameItems.plist" ];
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
	
	//NSUserDefaults *itemSettings = [NSUserDefaults standardUserDefaults];
	//[itemSettings setObject:items forKey:@"Items"];
	
	//[itemSettings synchronize];
}

// Gets a Item Attribute listed under a unique identification number
- (NSString*) get:(uint)attribute withUID:(uint)uid
{
	
	return [[items objectForKey:[NSNumber numberWithInt:uid]] objectAtIndex:attribute];
}

// Returns True or False if the item has been purchased
- (BOOL) purchased:(uint)uid
{
	return [purchasedItems containsObject:[NSNumber numberWithInt:uid]];
}

// Attempts to purchse the uid, returning true or false if the purchase was successful
- (BOOL) purchaseItem:(uint)uid
{
	
	// If the item is already on the list then exit
	if ([purchasedItems containsObject:[NSNumber numberWithInt:uid]]) 
	{
		//NSLog(@"Failed to purchase item %D, already purchased.", uid);
		return NO;
	}
	
	// if the user cannot afford the item, exit
	
	if ([[self forProfileGet:ProfileKey_Coins] intValue] < 
		[[[items objectForKey:[NSNumber numberWithInt:uid]] objectAtIndex:ItemKey_PCost] intValue])
	{
		//NSLog(@"Failed to purchase item %D, Cannot afford.", uid);
		return NO;
	}
	
	if ([[self forProfileGet:ProfileKey_Treats] intValue] < 
		[[[items objectForKey:[NSNumber numberWithInt:uid]] objectAtIndex:ItemKey_TCost] intValue]) 
	{
		//NSLog(@"Failed to purchase item %D, Cannot afford.", uid);
		return NO;
	}
	
	// Subtract the cost from the users points n treats
	[self modifyCoinsBy:-[[[items objectForKey:[NSNumber numberWithInt:uid]] objectAtIndex:ItemKey_PCost] intValue]];
	[self modifyTreatsBy:-[[[items objectForKey:[NSNumber numberWithInt:uid]] objectAtIndex:ItemKey_TCost] intValue]];
	
	// Move the uid to the purchased list
	[purchasedItems addObject:[NSNumber numberWithInt:uid]];
	//NSLog(@"Purchased: %D",uid);
	return YES;
}

// Get equiped or all items with a type
- (NSArray*) getItemsInBin:(uint)bin ofType:(uint)type;
{
	NSMutableArray* filterItems = [[NSMutableArray alloc] initWithCapacity:1];
	int indexType;
	switch (bin) 
	{
		case ItemBin_All:
		{
			for (int i = 0; i < [items count]; i++) 
			{
				if([[[[items allValues] objectAtIndex:i] objectAtIndex:ItemKey_Type] intValue] == type)
					[filterItems addObject:[[items allKeys] objectAtIndex:i]];
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
			for (int i = 0; i < [items count]; i++) 
			{
				// Returns a comparable itemType 
				indexType = [[[[items allValues] objectAtIndex:i] objectAtIndex:ItemKey_Type] intValue];
				// Checks to make sure the type is correct and has been purchased.
				if(indexType == type && [self purchased:[[[items allKeys] objectAtIndex:i] intValue]])
				{
					[filterItems addObject:[[items allKeys] objectAtIndex:i]];
					///NSLog(@"%@",[filterItems description]);
				}
			}
			break;
		}
		default:
			break;
	}
	//NSLog(@"Filtered: %@",[filterItems description]);
	return filterItems;
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
- (void) equipItem:(uint)uid
{
	if(![self purchased:uid])
		return;
	
	if(![self equippable:uid])
		return;
	
	// Equips the item replacing any items currently at its spot
	[equippedItems setValue:[NSNumber numberWithInt:uid] forKey:
	 [NSString stringWithFormat:@"%D",[[self get:ItemKey_Type withUID:uid]intValue]]];
	
	
	//NSLog(@"Equipping: %D In Slot: %D", uid, [[self get:ItemKey_Type withUID:uid]intValue]);
}

- (BOOL) equippable:(uint)uid
{
	int type = [[self get:ItemKey_Type withUID:uid]intValue];
	
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
	
	return YES;
}

- (BOOL) equipped:(uint)uid
{
	//return FALSE;
	
	int type = [[self get:ItemKey_Type withUID:uid]intValue];
	
	NSString* equippedUID = [equippedItems valueForKey:[NSString stringWithFormat:@"%D",type]];
	if(equippedUID != nil)
	{
		int eUID = [equippedUID intValue];
		
		if(eUID == uid)
			return TRUE;
	}
	return FALSE;
	//return [[equippedItems allValues] containsObject:[NSNumber numberWithInt:uid]];
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
			case 2:
			{
				UITextField *textField = (UITextField*) [actionSheet viewWithTag:75];
				[self forProfileSet:ProfileKey_Name to:textField.text];
				[[NSNotificationCenter defaultCenter] postNotificationName:@"PROFILE_NAME_CHANGE" object:nil];
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
}

@end
