//
//  DisplayNetworkProcessUIDeleagte.h
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/13/16.
//  Copyright © 2016 Aloniki's Study. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DisplayNetworkProcessUIDeleagte <NSObject>

-(void)UpdateRoomList:(NSArray*)roomList;
-(void)RoomCreated:(NSDictionary*)roomInfo;

-(void)UpdatePlayerList:(NSMutableArray*)playerList;

//-(void)PlayerPrepared:(NSMutableArray*)playerList;
@end
