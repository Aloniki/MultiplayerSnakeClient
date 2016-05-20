//
//  CreateRoomViewController.h
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/14/16.
//  Copyright © 2016 Aloniki's Study. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ParentCreateRoomModalViewDelegate <NSObject>

-(void)cancleCreatingRoom;
-(void)confirmCreatingRoom:(NSString*)roomName withMaxPlayers:(int)players;

@end

@interface CreateRoomViewController : UIViewController{
    id<ParentCreateRoomModalViewDelegate> delegate;
}
@property id<ParentCreateRoomModalViewDelegate> delegate;

@end
