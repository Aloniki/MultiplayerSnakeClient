//
//  NetworkManager.m
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/12/16.
//  Copyright © 2016 Aloniki's Study. All rights reserved.
//

#import "NetworkManager.h"
#import "HandlerManager.h"
#import "RoomHandler.h"
#import "GameHandler.h"

static NetworkManager* networkManager;

#pragma mark - interface -

@interface NetworkManager()

@property (readwrite, nonatomic) CFSocketRef socket;
@property (strong, nonatomic) NSMutableDictionary* playerStatus;
@property (strong, nonatomic) HandlerManager* handlerManager;
@end

#pragma mark - implementation -

@implementation NetworkManager

#pragma mark - get / set methods

+(NetworkManager*)getNetworkManagerInstance{
    if (nil == networkManager) {
        networkManager = [[NetworkManager alloc]init];
        if (nil == networkManager.playerStatus) {
            networkManager.playerStatus = [[NSMutableDictionary alloc]initWithCapacity:4];
            [networkManager.playerStatus setValue:[[NSNumber alloc] initWithInt:0] forKey:@"playerDescriptor"];
            [networkManager.playerStatus setValue:@"player" forKey:@"playerName"];
            [networkManager.playerStatus setValue:[[NSNumber alloc] initWithInt:0] forKey:@"playerState"];
            [networkManager.playerStatus setValue:[[NSNumber alloc] initWithInt:0] forKey:@"playerRole"];
            [networkManager setHandlerManager:[[HandlerManager alloc]init]];
        }
    }
    return networkManager;
}

-(void)setMinePlayerStatus:(NSMutableDictionary*)playerStatus{
    self.playerStatus = playerStatus;
}

-(int)getPlayerDescriptor{
    return [[self.playerStatus valueForKey:@"playerDescriptor"]intValue];
}
-(void)setPlayerDescriptor:(int)descriptor{
    [self.playerStatus setValue:[[NSNumber alloc] initWithInt:descriptor] forKey:@"playerDescriptor"];
}

-(NSString*)getPlayerName{
    return [self.playerStatus valueForKey:@"playerName"];
}
-(void)setPlayerName:(NSString*)name{
    [self.playerStatus setValue:name forKey:@"playerName"];
}

-(int)getPlayerState{
    return [[self.playerStatus valueForKey:@"playState"]intValue];
}
-(void)setPlayerState:(int)state{
    [self.playerStatus setValue:[[NSNumber alloc] initWithInt:state] forKey:@"playerState"];
}

-(int)getPlayerRole{
    return [[self.playerStatus valueForKey:@"playerRole"]intValue];
}
-(void)setPlayerRole:(int)role{
    [self.playerStatus setValue:[[NSNumber alloc] initWithInt:role] forKey:@"playerRole"];
}
#pragma mark - common methods of socket connection-

-(BOOL)testSocket{
    if (!CFSocketIsValid(self.socket)) {
        return false;
    }
    return true;
}

-(void)disconnectSocket{
    CFSocketNativeHandle socketfd = CFSocketGetNative(self.socket);
    CFSocketInvalidate(self.socket);
    close(socketfd);
    self.socket = nil;
}

-(BOOL)connectToRole:(int)role inPort:(int)port{
    CFSocketRef newSocket = CFSocketCreate(NULL, PF_INET, SOCK_STREAM, IPPROTO_TCP,kCFSocketConnectCallBack, NULL, NULL);
    self.socket = newSocket;
    if (self.socket == NULL)
        return NO;
    
    /* Set the port and address we want to listen on */
    struct sockaddr_in addr;
    memset(&addr, 0, sizeof(addr));
    addr.sin_len = sizeof(addr);
    addr.sin_family = AF_INET;
    addr.sin_port = htons(port);
    inet_pton(AF_INET, SERVERIPADDRESS, &addr.sin_addr);
    CFDataRef connectAddr = CFDataCreate(NULL, (unsigned char *)&addr, sizeof(addr));
    if (kCFSocketSuccess == CFSocketConnectToAddress(self.socket, connectAddr, 5)) {
        return YES;
    }

    return NO;
}

#pragma mark - methods of interacting with server -

-(BOOL)exitGameHallServer{
    if (CFSocketIsValid(self.socket)) {
        CFSocketNativeHandle socketfd = CFSocketGetNative(self.socket);
        if (YES == [Sender send:C2S_EXIT toRole:SERVERROLE withData:nil toSocket:socketfd]) {
            return YES;
        }else{
            return NO;
        }
    }
    return NO;
}

/**
 *  require room list from server
 *
 *  @return success or fail
 */
-(BOOL)requireRoomList{
    if (CFSocketIsValid(self.socket)) {
        CFSocketNativeHandle socketfd = CFSocketGetNative(self.socket);
        if ( YES == [Sender send:C2S_REQUIRE toRole:SERVERROLE withData:nil toSocket:socketfd]) {
            DataPacket* dataPacket = [Receiver receiveOneTimeFrom:self.socket within:5];
            if (nil != dataPacket) {
                if (S2C_REQUIRED == dataPacket.type) {
                    NSMutableArray* roomList = [dataPacket.data mutableObjectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegate UpdateRoomList:roomList];
                    });
                    return YES;
                }
            }else{
                CFSocketInvalidate(self.socket);
                close(socketfd);
            }
        }
    }
    return NO;
}

/**
 *  ask the server to create a new room
 *
 *  @param roomName   room name
 *  @param maxPlayers max player numbers
 *
 *  @return success or fail
 */
