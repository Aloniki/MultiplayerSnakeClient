//
//  GameHandler.h
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/23/16.
//  Copyright © 2016 Aloniki's Study. All rights reserved.
//

#import "Handler.h"

@interface GameHandler : Handler

-(void)handle:(DataPacket*)packet;

@end
