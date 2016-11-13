//
//  MGSky.h
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 7/1/11.
//  Copyright 2011 Litlapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import "Image.h"
#import "ButtonControl.h"
#import "CurrencyIndicator.h"
#import "AbstractScene.h"
#import "JumpScrollerBackground.h"
#import "BoostIndicator.h"
#import "Indicator.h"
#import "LabelControl.h"
#import "MGSkyPlatformManager.h"
#import "MGSkyPlayer.h"
#import "MGSkyEnemy.h"
#import "MGSkyPlatform.h"
#import "IndicatorPlayer.h"
#import "IndicatorFill.h"
#import <GameKit/GameKit.h>
#import "MultiplayerManager.h"

typedef enum {
	NETWORK_ACK,					// no packet
	NETWORK_COINTOSS,				// decide who is going to be the server
	NETWORK_MOVE_EVENT,				// send position
	NETWORK_FIRE_EVENT,				// send fire
	NETWORK_HEARTBEAT				// send of entire state at regular intervals
} packetCodes;

@interface MGSkyScene : AbstractScene  <MultiplayerManagerLobbyDelegate, UIAlertViewDelegate>
{
    UIAlertView *alertView;
    
	IndicatorPlayer* indicatorPlayer;
    
	// Displays the current Level
	LabelControl* labelLevel;
	// Displays the current Stage
	LabelControl* labelStage;
    
    // Players
    MGSkyPlayer* player1;
    MGSkyPlayer* player2;
    
    // Background
	JumpScrollerBackground* background;
	
    // Current Playing Level
	int gameLevel;
	// Current Difficulty of the Level
	int gameStage;
    // Current Sub-Stage
    int gameDistance;
    
	UIAlertView	*connectionAlert;
    
    float timer;
    
}

@property(nonatomic) NSInteger		multiplayerState;

@property(nonatomic, retain) GKSession	 *gameSession;
@property(nonatomic, copy)	 NSString	 *gamePeerId;
@property(nonatomic, retain) NSDate		 *lastHeartbeatDate;
@property(nonatomic, retain) UIAlertView *connectionAlert;

// 
// === BASIC
// 

// Initialize
- (id) init;

// Update
- (void) updateWithDelta:(GLfloat)delta;

// Render
- (void) render;

- (void) peerListDidChange:(MultiplayerManager *)session;
- (void) didReceiveInvitation:(MultiplayerManager *)session fromPeer:(NSString *)participantID;
- (void) invitationDidFail:(MultiplayerManager *)session fromPeer:(NSString *)participantID;
- (void) voiceChatWillStart:(MultiplayerManager *)session;
- (void) session:(MultiplayerManager *)session didConnectAsInitiator:(BOOL)shouldStart;
- (void) willDisconnect:(MultiplayerManager *)session;
- (void) session:(MultiplayerManager *)session didReceivePacket:(NSData*)data ofType:(PacketType)packetType;

// 
// === TRANSITIONS AND SETUPS
// 

// Ends the match, Go back to the Arcade
- (void) loadMenuScene;

// Show/Setup Startup Screen
- (void) showStartScreen;

// Show/Setup Running Screen
- (void) showRunningScreen;

// Show/Setup Pause Screen
- (void) showPauseScreen;

// 
// === GAME MECHANICS
// 

// Reset the gameplay
- (void) reset;

// Adjust Game Parameters based on Level and Difficulty
- (void) setGameParameters;

// Reuse a platform when one has died.
- (void) generateNextPlatform:(NSArray*)reusePlatforms;

// Creates a new platform when one has died.
- (void) generateNewPlatform;

// Attempts to use boost
- (void) useBoost;
@end
