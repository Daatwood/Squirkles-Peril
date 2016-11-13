//
//  MGSky.m
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 7/1/11.
//  Copyright 2011 Litlapps. All rights reserved.
//

#import "MGSkyScene.h"

typedef enum {
	kStateStartGame,
	kStatePicker,
	kStateMultiplayer,
	kStateMultiplayerCointoss,
	kStateMultiplayerReconnect
} gameStates;

typedef enum {
	kServer,
	kClient
} gameNetwork;

typedef struct {
    CFSwappedFloat32 playerTilt;
} Packet;

#define AutoAcceptInvites 1

// GameKit Session ID for app
#define kGameSessionID @"com.atwooddustin.squirkleperil"

#define kHeartbeatTimeMaxDelay 2.0f

#define kMaxTankPacketSize 1024

@implementation MGSkyScene

@synthesize  multiplayerState, gameSession, gamePeerId, lastHeartbeatDate, connectionAlert;

// 
// === BASIC
// 

- (id)init
{
    self = [super init];
    if (self) 
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPauseScreen) name:@"APPLICATION_RESIGN_ACTIVE" object:nil];
        [MultiplayerManager sharedMultiplayerManager].lobbyDelegate = self;
        [MultiplayerManager sharedMultiplayerManager].gameDelegate = self;
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void) startLoadScene
{
    indicatorPlayer = [[IndicatorPlayer alloc] init]; 
    
	labelLevel = [[LabelControl alloc] initWithFontName:FONT16];
	[[labelLevel font] setColourFilterRed:1.0 green:0.8 blue:0.0 alpha:1.0];
    [labelLevel setText:@"Stage" atSceenPercentage:CGPointMake(15, 97)];
	labelStage = [[LabelControl alloc] initWithFontName:FONT16];
	[[labelStage font] setColourFilterRed:1.0 green:0.8 blue:0.0 alpha:1.0];
    
    ButtonControl* button;
    // Start/Resume Button
	button = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonLarge" 
                                                       withText:@"Start" 
                                                   withFontName:FONT_LARGE
                                             atScreenPercentage:CGPointMake(50, 10)];
	[button setIdentifier:Button_Action];
    [button setButtonColourFilterRed:0.0 green:1.0 blue:0.0 alpha:1.0];
	[button setTarget:self andAction:@selector(showRunningScreen)];
	[[super sceneControls] addObject:button];
	[button release];
    
    // Pause Button
	button = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonSmall" 
											  withSubImageNamed:@"InterfacePause" 
											 atScreenPercentage:CGPointMake(84.84, 6.46)];
	[button setIdentifier:Button_Options];
    [button setButtonColourFilterRed:1.0 green:1.0 blue:0.0 alpha:1.0];
	[button setTarget:self andAction:@selector(showPauseScreen)];
	[[super sceneControls] addObject:button];
	[button release];
    
    //End
	button = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonSmall" 
                                                       withText:@"End" withFontName:FONT21
											 atScreenPercentage:CGPointMake(15.15, 84)];
	[button setIdentifier:Button_Cancel];
    [button setTarget:self andAction:@selector(loadMenuScene)];
    [button setButtonColourFilterRed:1.0 green:0.0 blue:0.0 alpha:1.0];
	[[super sceneControls] addObject:button];
	[button release];
    
    // Players
    player1 = [[MGSkyPlayer alloc] init];
    player2 = [[MGSkyPlayer alloc] init];
    
    // Background
	background = [[JumpScrollerBackground alloc] init];
	
    // Current Playing Level
    gameLevel = 1;
	// Current Difficulty of the Level
	gameStage = 1;
    // Current Sub-Stage
    gameDistance = 1;
    
    super.sceneState = SceneState_Paused;
    [self finishLoadScene];
}

- (void) finishLoadScene
{
    [super setAccelerometerSensitivity:0.5f];
	[self setIsInitialized:TRUE];
	[self transitioningToCurrentScene];
	[[Director sharedDirector] stopLoading];
}

- (void)transitioningToCurrentScene
{
    if(!super.isInitialized)
	{
		[[Director sharedDirector] startLoading];
		[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(startLoadScene) userInfo:nil repeats:NO];
	}
	else
	{
		//[indicatorPlayer refresh];
		
		[player1 adjustImagesBodyType:[[SettingManager sharedSettingManager] for:FileType_Character get:ProfileKey_Part1] 
                             Antenna:[[SettingManager sharedSettingManager] for:FileType_Character get:ProfileKey_Part2]
                                eyes:[[SettingManager sharedSettingManager] for:FileType_Character get:ProfileKey_Part3]
                               color:[[SettingManager sharedSettingManager] for:FileType_Character get:ProfileKey_Color]];
		player1.isAlive = TRUE;
		[self showStartScreen];
        //[self startPicker];
        //[[MultiplayerManager sharedMultiplayerManager] setupSession];
	}
}