-(BOOL)createRoom:(NSString *)roomName withMaxPlayers:(int)maxPlayers{
    if (CFSocketIsValid(self.socket)) {
        CFSocketNativeHandle socketfd = CFSocketGetNative(self.socket);
        NSDictionary* roomSetting = @{@"roomName":roomName,@"maxPlayers":[[NSNumber alloc]initWithInt:maxPlayers]};
        NSString* jsData = [roomSetting JSONString];
        if (YES == [Sender send:C2S_CREATE toRole:SERVERROLE withData:jsData toSocket:socketfd]) {
            DataPacket* dataPacket = [Receiver receiveOneTimeFrom:self.socket within:5];
            if (nil != dataPacket) {
                if (S2C_CREATED == dataPacket.type) {
                    [self setPlayerRole: RR_HOST];
                    NSMutableDictionary* roomInfo = [dataPacket.data mutableObjectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegate RoomCreated:roomInfo];
                    });
                }
            }
        }
    }
    return YES;
}

#pragma mark - methods of interacting with room
/**
 *  send player info to the room
 *
 *  @param role player role : host or guest
 *
 *  @return success or fail
 */
-(BOOL)joinRoom{
    if (CFSocketIsValid(self.socket)) {
        CFSocketNativeHandle socketfd = CFSocketGetNative(self.socket);
        NSString* jsData = [self.playerStatus JSONString];
        if (YES == [Sender send:C2R_JOIN toRole:ROOMROLE withData:jsData toSocket:socketfd]) {
            DataPacket* dataPacket = [Receiver receiveOneTimeFrom:self.socket within:5];
            if (nil != dataPacket) {
                if (R2C_JOINED == dataPacket.type) {
                    NSLog(@"join to the new room!");
                    NSMutableDictionary* player = [dataPacket.data mutableObjectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegate UpdateSelfPlayer:player];
                    });
                    //run a receiver in a new thread
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    dispatch_async(queue, ^{
//                        [self.handlerManager setDelegate:self.delegate];
//                        [self.handlerManager setUsingHandler:[[RoomHandler alloc]init]];
                        
                        RoomHandler* roomHandler = [[RoomHandler alloc]init];
                        [roomHandler setDelegate:self.delegate];
                        [Receiver receiveFrom:self.socket withHandler:roomHandler];
                    });
                }
            }
        }
    }
    return NO;
}

-(void)runReceiverAndHandler{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, YES);
    dispatch_async(queue, ^{
        
    });
}

-(BOOL)leaveRoom{
    if (CFSocketIsValid(self.socket)) {
        CFSocketNativeHandle socketfd = CFSocketGetNative(self.socket);
        if (YES == [Sender send:C2R_LEAVE toRole:ROOMROLE withData:nil toSocket:socketfd]) {
            return YES;
        }else{
            return NO;
        }
    }
    return NO;
}

-(BOOL)playerPrepare{
    if (CFSocketIsValid(self.socket)) {
        CFSocketNativeHandle socketfd = CFSocketGetNative(self.socket);
        if (YES == [Sender send:C2R_PREPARE toRole:ROOMROLE withData:nil toSocket:socketfd]) {
            return YES;
        }else{
            NSLog(@"error: sending prepare signal to room is failed");
            return NO;
        }
    }
    return NO;
}

-(BOOL)playerUnprepare{
    if (CFSocketIsValid(self.socket)) {
        CFSocketNativeHandle socketfd = CFSocketGetNative(self.socket);
        if (YES == [Sender send:C2R_UNPREPARE toRole:ROOMROLE withData:nil toSocket:socketfd]) {
            return YES;
        }else{
            NSLog(@"error: sending unprepare signal to room is failed");
            return NO;
        }
    }
    return NO;
}

-(BOOL)startGame{
    if (CFSocketIsValid(self.socket)) {
        CFSocketNativeHandle socketfd = CFSocketGetNative(self.socket);
        if (YES == [Sender send:C2R_START toRole:(ROOMROLE) withData:nil toSocket:socketfd]) {
            return YES;
        }else{
            NSLog(@"error: sending start signal to room is failed");
            return NO;
        }
    }
    return NO;
}

-(BOOL)GameSceneLoaded{
    if (CFSocketIsValid(self.socket)) {
        CFSocketNativeHandle socketfd = CFSocketGetNative(self.socket);
        if (YES == [Sender send:C2R_GAMELOADED toRole:(ROOMROLE) withData:nil toSocket:socketfd]) {
            DataPacket* dataPacket = [Receiver receiveOneTimeFrom:self.socket within:5];
            if (nil != dataPacket) {
                if (R2C_GAMESTART == dataPacket.type) {
                    NSMutableArray* gameFrameContent = [dataPacket.data mutableObjectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegate StartPlaying:gameFrameContent];
                    });
                    
                    //run a receiver in a new thread
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    dispatch_async(queue, ^{
//                        [self.handlerManager setDelegate:self.delegate];
//                        [self.handlerManager setUsingHandler:[[GameHandler alloc]init]];
                        GameHandler* gameHandler = [[GameHandler alloc]init];
                        [gameHandler setDelegate:self.delegate];
                        [Receiver receiveFrom:self.socket withHandler:gameHandler];
                    });
                }
            }
        }else{
            NSLog(@"error: sending game loaded signal to room is failed");
            return NO;
        }
    }
    return NO;
}


-(BOOL)changeDirection:(int)direction{
    if (CFSocketIsValid(self.socket)) {
        CFSocketNativeHandle socketfd = CFSocketGetNative(self.socket);
        if (YES == [Sender send:direction toRole:(GAMEROLE) withData:nil toSocket:socketfd]) {
            return YES;
        }else{
            NSLog(@"error: sending changeing direction signal to room is failed");
            return NO;
        }
    }
    return NO;
}










@end
