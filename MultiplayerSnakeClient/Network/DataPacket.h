//
//  DataPacket.h
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/14/16.
//  Copyright © 2016 Aloniki's Study. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataPacket : NSObject

@property (readwrite, nonatomic) int role;
@property (readwrite, nonatomic) int type;
@property (copy, nonatomic) NSString* data;

@end