// Render
- (void) render
{
    if(!super.isInitialized)
		return;
	
	glPushMatrix();
    
	switch (super.sceneState) 
	{
			// The Scene is in the forefront and running.
		case SceneState_Running:
		{
            [player1 render];
            [player2 render];
            
            [labelLevel render];
			[labelStage render];
			[indicatorPlayer render];
			break;
		}
			// The scene is phasing out.
		case SceneState_TransitionOut:
		{
			break;
		}
			// The scene is phasing in.
		case SceneState_TransitionIn:
		{
			break;
		}
			// The Scene is currently paused.
		case SceneState_Paused:
		{
            [player1 render];
            [player2 render];
            
            [labelLevel render];
			[labelStage render];
			[indicatorPlayer render];
			break;
		}
		default:
		{
			break;
		}
	}
	
    [super render];
    
    glPopMatrix();
}

// Called when user selects a peer from the list or accepts a call invitation.
- (void) openGameScreenWithPeerID:(NSString *)peerID
{
	NSLog(@"Starting game with Peer:%@", peerID);
}

- (void) peerListDidChange:(MultiplayerManager *)session;
{
    NSLog(@"Peerlist did change.. %@", [[session peerList] description]);
}

// Invitation dialog due to peer attempting to connect.
- (void) didReceiveInvitation:(MultiplayerManager *)session fromPeer:(NSString *)participantID;
{
    NSLog(@"Received Invitation..");
    
    if(AutoAcceptInvites)
    {
        // Auto accept invitation
        if ([[MultiplayerManager sharedMultiplayerManager] didAcceptInvitation])
            [self openGameScreenWithPeerID:[MultiplayerManager sharedMultiplayerManager].currentConfPeerID];  
    }
    else
    {
        NSString *str = [NSString stringWithFormat:@"Incoming Invite from %@", participantID];
        if (alertView.visible) {
            [alertView dismissWithClickedButtonIndex:0 animated:NO];
            [alertView release];
        }
        alertView = [[UIAlertView alloc] 
                     initWithTitle:str
                     message:@"Do you wish to accept?" 
                     delegate:self 
                     cancelButtonTitle:@"Decline" 
                     otherButtonTitles:nil];
        [alertView addButtonWithTitle:@"Accept"]; 
        [alertView show];
    }
}

// Display an alert sheet indicating a failure to connect to the peer.
- (void) invitationDidFail:(MultiplayerManager *)session fromPeer:(NSString *)participantID
{
    // Invitation did fail
}

// User has reacted to the dialog box and chosen accept or reject.
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1) 
    {
        // User accepted.  Open the game screen and accept the connection.
        if ([[MultiplayerManager sharedMultiplayerManager] didAcceptInvitation])
            [self openGameScreenWithPeerID:[MultiplayerManager sharedMultiplayerManager].currentConfPeerID]; 
	} 
    else 
    {
        [[MultiplayerManager sharedMultiplayerManager] didDeclineInvitation];
	}
}

// === Game Delegates

- (void) voiceChatWillStart:(MultiplayerManager *)session
{
    // Starting voice chat
}

// Send the same information each time, just with a different header
-(void) sendPacket:(PacketType)packetType
{
    Packet outgoing;
    
    outgoing.playerTilt = CFConvertFloat32HostToSwapped(player1.playerInfo.playerTilt);

    NSData *packet = [[NSData alloc] initWithBytes:&outgoing length:sizeof(Packet)];
    [[MultiplayerManager sharedMultiplayerManager] sendPacket:packet ofType:packetType];
    [packet release];
}

- (void) session:(MultiplayerManager *)session didConnectAsInitiator:(BOOL)shouldStart
{
    NSLog(@"Connected");
    
    [self sendPacket:PacketTypeStart];
}

// If hit end call or the call failed or timed out, clear the state and go back a screen.
- (void) willDisconnect:(MultiplayerManager *)session
{    
    NSLog(@"Will disconnect..");
}

