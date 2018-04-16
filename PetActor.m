//
//  PetActor.m
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 9/20/10.
//  Copyright 2010 Dustin Atwood. All rights reserved.
//

#import "PetActor.h"


@implementation PetActor

@synthesize boundingBox, petState, scale;

- (id) initWithState:(int)state
{
	self = [super init];
	if(self != nil)
	{
		sharedSettingManager = [SettingManager sharedSettingManager];
		[self setPetState:state];
		angerEmotion = 0;
		happyEmotion = 0;
		[self setBoundingBox:CGRectMake(160, 160, 170, 200)];
		[self adjustImages];
	}
	return self;
}

// Increases or Decreases anger, cannot exceed 100
- (void) adjustAngerBy:(float)value
{
	angerEmotion += value;
	if(angerEmotion > 100)
		angerEmotion = 100;
	else if(angerEmotion < 0)
		angerEmotion = 0;
}

// Increases or Decreases happiness, cannot exceed 500
- (void) adjustHappyBy:(float)value
{
	happyEmotion += value;
	if(happyEmotion > 500)
		happyEmotion = 500;
	else if(happyEmotion < 0)
		happyEmotion = 0;
}

- (int) retrieveEmotionLevel
{
	if (angerEmotion > 0) 
		return -angerEmotion;
	else
		return happyEmotion;
}

- (NSString*) retrieveEmotionName
{
	int value = [self retrieveEmotionLevel];
	
	if(value < 0)
		return @"Normal";
	else if(value < 100)
		return @"Sad";
	else if(value < 400)
		return @"Happy";
	else
		return @"Excited";
}

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
	
	
	
	[self setBoundingBox:CGRectMake(160, 160, 170, 200)];
	[self setScale:1.0];
	
	int uid;
	
	//uid = [sharedSettingManager getEquippedItemOfType:ItemType_Topper];
	uid = [[sharedSettingManager forProfileGet:Profilekey_Pet_Antenna] intValue];
	
	if([sharedSettingManager get:ItemKey_Image withUID:uid] == nil)
		topperImage = [[Image alloc] initWithImageNamed:@"Nothing"];
	else
		topperImage = [[Image alloc] initWithImageNamed:[NSString stringWithFormat:@"PetPreviewFront%@",[sharedSettingManager get:ItemKey_Image withUID:uid]]];
	[topperImage setScale:[self scale]];
	
	bodyImage = [[Image alloc] initWithImageNamed:@"PetPreviewFrontBodyNormal"];
	[bodyImage setScale:[self scale]];

	
	//uid = [sharedSettingManager getEquippedItemOfType:ItemType_Eyes];
	uid = [[sharedSettingManager forProfileGet:ProfileKey_Pet_Eyes] intValue];
	if([sharedSettingManager get:ItemKey_Image withUID:uid] == nil)
		eyesImage = [[Image alloc] initWithImageNamed:@"PetPreviewFrontEyesBig"];
	else
		eyesImage = [[Image alloc] initWithImageNamed:[NSString stringWithFormat:@"PetPreviewFront%@",[sharedSettingManager get:ItemKey_Image withUID:uid]]];
	[eyesImage setScale:[self scale]];
	
	mouthImage = [[Image alloc] initWithImageNamed:@"HappyMouth"]; 
	[mouthImage setScale:[self scale]];
	
	[topperImage setColourWithString:[sharedSettingManager forProfileGet:ProfileKey_Pet_Color]];
	[bodyImage setColourWithString:[sharedSettingManager forProfileGet:ProfileKey_Pet_Color]];
}

- (void) adjustImagesWithUID:(NSArray*)uids andColor:(NSString*)colorString
{ //152 380
	[self setBoundingBox:CGRectMake(160, 300, 120, 122)];
	[self setScale:0.5];
	
	int uid;
	
	uid = [[uids objectAtIndex:ItemType_Topper] intValue];
	topperImage = [[Image alloc] initWithImageNamed:[NSString stringWithFormat:@"PetPreviewFront%@",[sharedSettingManager get:ItemKey_Image withUID:uid]]];
	[topperImage setScale:[self scale]];
	
	uid = [[uids objectAtIndex:ItemType_Eyes] intValue];
	eyesImage = [[Image alloc] initWithImageNamed:[NSString stringWithFormat:@"PetPreviewFront%@",[sharedSettingManager get:ItemKey_Image withUID:uid]]];
	[eyesImage setScale:[self scale]];
	
	bodyImage = [[Image alloc] initWithImageNamed:@"PetPreviewFrontBodyNormal"];
	[bodyImage setScale:[self scale]];
	
	mouthImage = [[Image alloc] initWithImageNamed:@"HappyMouth"];
	[mouthImage setScale:[self scale]];
	
	[topperImage setColourWithString:colorString];
	[bodyImage setColourWithString:colorString];

}

- (void) adjustScale:(float)newScale
{
	[self setScale:newScale];
	[feetImage setScale:newScale];
	[topperImage setScale:newScale];
	[bodyImage setScale:newScale];
	[eyesImage setScale:newScale];
	[mouthImage setScale:newScale];
}

// touch began
- (void) touchBeganAtPoint:(CGPoint)beginPoint
{
	return;
}

// touch moved
- (void) touchMovedAtPoint:(CGPoint)newPoint
{
	return;
}

// touch ended
- (void) touchEndedAtPoint:(CGPoint)endPoint
{
	return;
}

// render
- (void) render
{
	CGPoint position = boundingBox.origin;
	
	if([self scale] == 1.0)
	{
		[topperImage renderAtPoint:CGPointMake(position.x - 15, position.y + 160) centerOfImage:YES];
		[bodyImage renderAtPoint:CGPointMake(position.x, position.y) centerOfImage:YES];
		[eyesImage renderAtPoint:CGPointMake(position.x, position.y + 42) centerOfImage:YES];
		[mouthImage renderAtPoint:CGPointMake(position.x, position.y - 30) centerOfImage:YES];
	}
	else
	{
		[topperImage renderAtPoint:CGPointMake(position.x - 8, position.y + 80) centerOfImage:YES];
		[bodyImage renderAtPoint:CGPointMake(position.x, position.y) centerOfImage:YES];
		[eyesImage renderAtPoint:CGPointMake(position.x, position.y + 21) centerOfImage:YES];
		[mouthImage renderAtPoint:CGPointMake(position.x, position.y - 15) centerOfImage:YES];
	}
}

// update
- (void) updateWithDelta:(GLfloat)delta
{
	// Pet will lose happiness depending on the time passed
	// between each frame.
	float adj = (delta / 1 * -1);
	[self adjustHappyBy:adj];
}

@end
