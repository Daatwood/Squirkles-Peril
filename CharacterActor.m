#import "CharacterActor.h"

@interface CharacterActor (Private)
- (void) changeAggravation:(int)change;
@end

@implementation CharacterActor

// Init Methods
- (id) init
{
	self = [super initWithFrequency:0];
	if (self != nil) 
	{
		[super setParameter:@"Aggravation" equalToValue:0];
		[super show];
		[super setTag: 2];
		NSLog(@"Setting Aggravation");
		[sharedAnimationManager requestLayer:self withEvent:0];
	}
	return self;
}


// --Aggravation Selectors--
// If the aggravation is high enough then call for new layers
- (void) checkAggravation
{
	//if([self getParameter:@"Aggravation"] == 0)
	//[sharedAnimationManager requestLayer:self withEvent:0];
}

// Increases the aggravation of the character by 1. Then check the aggravation.
- (void) increaseAggravation
{	
	[self increaseAggravationBy:1];
}

// Increases the aggravation of the character by the param. Then check the aggravation.
// 
- (void) increaseAggravationBy:(uint)increase
{
	[self changeAggravation:increase];
}

// Decreases the aggravation of the character by 1. Then check the aggravation.
- (void) decreaseAggravation
{
	[self decreaseAggravationBy:1];
}

// Decreases the aggravation of the character by the param. Then check the aggravation.
- (void) decreaseAggravationBy:(uint)decrease
{
	[self changeAggravation:-decrease];
}

- (void) changeAggravation:(int)change
{
	// Retrieve the current and add change
	int newValue = [super getParameter:@"Aggravation"] + change;
	// Check to see the parameter is within bounds.
	if(newValue > 3)
		newValue = 0;
	if(newValue < 0)
		newValue = 0;
	
	// Set the parameter equal to the new value
	[super setParameter:@"Aggravation" equalToValue:newValue];
	//NSLog(@"Aggravation is now %D", newValue);
	[self checkAggravation];
}

// --Touch Selectors--
// The start point of the touch
- (BOOL) touchBeganAtPoint:(CGPoint)beginPoint
{
	if ([super touchBeganAtPoint:beginPoint])
	{
		[self increaseAggravation];
		return TRUE;
	}
	return FALSE;
}

// The end point of the touch
- (BOOL) touchEndedAtPoint:(CGPoint)endPoint
{
	if ([super touchEndedAtPoint:endPoint])
	{
		[self increaseAggravation];
		return TRUE;
	}
	return FALSE;
}

@end
