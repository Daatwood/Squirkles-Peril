//
//  PetActor.m
//  BadBadMonkey
//
//  Created by Dustin Atwood on 9/20/10.
//  Copyright 2010 Litlapps. All rights reserved.
//

#import "PetActor.h"


@implementation PetActor

@synthesize boundingBox, petState, scale, colorCharacter, renderPet;

- (id) init
{
	self = [super init];
	if(self != nil)
	{
		sharedSettingManager = [SettingManager sharedSettingManager];
		[self setBoundingBox:CGRectMake(160, 280, 120, 122)];
        eyesIndex = 0;
        eyesImage = [[NSMutableArray alloc] initWithCapacity:3];
        renderPet = FALSE;
        
        imageCharacter = [[Image alloc] initWithImageNamed:@"InterfaceQuestion"];
        [imageCharacter setPositionAtScreenPrecentage:CGPointMake(50, 62.5)];
	}
	return self;
}

- (void) loadNewCharacterCreation
{
    renderPet = FALSE;
    [imageCharacter setColourWithString:[[SettingManager sharedSettingManager] for:FileType_Character get:ProfileKey_Color]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PLAYER_COLOR_CHANGE" object:nil];
}

// Sets all the images based on the default file setting
- (void) loadPartsFromFile
{
	[self loadPartsFrom:[[[SettingManager sharedSettingManager] for:FileType_Player get:ProfileKey_Character] intValue]];
}

// Sets all the images based on the specific character settings
- (void) loadPartsFrom:(uint)characterIndex
{
    renderPet = TRUE;
    
    NSString* characterUID = [[[[[SettingManager sharedSettingManager] settingsCharacters] objectAtIndex:characterIndex] 
                              objectAtIndex:ProfileKey_Part1] retain];
    
    if([characterUID isEqualToString:@"1000"])
    {
         // This is a new character...
        renderPet = FALSE;
            
        return;
    }
    
	[self loadPart:ProfileKey_Part1 
           withUID:nil 
      characterUID:characterUID];
	
	[self loadPart:ProfileKey_Part2 
           withUID:[[[[SettingManager sharedSettingManager] settingsCharacters] objectAtIndex:characterIndex] objectAtIndex:ProfileKey_Part2]
      characterUID:characterUID];
	
	[self loadPart:ProfileKey_Part3 
           withUID:[[[[SettingManager sharedSettingManager] settingsCharacters] objectAtIndex:characterIndex] objectAtIndex:ProfileKey_Part3]
      characterUID:characterUID];
	
	[self adjustToColorString:[NSString stringWithString:[[[[SettingManager sharedSettingManager] settingsCharacters] 
														   objectAtIndex:characterIndex] 
														  objectAtIndex:ProfileKey_Color]]];
    
    //[characterUID release];
}

- (void) adjustToColorString:(NSString*)color
{
	[colorCharacter release];
	colorCharacter = [color retain];
	
	[bodyImage setColourWithString:colorCharacter];
    
	[topperImage setColourWithString:colorCharacter];
}

// Sets the given part based on the provided uid
- (void) loadPart:(uint)part withUID:(NSString*)itemName characterUID:(NSString*)imageAtlas
{
    NSString* atlasSheet = [NSString stringWithFormat:@"%@Atlas", imageAtlas];
    
	switch (part) 
	{
		case ProfileKey_Part1:
		{
            //NSLog(@"Load Body");
            bodyImage = [[ResourceManager sharedResourceManager] getImageWithImageNamed:@"BodyStand" 
                                                                       withinAtlasNamed:atlasSheet];
			[bodyImage setColourWithString:colorCharacter];
           // NSLog(@"Loaded body Antenna: %@", [bodyImage imageName]);
			break;
		}
		case ProfileKey_Part2:
		{
           // NSLog(@"Load Antenna");
            
            topperImage = [[ResourceManager sharedResourceManager] getImageWithImageNamed:
                           [NSString stringWithFormat:@"%@Stand", itemName] 
                                                                         withinAtlasNamed:atlasSheet];
            
            /*if(topperImage == nil)
            {
             
                topperImage = [[ResourceManager sharedResourceManager] getImageWithImageNamed:@"Antenna1Stand"
                                                                             withinAtlasNamed:@"SquirkleAtlas"];
                NSLog(@"Setting default Antenna: %@", [topperImage imageName]);
            }
           */ 
			[topperImage setColourWithString:colorCharacter];
            
			break;
		}
		case ProfileKey_Part3:
		{
            [eyesImage removeAllObjects];
            Image* eyes = [[ResourceManager sharedResourceManager] getImageWithImageNamed:
                             [NSString stringWithFormat:@"%@Stand", itemName] 
                                                                           withinAtlasNamed:atlasSheet];
            [eyesImage addObject:eyes];
            [eyes release];
            eyes = [[ResourceManager sharedResourceManager] getImageWithImageNamed:
                           [NSString stringWithFormat:@"%@Rise", itemName] 
                                                                         withinAtlasNamed:atlasSheet];
            [eyesImage addObject:eyes];
            [eyes release];
            eyes = [[ResourceManager sharedResourceManager] getImageWithImageNamed:
                           [NSString stringWithFormat:@"%@Fall", itemName] 
                                                                         withinAtlasNamed:atlasSheet];
            [eyesImage addObject:eyes];
            [eyes release];
            
            eyesIndex = 0;
            animationTimer = 2.5;
            
			break;
		}
		default:
			break;
	}
    
}

- (void) updateWithDelta:(float)delta
{
    if (animationTimer <= 0) 
    {
        //NSLog(@"Changing..");
        int action = RANDOM(3);
        switch (action) 
        {
                // Look Up
            case 1:
            {
              //  eyesImage = [[ResourceManager sharedResourceManager] getImageWithImageNamed:[[[eyesImage imageName] substringToIndex:5] stringByAppendingString:@"Rise"] 
              //                                                             withinAtlasNamed:atlas];
                animationTimer = 0.5 + RANDOM_0_TO_1();
                eyesIndex = 1;
                break;
            }
                // Look Down
            case 2:
            {
                animationTimer = 0.5 + RANDOM_0_TO_1();
                eyesIndex = 2;
                break;
            }
                // Look Forward
            default:
            {
                animationTimer = 1.0 + RANDOM_0_TO_1() + (RANDOM_0_TO_1() / 2);
                eyesIndex = 0;
                break;
            }
        }
    }
    else
        animationTimer -= delta;
}

/*
// Updates the images to match the settings.
- (void) adjustImages
{
	if(topperImage)
		[topperImage release];
	if(bodyImage)
		[bodyImage release];
	if(eyesImage)
		[eyesImage release];
	if(mouthImage)
		[mouthImage release];
	
	
	
	[self setBoundingBox:CGRectMake(160, 280, 120, 122)];
	[self setScale:0.5];
	
	NSString* uid;
	
	uid = [[SettingManager sharedSettingManager] for:FileType_Character get:ProfileKey_Part1];
	bodyImage = [[Image alloc] initWithImageNamed:@"PetPreviewFrontBodyNormal"];
	[bodyImage setScale:[self scale]];
	
	uid = [[SettingManager sharedSettingManager] for:FileType_Character get:ProfileKey_Part2];
	if([sharedSettingManager get:ItemKey_Image withUID:uid] == nil)
		topperImage = [[Image alloc] initWithImageNamed:@"Nothing"];
	else
		topperImage = [[Image alloc] initWithImageNamed:[NSString stringWithFormat:@"PetPreviewFront%@",[sharedSettingManager get:ItemKey_Image withUID:uid]]];
	[topperImage setScale:[self scale]];

	uid = [[SettingManager sharedSettingManager] for:FileType_Character get:ProfileKey_Part3];
	if([sharedSettingManager get:ItemKey_Image withUID:uid] == nil)
		eyesImage = [[Image alloc] initWithImageNamed:@"PetPreviewFrontEyesBig"];
	else
		eyesImage = [[Image alloc] initWithImageNamed:[NSString stringWithFormat:@"PetPreviewFront%@",[sharedSettingManager get:ItemKey_Image withUID:uid]]];
	[eyesImage setScale:[self scale]];
	
	
	
	mouthImage = [[Image alloc] initWithImageNamed:@"HappyMouth"]; 
	[mouthImage setScale:[self scale]];
	
	[topperImage setColourWithString:[sharedSettingManager for:FileType_Character get:ProfileKey_Color]];
	[bodyImage setColourWithString:[sharedSettingManager for:FileType_Character get:ProfileKey_Color]];
}

- (void) adjustImagesWithUID:(NSArray*)uids andColor:(NSString*)colorString
{
	[self setBoundingBox:CGRectMake(160, 300, 120, 122)];
	[self setScale:0.5];
	
	int uid;
	
	uid = [[uids objectAtIndex:0] intValue];
	bodyImage = [[Image alloc] initWithImageNamed:@"PetPreviewFrontBodyNormal"];
	[bodyImage setScale:[self scale]];
	
	uid = [[uids objectAtIndex:1] intValue];
	if([sharedSettingManager get:ItemKey_Image withUID:uid] == nil)
		topperImage = [[Image alloc] initWithImageNamed:@"Nothing"];
	else
		topperImage = [[Image alloc] initWithImageNamed:[NSString stringWithFormat:@"PetPreviewFront%@",[sharedSettingManager get:ItemKey_Image withUID:uid]]];
	[topperImage setScale:[self scale]];
	
	uid = [[uids objectAtIndex:2] intValue];
	if([sharedSettingManager get:ItemKey_Image withUID:uid] == nil)
		eyesImage = [[Image alloc] initWithImageNamed:@"PetPreviewFrontEyesBig"];
	else
		eyesImage = [[Image alloc] initWithImageNamed:[NSString stringWithFormat:@"PetPreviewFront%@",[sharedSettingManager get:ItemKey_Image withUID:uid]]];
	[eyesImage setScale:[self scale]];
	
	mouthImage = [[Image alloc] initWithImageNamed:@"HappyMouth"];
	[mouthImage setScale:[self scale]];
	
	[topperImage setColourWithString:colorString];
	[bodyImage setColourWithString:colorString];

}

- (void) set:(uint)bodyPart toUID:(uint)uid
{
	[self setBoundingBox:CGRectMake(160, 300, 120, 122)];
	[self setScale:0.5];
	
	switch (bodyPart) 
	{
		case ProfileKey_Part1:
		{
			bodyImage = [[Image alloc] initWithImageNamed:@"PetPreviewFrontBodyNormal"];
			[bodyImage setScale:[self scale]];
			[bodyImage setColourWithString:colorCharacter];
			break;
		}
		case ProfileKey_Part2:
		{
			if([sharedSettingManager get:ItemKey_Image withUID:uid] == nil)
				topperImage = [[Image alloc] initWithImageNamed:@"Nothing"];
			else
				topperImage = [[Image alloc] initWithImageNamed:[NSString stringWithFormat:@"PetPreviewFront%@",[sharedSettingManager get:ItemKey_Image withUID:uid]]];
			[topperImage setScale:[self scale]];
			[topperImage setColourWithString:colorCharacter];
			break;
		}
		case ProfileKey_Part3:
		{
			if([sharedSettingManager get:ItemKey_Image withUID:uid] == nil)
				eyesImage = [[Image alloc] initWithImageNamed:@"PetPreviewFrontEyesBig"];
			else
				eyesImage = [[Image alloc] initWithImageNamed:[NSString stringWithFormat:@"PetPreviewFront%@",[sharedSettingManager get:ItemKey_Image withUID:uid]]];
			[eyesImage setScale:[self scale]];
			break;
		}
		default:
			break;
	}
}
*/
- (void) adjustScale:(float)newScale
{
	//[self setScale:newScale];
	//[topperImage setScale:newScale];
	//[bodyImage setScale:newScale];
	//[eyesImage setScale:newScale];
	//[mouthImage setScale:newScale];
}

// render
- (void) render
{
    if(renderPet)
    {
        [bodyImage renderAtPoint:CGPointMake([bodyImage positionImage].x + boundingBox.origin.x, 
                                             [bodyImage positionImage].y + boundingBox.origin.y) centerOfImage:YES];
        [[eyesImage objectAtIndex:eyesIndex] renderAtPoint:CGPointMake([[eyesImage objectAtIndex:eyesIndex] positionImage].x + boundingBox.origin.x, 
                                                                       [[eyesImage objectAtIndex:eyesIndex] positionImage].y + boundingBox.origin.y) centerOfImage:YES];
        [topperImage renderAtPoint:CGPointMake([topperImage positionImage].x + boundingBox.origin.x, 
                                            [topperImage positionImage].y + boundingBox.origin.y) centerOfImage:YES];
    }
    else
        [imageCharacter render];
}

@end
