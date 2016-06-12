//
//  RoomHandler.m
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/23/16.
//  Copyright © 2016 Aloniki's Study. All rights reserved.
//

#import "RoomHandler.h"

@implementation RoomHandler

-(bool)handle:(DataPacket*)packet{
    bool isGameWillStart = false;
    
    switch (packet.type) {
        case R2C_UPDATE:{
            NSMutableArray* playerList = [packet.data mutableObjectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate UpdatePlayerList:playerList];
            });
            break;
        }
        case R2C_GAMEWILLSTART:{
            isGameWillStart = true;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate GameWillStart];
            });
            break;
        }
        case R2C_GAMEWILLSTOP:{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate GameStopStarting];
            });
            break;
        }
        case R2C_INVALID:{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate InvalidOperation];
            });
            break;
        }
        default:
            break;
    }
    return isGameWillStart;
}

@end
