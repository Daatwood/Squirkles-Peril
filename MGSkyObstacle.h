//
//  MGSkyObstacle.h
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 2/15/11.
//  Copyright 2011 Litlapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParticleEmitter.h"
#import "Image.h"
#import "Common.h"
#import "Director.h"
#import "MGSkyPlayer.h"
#import "MGSkyPlatform.h"
/*
 Obstacles are all evil and trying to sabotage the player's mission.
 
 There are 7 differnt type of obstacles in the game. Each one is based
 off of a distinct shape and posses a differnt ability.
 
 Circle: Hurls himself at the player, though does not kill the player but
	attempts to knock him to his death.
 Triangle: Lunges toward the player attempting to kill him.
 Square: 
 Diamond: Does no harm to the player but does freeze the game for a limited time.
 HoneyComb: Encases other obstacles in a shield.
 Octagon: 
 Star: Exploses causing devasting damage, even pushing away platforms.
 
 Each obstacles also has the ability to Enrage. When enrage all effects caused
 are multiplied by two. Although enrage is only possible at higher levels.
 
 Every Obstacle has several actions:
 Idle: Follows the player.
 Act: Acts out its Ability.
 Enrage: Enrages, but only under certain conditions
 Shift: Changes Type, but only under certain conditions
 
 =====OLD======
 Obstacles can be two main types, Harmful or Harmless.
 All Obstacles can be killed by landing ontop of.
 Harmful obstacles will kill the player if touched from underneath.
 They will also try and stay above the player. 
 Both will have a different Appearance.
 
 When a player kills the platform the obstacle is on
	it will become angered and turn harmful!
 
 When Harmful the Obstacle will emit small Lightning bolts at a slow
	pace around its top half of its body.
 
*/

enum ShapeType
{
	ShapeType_Circle = 1,
	ShapeType_Triangle = 2,
	ShapeType_Square = 3,
	ShapeType_Diamond = 4,
	ShapeType_HoneyComb = 5,
	ShapeType_Octagon = 6,
	ShapeType_Star = 7
};

enum MGSkyObstacleAction
{
	MGSkyObstacleAction_Idle = 0,
	MGSkyObstacleAction_Act = 1,
	MGSkyObstacleAction_Enrage = 2,
	MGSkyObstacleAction_Shift = 3
};

@interface MGSkyObstacle : NSObject 
{
	BOOL readyForDeletion;
	BOOL isAlive;
	BOOL isEnraged;
	CGPoint positionObstacle;
	CGPoint velocityObstacle;
	ParticleEmitter *emitter;
	int typeObstacle;
	Color4f colorObstacle;
	
	// Images
	Image *imageBody;
	Image *imageEyes;
	
	// The direction to move to hit player
	CGPoint directionPlayer;
	
	// The time action changes.
	float timeBeforeActionChange;
	// The current behavioral action
	int currentAction;
	// The cooldown left on its ability
	float abilityCooldown;
}

@property(nonatomic) CGPoint positionObstacle;
@property(nonatomic) BOOL readyForDeletion;

// Initialize the Obstacle
- (id) initAsType:(int)type;

// Performs ability
- (void) useAbility;

// Becomes Enraged
- (void) becomeEnrage;

// Becomes the assigned type
- (void) becomeType:(int)type;

// Kills the Obstacle
- (void) die;

// Update's the Obstacle
- (void) updateWithDelta:(GLfloat)delta givenPlayer:(MGSkyPlayer*)player;

// Applys accelerometer to the player.
- (void) applyAccelerometer:(GLfloat)data;

// Applies velocity to the platform
- (void) applyVelocity:(float)velocity;

// Collision Check Method
- (int) hasCollidedWithPlayer:(MGSkyPlayer*)player withDelta:(GLfloat)delta;

// Renders the Obstacle
- (void) render;

@end
