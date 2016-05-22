//
//  RoomViewController.h
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/18/16.
//  Copyright © 2016 Aloniki's Study. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkManager.h"
#import "DisplayNetworkProcessUIDeleagte.h"
#import "CircleIndicatorView.h"
#import <CoreGraphics/CoreGraphics.h>

@interface RoomViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,DisplayNetworkProcessUIDeleagte>

-(void)exitRoom;

@end
