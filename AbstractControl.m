//
//  AbstractControl.m
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 10/9/10.
//  Copyright 2010 Dustin Atwood. All rights reserved.
//

#import "AbstractControl.h"


@implementation AbstractControl

@synthesize enabled, activated, selected, touched, locked, editing, sticky;
@synthesize boundingBox;

// Init at Position with Width and Height
- (id) initWithCGRect:(CGRect)rect
{
	self = [super init];
	if( self != nil)
	{
		sharedSettingManager = [SettingManager sharedSettingManager];
		sharedSoundManager = [SoundManager sharedSoundManager];
		
		// Set Behaviors
		[self setEnabled:TRUE];
		[self setLocked:FALSE];
		[self setSticky:FALSE];
		
		// Set States
		[self resetStates];
		
		// Setting Bounding Box
		[self setBoundingBox:rect];
	}
	return self;
}

- (void) resetStates
{
	[self setActivated:FALSE];
	[self setSelected:FALSE];
	[self setTouched:FALSE];
	[self setEditing:FALSE];
}

- (BOOL) checkBoundingBox:(CGPoint)point
{
	//NSLog(@"%@ <- %@",NSStringFromCGRect(CGRectMake(self.boundingBox.origin.x/* - self.boundingBox.size.width*/, self.boundingBox.origin.y/* - self.boundingBox.size.height*/,
	//								  self.boundingBox.size.width, self.boundingBox.size.height)), 
	// NSStringFromCGPoint(point));
	
	CGRect checkBox = CGRectMake(self.boundingBox.origin.x - self.boundingBox.size.width / 2, 
								self.boundingBox.origin.y - self.boundingBox.size.height / 2, 
								self.boundingBox.size.width, self.boundingBox.size.height);
	
	if ([self touched]) 
	{
		//checkBox = CGRectInset(checkBox, -self.boundingBox.size.width * .5,  -self.boundingBox.size.height * .5);
		//NSLog(@"iBox: %F %f %f %f - %f, %f", checkBox.origin.x, checkBox.origin.y,
		//	  checkBox.size.width,checkBox.size.height, point.x,point.y );
	}
	return CGRectContainsPoint(checkBox, point);
}

// touch began
- (void) touchBeganAtPoint:(CGPoint)beginPoint
{
	[self setActivated:FALSE];
	[self setTouched:FALSE];
	
	if(![self enabled])
		return;
	
	if([self checkBoundingBox:beginPoint])
		[self setTouched:TRUE];
	else
		[self setTouched:FALSE];
	
	if(![self sticky])
		[self setSelected:[self touched]];
}

// touch moved
- (void) touchMovedAtPoint:(CGPoint)newPoint
{
	if(![self enabled] || ![self touched])
		return;
	
	// If the touched moved beyond the bounding box, untouch it and ignore all further attempts
	if([self locked] && ![self sticky])
	{
		if([self checkBoundingBox:newPoint])
			[self setSelected:TRUE];
		else
			[self setSelected:FALSE];
		
		//[self setSelected:[self touched]];
	}
	else if(![self locked])
	{
		CGRect newBox = self.boundingBox;
		newBox.origin.x = newPoint.x;
		newBox.origin.y = newPoint.y;
		self.boundingBox = newBox;
	}
}

// touch ended
- (void) touchEndedAtPoint:(CGPoint)endPoint
{
	if(![self enabled] || ![self touched])
		return;
	
	[self setActivated:FALSE];
	
	if(![self editing])
	{
		if([self checkBoundingBox:endPoint])
			[self setActivated:TRUE];
	}
	
	
	[self setTouched:FALSE];
	if(![self sticky])
		[self setSelected:FALSE];
	[self setEditing:FALSE];
}

// render
- (void) render
{
	
}

// update
- (void) updateWithDelta:(GLfloat)delta;
{

}

@end
