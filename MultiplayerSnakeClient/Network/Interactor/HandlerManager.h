//
//  HandlerManager.h
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/24/16.
//  Copyright © 2016 Aloniki's Study. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoomHandler.h"
#import "GameHandler.h"

@interface HandlerManager : NSObject{
    id<DisplayNetworkProcessUIDeleagte> delegate;
}
@property id<DisplayNetworkProcessUIDeleagte> delegate;

@property (strong) Handler* handler;

-(void)setUsingHandler:(Handler *)handler;
-(void)assignToSuitableHanlder:(DataPacket*)packet;

@end
