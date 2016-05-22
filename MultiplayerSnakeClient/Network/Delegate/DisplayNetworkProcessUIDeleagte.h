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
-(void)UpdateRoomList:(NSArray*)roomList;
@optional
-(void)RoomCreated:(NSDictionary*)roomInfo;
@optional
-(void)UpdatePlayerList:(NSMutableArray*)playerList;

@optional
-(void)GameWillStart;
@optional
-(void)GameStopStarting;
@optional
-(void)InvalidOperation;

//-(void)PlayerPrepared:(NSMutableArray*)playerList;
@end
