//
//  GameHandler.m
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/23/16.
//  Copyright © 2016 Aloniki's Study. All rights reserved.
//

#import "GameHandler.h"

@implementation GameHandler

-(void)handle:(DataPacket*)packet{
    switch (packet.type) {
            
        case R2C_GAMESTART:{
            break;
        }
        default:
            break;
    }
}

@end
