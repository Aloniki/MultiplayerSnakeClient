//
//  Sender.h
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/14/16.
//  Copyright © 2016 Aloniki's Study. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CFNetwork/CFNetwork.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import "inet.h"
#import "DataPacketProtocol.h"

@interface Sender : NSObject

+(BOOL)send:(int)signal toRole:(int)role withData:(id)data toSocket:(CFSocketNativeHandle)socketfd;

@end
