//
//  MultiplayerManager.h
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 7/1/11.
//  Copyright 2011 Litlapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h> 
#import "SynthesizeSingleton.h"

typedef enum {
    PacketTypeVoice = 0,
    PacketTypeStart = 1,
    PacketTypeMove = 2
} PacketType;

typedef enum {
    ConnectionStateDisconnected,
    ConnectionStateConnecting,
    ConnectionStateConnected
} ConnectionState;

@interface MultiplayerManager : NSObject <GKSessionDelegate> 
{
    BOOL sessionIsSetup;
	NSString *sessionID;
	GKSession *myGKSession;
	NSString *currentConfPeerID;
	NSMutableArray *peerList;
	id lobbyDelegate;
	id gameDelegate;
    ConnectionState sessionState;
}

@property (nonatomic, readonly) NSString *currentConfPeerID;
@property (nonatomic, readonly) NSMutableArray *peerList;
@property (nonatomic, assign) id lobbyDelegate;
@property (nonatomic, assign) id gameDelegate;

+ (MultiplayerManager*)sharedMultiplayerManager;

- (void) setupSession;
- (void) connect:(NSString *)peerID;
- (BOOL) didAcceptInvitation;
- (void) didDeclineInvitation;
- (void) sendPacket:(NSData*)data ofType:(PacketType)type;
- (void) disconnectCurrentCall;
- (NSString *) displayNameForPeer:(NSString *)peerID;

@end

// Class extension for private methods.
@interface MultiplayerManager ()

- (BOOL) comparePeerID:(NSString*)peerID;
- (BOOL) isReadyToStart;
- (void) voiceChatDidStart;
- (void) destroySession;
- (void) willTerminate:(NSNotification *)notification;
- (void) willResume:(NSNotification *)notification;

@end

@interface MultiplayerManager (VoiceManager) <GKVoiceChatClient>

- (void) setupVoice;

@end

@protocol MultiplayerManagerLobbyDelegate

- (void) peerListDidChange:(MultiplayerManager *)session;
- (void) didReceiveInvitation:(MultiplayerManager *)session fromPeer:(NSString *)participantID;
- (void) invitationDidFail:(MultiplayerManager *)session fromPeer:(NSString *)participantID;

@end

@protocol MultiplayerManagerGameDelegate

- (void) voiceChatWillStart:(MultiplayerManager *)session;
- (void) session:(MultiplayerManager *)session didConnectAsInitiator:(BOOL)shouldStart;
- (void) willDisconnect:(MultiplayerManager *)session;
- (void) session:(MultiplayerManager *)session didReceivePacket:(NSData*)data ofType:(PacketType)packetType;

@end


