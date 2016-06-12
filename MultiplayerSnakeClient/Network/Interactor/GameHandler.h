//
//  GameHandler.h
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/23/16.
//  Copyright © 2016 Aloniki's Study. All rights reserved.
//

#import "Handler.h"

@interface GameHandler : Handler

-(bool)handle:(DataPacket*)packet;

@end
