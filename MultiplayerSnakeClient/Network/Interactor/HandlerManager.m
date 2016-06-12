//
//  HandlerManager.m
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/24/16.
//  Copyright © 2016 Aloniki's Study. All rights reserved.
//

#import "HandlerManager.h"

@implementation HandlerManager

-(void)setUsingHandler:(Handler *)handler{
    [self setHandler:handler];
    [self.handler setDelegate:self.delegate];
}

-(void)assignToSuitableHanlder:(DataPacket*)packet{
    [self.handler handle:packet];
}

@end
