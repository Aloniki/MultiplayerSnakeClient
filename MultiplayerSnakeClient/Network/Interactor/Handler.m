//
//  Handler.m
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/19/16.
//  Copyright © 2016 Aloniki's Study. All rights reserved.
//

#import "Handler.h"

@implementation Handler

-(void)handle:(DataPacket *)packet{
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (packet.type) {
            case R2C_UPDATE:{
                NSMutableArray* playerList = [packet.data mutableObjectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
                [self.delegate UpdatePlayerList:playerList];
                break;
            }
            case R2C_GAMEWILLSTART:{
                [self.delegate GameWillStart];
                break;
            }
            case R2C_GAMEWILLSTOP:{
                [self.delegate GameStopStarting];
                break;
            }
            case R2C_INVALID:{
                [self.delegate InvalidOperation];
                break;
            }
            default:
                break;
        }
    });
}

-(void)prepared{
    
}

@end
