//
//  Receiver.h
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/14/16.
//  Copyright © 2016 Aloniki's Study. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataPacketProtocol.h"
#import "Handler.h"

#define MAXLINE 5000

@interface Receiver : NSObject

+(DataPacket*)receiveOneTimeFrom:(CFSocketRef)socketfd within:(NSTimeInterval*)time;
+(void)receiveFrom:(CFSocketRef)socketfd withHandler:(Handler*)handler;

@end
