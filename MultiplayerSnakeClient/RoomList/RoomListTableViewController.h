//
//  RoomListTableViewController.h
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/11/16.
//  Copyright © 2016 Aloniki's Study. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkManager.h"
#import "DisplayNetworkProcessUIDeleagte.h"
#import "CreateRoomViewController.h"
#import "LoginViewController.h"

@interface RoomListTableViewController : UITableViewController<DisplayNetworkProcessUIDeleagte,ParentCreateRoomModalViewDelegate>{
}

@end
