//
//  GameHandler.m
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/23/16.
//  Copyright © 2016 Aloniki's Study. All rights reserved.
//

#import "GameHandler.h"

@implementation GameHandler

-(bool)handle:(DataPacket*)packet{
    bool isStillReceive = false;
    switch (packet.type) {
        case G2P_UPDATE:{
            NSMutableArray* gameFrameContent = [packet.data mutableObjectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
            NSMutableArray* __weak tmp = gameFrameContent;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate newFrame:tmp];
            });
//            NSLog(@"new frame received and handler!");
            break;
        }
        case G2P_GAMEOVER:{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate gameOver];
            });
            break;
        }
        default:
            break;
    }
    return isStillReceive;
}

@end
