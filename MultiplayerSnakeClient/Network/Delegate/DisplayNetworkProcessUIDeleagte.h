//
//  DisplayNetworkProcessUIDeleagte.h
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/13/16.
//  Copyright © 2016 Aloniki's Study. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DisplayNetworkProcessUIDeleagte <NSObject>

@optional
-(void)UpdateRoomList:(NSMutableArray*)roomList;
@optional
-(void)RoomCreated:(NSMutableDictionary*)roomInfo;
@optional
-(void)UpdateSelfPlayer:(NSMutableDictionary*)player;
@optional
-(void)UpdatePlayerList:(NSMutableArray*)playerList;

@optional
-(void)GameWillStart;
@optional
-(void)GameStopStarting;
@optional
-(void)InvalidOperation;

@optional
-(void)StartGameByHost;

@optional
-(void)StartPlaying;

//-(void)PlayerPrepared:(NSMutableArray*)playerList;
@end
