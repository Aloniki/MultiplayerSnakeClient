//
//  Receiver.m
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/14/16.
//  Copyright © 2016 Aloniki's Study. All rights reserved.
//

#import "Receiver.h"


size_t recvCount;                   //the count of received data
size_t packetLength;                //the length of a packet
char recvr[MAXLINE];                 //saves the data in one read
char buf[MAXLINE];                  //saves the hole unpakcet data
char head[DATALENGTH + 1];          //saves the packet length


@implementation Receiver

+(DataPacket*)receiveOneTimeFrom:(CFSocketRef)socket within:(NSTimeInterval *)time{
    CFSocketNativeHandle socketfd = CFSocketGetNative(socket);
    /**
     *  解决接受粘包
     */
    while (CFSocketIsValid(socket)) {
        ssize_t readResult;                                 //the value of read return
        bzero(recvr, MAXLINE);                                   //clear the receive buffer
        
        if (0 >= (readResult = read(socketfd, &recvr, MAXLINE))){//read error handle
            if (EINTR == errno) {
                NSLog(@"ERROR:EINTR!");
            }
            close(socketfd);                            //close this socket connection
            break;
        }
        
        NSLog(@"%s",recvr);
        
        strcat(buf, recvr);                                  //copy to packet buffer
        recvCount += strlen(recvr);
        
        if (DATALENGTH <= recvCount && 0 == packetLength) {          //get the packet length
            bzero(head, sizeof(head));
            strncpy(head, buf, DATALENGTH);
            packetLength = atoi(head);
        }
        if (0 < packetLength && recvCount >= packetLength) {//get the complete packet
            size_t i = packetLength;
            while ('\0' != buf[i]) {
                buf[i++] = '\0';
            }
            NSString* raw   = [NSString stringWithUTF8String:buf];
            
            NSLog(@"Complete Packet:%@",raw);
            
            recvCount     = 0;
            packetLength  = 0;
            bzero(buf, MAXLINE);
            
            return [DataPacketProtocol UnpackString:raw];
        }
    }
    return nil;
}

+(void)receiveFrom:(CFSocketRef)socket withHandler:(Handler *)handler{
    CFSocketNativeHandle socketfd = CFSocketGetNative(socket);
    /**
     *  解决接受粘包
     */
    while (CFSocketIsValid(socket)) {
        ssize_t readResult;                                 //the value of read return
        bzero(recvr, MAXLINE);                                   //clear the receive buffer
        
        if (0 >= (readResult = read(socketfd, &recvr, MAXLINE))){//read error handle
            if (EINTR == errno) {
                NSLog(@"ERROR:EINTR!");
            }
            close(socketfd);                            //close this socket connection
            break;
        }
        
        NSLog(@"%s",recvr);
        
        strcat(buf, recvr);                                  //copy to packet buffer
        recvCount += strlen(recvr);
        
    PACKETSEPARATE:
        if (DATALENGTH <= recvCount && 0 == packetLength) {          //get the packet length
            bzero(head, sizeof(head));
            strncpy(head, buf, DATALENGTH);
            packetLength = atoi(head);
        }
        if (0 < packetLength && recvCount == packetLength) {//get the complete packet
            NSString* packet   = [NSString stringWithUTF8String:buf];
            NSLog(@"Complete Packet:%@",packet);
            
            [handler handle:[DataPacketProtocol UnpackString:packet]];
            
            recvCount     = 0;
            packetLength  = 0;
            bzero(buf, MAXLINE);
        }else if (0 < packetLength && recvCount > packetLength){//more than a packet
            char* tmp = (char*)malloc(packetLength*sizeof(char));
            tmp = strncpy(tmp, buf, packetLength);
            NSString* packet   = [NSString stringWithUTF8String:tmp];
            NSLog(@"Complete Packet:%@",packet);
            
            [handler handle:[DataPacketProtocol UnpackString:packet]];
            
            recvCount   -= packetLength;
            char* remain = (char*)malloc(packetLength*sizeof(char));
            remain = strncpy(remain, buf + packetLength, recvCount);
            packetLength = 0;
            bzero(buf, MAXLINE);
            strcpy(buf, remain);
            
            if (DATALENGTH <= strlen(buf)) {//figures out reads sereval packets in a time
                goto PACKETSEPARATE;//if buffer may contain more entire packets, run again
            }
        }
    }
    NSLog(@"receiver: stop receiving!");
}


@end