// The GKSession got a packet and sent it to the game, so parse it and update state.
- (void) session:(MultiplayerManager *)session didReceivePacket:(NSData*)data ofType:(PacketType)packetType
{
    //NSLog(@"Did recieve Packet..");
    Packet incoming;
    if ([data length] == sizeof(Packet)) {
        [data getBytes:&incoming length:sizeof(Packet)];
        
        switch (packetType) 
        {
            case PacketTypeStart:
                // The other player started the game, so unpause our graphics
                
                [player2 adjustImagesBodyType:[[SettingManager sharedSettingManager] for:FileType_Character get:ProfileKey_Part1] 
                                      Antenna:[[SettingManager sharedSettingManager] for:FileType_Character get:ProfileKey_Part2]
                                         eyes:[[SettingManager sharedSettingManager] for:FileType_Character get:ProfileKey_Part3]
                                        color:[[SettingManager sharedSettingManager] for:FileType_Character get:ProfileKey_Color]];
                
                PlayerInfo info = player2.playerInfo;
                info.playerPosition = CGPointMake(300, 240);
                info.playerTilt = CFConvertFloat32SwappedToHost(incoming.playerTilt);
                player2.playerInfo = info;
                player2.isAlive = TRUE;
                break;
            case PacketTypeMove:
            {
                PlayerInfo info = player2.playerInfo;
                info.playerTilt = CFConvertFloat32SwappedToHost(incoming.playerTilt);
                player2.playerInfo = info;
                break;
            }
            default:
                break;
        }
    }
}



// 
// === TRANSITIONS AND SETUPS
// 

// Update
- (void) updateWithDelta:(GLfloat)delta
{
    if(timer < 0)
    {
        [self sendPacket:PacketTypeMove];
        timer = 0.1;
    }
    else
        timer -=delta;
    
    [player1 updateWithDelta:delta];
    [player2 updateWithDelta:delta];
}

- (void)updateWithAccelerometer:(UIAcceleration*)aAcceleration 
{
	switch (super.sceneState) 
	{
		case SceneState_Running:
		{
			[super updateWithAccelerometer:aAcceleration];
			
            GLfloat data = [[Director sharedDirector] eventArgs].acceleration.x * 10;
			
			[player1 applyAccelerometer:data];
			
            break;
		}
		default:
			break;
	}
}

// Ends the match, Go back to the Arcade
- (void) loadMenuScene
{
    //[self invalidateSession:gameSession];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"START_BACKGROUND" object:nil]; 
	super.sceneState = SceneState_GameOver;
	[[Director sharedDirector] setCurrentSceneToSceneWithKey:SCENEKEY_MENU];
}

// Show/Setup Startup Screen
- (void) showStartScreen
{
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"STOP_BACKGROUND" object:nil]; 
	// Setup Start Button
	[[super control:Button_Action] setText:@"Start"];
    [[super control:Button_Action] setVisible:TRUE];
    
	// Setup Back Button
	[[super control:Button_Cancel] setVisible:TRUE];
    
    // Options Button
    [[super control:Button_Options] setVisible:FALSE];
    
	// Reset Game
	[self reset];
	
	super.sceneState = SceneState_Paused;
}

// Show/Setup Running Screen
- (void) showRunningScreen
{
    // Disable Start Button
	[[super control:Button_Action] setVisible:FALSE];
	
	// Setup Back Button
	[[super control:Button_Cancel] setVisible:FALSE];
	
	// Setup Pause Button
    [[super control:Button_Options] setVisible:TRUE];
    
	super.sceneState = SceneState_Running;
    
    [[MultiplayerManager sharedMultiplayerManager] setupSession];
}

// Show/Setup Pause Screen
- (void) showPauseScreen
{
    if(super.sceneState != SceneState_Running)
		return;
    
    [[super control:Button_Options] setVisible:FALSE];
    
	// Setup Resume Button
	[[super control:Button_Action] setText:@"Resume"];
    [[super control:Button_Action] setVisible:TRUE];
    
	// Setup Back Button
	[[super control:Button_Cancel] setVisible:TRUE];
	
	super.sceneState = SceneState_Paused;
}

// 
// === GAME MECHANICS
// 

// Reset the gameplay
- (void) reset
{
    
}

// Adjust Game Parameters based on Level and Difficulty
- (void) setGameParameters
{
    
}

// Reuse a platform when one has died.
- (void) generateNextPlatform:(NSArray*)reusePlatforms
{
    
}

// Creates a new platform when one has died.
- (void) generateNewPlatform
{
    
}

// Attempts to use boost
- (void) useBoost
{
    
}

@end
