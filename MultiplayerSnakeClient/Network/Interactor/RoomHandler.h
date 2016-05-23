//
//  RoomHandler.h
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/23/16.
//  Copyright © 2016 Aloniki's Study. All rights reserved.
//

#import "Handler.h"

@interface RoomHandler : Handler

-(void)handle:(DataPacket*)packet;

@end
