//
//  NetworkManager.h
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/12/16.
//  Copyright © 2016 Aloniki's Study. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CFNetwork/CFNetwork.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import "inet.h"
#import "JSONKit.h"
#import "DisplayNetworkProcessUIDeleagte.h"
#import "Sender.h"
#import "Receiver.h"
#import "Handler.h"

//#define SERVERIPADDRESS "127.0.0.1"
//#define ROOMIPADDRESS "127.0.0.1"
#define SERVERIPADDRESS "172.20.10.2"
#define ROOMIPADDRESS "172.20.10.2"
#define C2SPORT 9997

@interface NetworkManager<ClientToServerDelegate>: NSObject{
    id<DisplayNetworkProcessUIDeleagte> delegate;
}

@property (assign, nonatomic) id<DisplayNetworkProcessUIDeleagte> delegate;

+(NetworkManager*)getNetworkManagerInstance;

-(int)getPlayerDescriptor;
-(NSString*)getPlayerName;
-(int)getPlayerState;
-(int)getPlayerRole;
-(void)setPlayerDescriptor:(int)descriptor;
-(void)setPlayerName:(NSString*)name;
-(void)setPlayerState:(int)state;
-(void)setPlayerRole:(int)role;

-(BOOL)testSocket;
-(void)disconnectSocket;
-(BOOL)connectToRole:(int)role inPort:(int)port;
-(BOOL)exitGameHallServer;
-(BOOL)requireRoomList;
-(BOOL)createRoom:(NSString*)roomName withMaxPlayers:(int)maxPlayers;

-(BOOL)joinRoom;
-(BOOL)leaveRoom;
-(BOOL)playerPrepare;
-(BOOL)playerUnprepare;


@end
