//
//  Sender.m
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/14/16.
//  Copyright © 2016 Aloniki's Study. All rights reserved.
//

#import "Sender.h"

@implementation Sender

+(BOOL)send:(int)signal toRole:(int)role withData:(id)data toSocket:(CFSocketNativeHandle)socketfd{
    NSString* packet = @"";
    switch (role) {
        case SERVERROLE:{
            switch (signal) {
                case C2S_EXIT:{
                    packet = [DataPacketProtocol PackToStringWithRole:CLIENTROLE withType:C2S_EXIT];
                    break;
                }
                case C2S_REQUIRE:{
                    packet = [DataPacketProtocol PackToStringWithRole:CLIENTROLE withType:C2S_REQUIRE];
                    NSLog(@"Require room list");
                    break;
                }
                case C2S_CREATE:{
                    packet = [DataPacketProtocol PackToStringWithRole:CLIENTROLE withType:C2S_CREATE withData:data];
                    break;
                }
                default:
                    break;
            }

            break;
        }
            
        case ROOMROLE:{
            switch (signal) {
                case C2R_LEAVE:{
                    packet = [DataPacketProtocol PackToStringWithRole:CLIENTROLE withType:C2R_LEAVE];
                    break;
                }
                case C2R_JOIN:
                    packet = [DataPacketProtocol PackToStringWithRole:CLIENTROLE withType:C2R_JOIN withData:data];
                    break;
                case C2R_PREPARE:{
                    packet = [DataPacketProtocol PackToStringWithRole:CLIENTROLE withType:C2R_PREPARE];
                    break;
                }
                case C2R_UNPREPARE:{
                    packet = [DataPacketProtocol PackToStringWithRole:CLIENTROLE withType:C2R_UNPREPARE];
                    break;
                }
                    
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
    const char* c_packet = [packet UTF8String];
    size_t length = strlen(c_packet);
    size_t wCount = 0;
    size_t rCount = length;
    ssize_t n = 0;
    while (true) {
        n = write(socketfd, c_packet, rCount);
        if (-1 == n) {
            NSLog(@"error:%d!",errno);
            close(socketfd);
            return NO;
        }
        wCount += n;
        if (wCount >= length) {
            break;
        }
        c_packet += wCount;
        rCount -= wCount;
    }
    
    return YES;
}

@end
