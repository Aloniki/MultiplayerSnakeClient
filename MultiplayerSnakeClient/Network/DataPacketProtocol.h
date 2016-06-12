//
//  DataPacketProtocol.h
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/14/16.
//  Copyright © 2016 Aloniki's Study. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataPacket.h"
#import "NSString+LengthOfChineseASCIIString.h"


//define length of different parts in the packet head
#define PACKETHEADLENGTH 6
#define DATALENGTH 4
#define ROLELENGTH 1
#define TYPELENGTH 1
//define roles
#define SERVERROLE 1
#define CLIENTROLE 2
#define ROOMROLE 4
#define GAMEROLE 8
#define STRINGTYPE 1
//define the offset of the char '0' to the num 0 in standard ASCII
#define ASCIINUMOFFSET 48

/**
 *  the states of player which is in room
 */
enum RoomPlayerRole{
    RR_HOST         = 1,
    RR_GUEST        = 2,
};
/**
 *  the states of player which is in room
 */
enum PlayerState{
    PS_UNPREPARED   =       0,
    PS_PREPARED     =       1,
    PS_GAMING       =       2,
};
/**
 *  the states of snake
 */
enum SnakeState{
    SS_DEAD = 0,
    SS_ALIVE = 1,
};

/**
 *  client to server signal types
 */
enum C2SSignal{
    C2S_INVALID     =  -1,
    C2S_EXIT        =   0,
    C2S_REQUIRE     =   1,
    C2S_CREATE      =   2,
};
/**
 *  server to client signal types
 */
enum S2CSignal{
    S2C_REQUIRED = 1,
    S2C_CREATED  = 2,
};
/**
 *  room to server signal types
 */
enum R2SSignal{
    CLOSED      =   0,
    CREATED     =   1,
    UPDATED     =   2,
    STARTED     =   3,
};
/**
 *  room to server signal types
 */
enum C2RSignal{
    C2R_LEAVE       =   0,
    C2R_JOIN        =   1,
    C2R_PREPARE     =   2,
    C2R_UNPREPARE   =   3,
    C2R_START       =   4,
    C2R_GAMELOADED  =   5,
};
/**
 *  room to client signal types
 */
enum R2CSignal{
    R2C_INVALID     = -1,
    R2C_JOINED      = 1,
    R2C_PREPARED    = 2,
    R2C_UNPREPARED  = 3,
    R2C_GAMEWILLSTART = 4,
    R2C_UPDATE      = 5,
    R2C_GAMEWILLSTOP = 6,
    R2C_GAMESTART   =  7,

};
/**
 *  player to game manager signal types
 */
enum P2GSignal{
    P2G_UP  = 1,
    P2G_DOWN = 2,
    P2G_LEFT = 3,
    P2G_RIGHT = 4,
};
/**
 *  game manager to player signal types
 */
enum G2PSignal{
    G2P_GAMEOVER = 8,
    G2P_UPDATE = 9,
};

@interface DataPacketProtocol : NSObject

+(NSString*)PackToStringWithRole:(int)role withType:(int)type withData:(id)data;
+(NSString*)PackToStringWithRole:(int)role withType:(int)type;
+(DataPacket*)UnpackString:(NSString*)dataPacket;

/**
 *  Use to record the role, type and raw string from a data packet
 */
//Class DataPacket{
//    int role;
//    int type;
//    NSString* rawStr;
//};

@end
