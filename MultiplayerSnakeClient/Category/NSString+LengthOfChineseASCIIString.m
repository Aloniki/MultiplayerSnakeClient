//
//  NSString+LengthOfChineseASCIIString.m
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/16/16.
//  Copyright © 2016 Aloniki's Study. All rights reserved.
//

#import "NSString+LengthOfChineseASCIIString.h"

@implementation NSString (LengthOfChineseASCIIString)

-(int)lengthOfChineseASCIIString{
    const char* cstr = [self UTF8String];
    return strlen(cstr);
}

@end
