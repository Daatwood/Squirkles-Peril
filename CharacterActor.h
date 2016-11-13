

#import <Foundation/Foundation.h>
#import "AbstractEntity.h"

@interface CharacterActor : AbstractEntity
{
	
	
	
}

- (id) init;

// If the aggravation is high enough then call for new layers
- (void) checkAggravation;

// Increases the aggravation of the character by 1. Then check the aggravation.
- (void) increaseAggravation;

// Increases the aggravation of the character by the param. Then check the aggravation.
- (void) increaseAggravationBy:(uint)increase;

// Decreases the aggravation of the character by 1. Then check the aggravation.
- (void) decreaseAggravation;

// Decreases the aggravation of the character by the param. Then check the aggravation.
- (void) decreaseAggravationBy:(uint)decrease;

@end


