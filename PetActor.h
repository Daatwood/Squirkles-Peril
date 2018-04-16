//
//  PetActor.h
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 9/20/10.
//  Copyright 2010 Dustin Atwood. All rights reserved.
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

@interface PetActor : NSObject 
{
	SettingManager* sharedSettingManager;
	
	// The current state the pet is in: Excited, Happy, Sad, Angry, Normal.
	// The state also affects the pet's current emotion displayed.
	uint petState;
	
	// The super position and also its touch area size.
	CGRect boundingBox;
	
	// Overall scale;
	float scale;
	
	// The individual images of the pet.
	Image* bodyImage;
	Image* feetImage;
	Image* eyesImage;
	Image* topperImage;
	Image* mouthImage;
	
	// The anger emotion of the pet; 0-100
	float angerEmotion;
	
	// The happy and sad emotion; 0 - 500
	float happyEmotion;
}
@property(nonatomic) uint petState;
@property(nonatomic) CGRect boundingBox;
@property(nonatomic) float scale;

- (id) initWithState:(int)state;

// Increases or Decreases anger, cannot exceed 100
- (void) adjustAngerBy:(float)value;

// Increases or Decreases happiness, cannot exceed 500
- (void) adjustHappyBy:(float)value;

// The emotion level of the pet
- (int) retrieveEmotionLevel;

- (NSString*) retrieveEmotionName;

// Updates the images to match the settings.
- (void) adjustImages;

// Updates the images by forcing the items;
- (void) adjustImagesWithUID:(NSArray*)uids andColor:(NSString*)colorString;

// touch began
- (void) touchBeganAtPoint:(CGPoint)beginPoint;

// touch moved
- (void) touchMovedAtPoint:(CGPoint)newPoint;

// touch ended
- (void) touchEndedAtPoint:(CGPoint)endPoint;

// render
- (void) render;

// update
- (void) updateWithDelta:(GLfloat)delta;

- (void) adjustScale:(float)newScale;

@end
