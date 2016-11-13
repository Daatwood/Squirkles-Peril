//
//  PetActor.h
//  BadBadMonkey
//
//  Created by Dustin Atwood on 9/20/10.
//  Copyright 2010 Litlapps. All rights reserved.
//

// PetActor setups and creates the pet.

// The pet actor will operates similarly to the stage actor
// The main difference are all the images are tied in together.
// There is a super position to where the center of the pet is
// drawn on the screen and each part of the pet has its on local
// position that is an offset of the super position.
#import <Foundation/Foundation.h>
#import "SettingManager.h"
#import "Image.h"
#import "Common.h"

@interface PetActor : NSObject 
{
	SettingManager* sharedSettingManager;
	
	// The super position and also its touch area size.
	CGRect boundingBox;
	
	// Overall scale;
	float scale;
	
	// The individual images of the pet.
	Image* bodyImage;
	NSMutableArray* eyesImage;
	Image* topperImage;
	Image* mouthImage;
    
    BOOL renderPet;
	
	// Color of the Character
	NSString* colorCharacter;
    
    float animationTimer;
    int eyesIndex;
    
    Image* imageCharacter;
}
@property(nonatomic) BOOL renderPet;
@property(nonatomic) uint petState;
@property(nonatomic) CGRect boundingBox;
@property(nonatomic) float scale;
@property(nonatomic, retain) NSString* colorCharacter;

// Show Creation Image 
- (void) loadNewCharacterCreation;

// Sets all the images based on the default file setting
- (void) loadPartsFromFile;

// Sets all the images based on the specific character settings
- (void) loadPartsFrom:(uint)characterIndex;

// Sets the given part based on the provided uid
- (void) loadPart:(uint)part withUID:(NSString*)uid characterUID:(NSString*)uidAtlas;

// Sets all the parts to string
- (void) adjustToColorString:(NSString*)color;

- (void) updateWithDelta:(float)delta;
/*
// Updates the images to match the settings.
- (void) adjustImages;

// Updates the images by forcing the items;
- (void) adjustImagesWithUID:(NSArray*)uids andColor:(NSString*)colorString;

- (void) set:(uint)bodyPart toUID:(uint)uid;
*/
// render
- (void) render;

- (void) adjustScale:(float)newScale;

@end
