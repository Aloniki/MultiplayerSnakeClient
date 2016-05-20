//
//  DataPacketProtocol.m
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/14/16.
//  Copyright © 2016 Aloniki's Study. All rights reserved.
//

#import "DataPacketProtocol.h"

@implementation DataPacketProtocol

+(NSString*)PackToStringWithRole:(int)role withType:(int)type withData:(id)data{
    
    NSString* content = [NSString stringWithFormat:@"%@",data];
    int length = (int)(PACKETHEADLENGTH + [content lengthOfChineseASCIIString]);
    NSString* dataPacket = [NSString stringWithFormat:@"%04d%d%d%@",length,role,type,content];
    
    return dataPacket;
}

+(NSString*)PackToStringWithRole:(int)role withType:(int)type{
    NSString* dataPacket = [NSString stringWithFormat:@"%04d%d%d",PACKETHEADLENGTH,role,type];
    
    return dataPacket;
}

+(DataPacket*)UnpackString:(NSString *)dataPacket{
//    DataPacket packet;
//    packet.role = dataPacket->at(DATALENGTH) - ASCIINUMOFFSET;
//    packet.type = dataPacket->at(DATALENGTH + ROLELENGTH) -ASCIINUMOFFSET;
//    packet.rawStr = dataPacket->substr(PACKETHEADLENGTH);
    DataPacket* packet = [[DataPacket alloc]init];
    packet.role = [dataPacket characterAtIndex:DATALENGTH] - ASCIINUMOFFSET;
    packet.type = [dataPacket characterAtIndex:DATALENGTH+ROLELENGTH] - ASCIINUMOFFSET;
    packet.data = [dataPacket substringFromIndex:PACKETHEADLENGTH];
    
    return packet;
}

@end
