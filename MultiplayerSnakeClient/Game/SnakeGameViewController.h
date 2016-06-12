//
//  SnakeGameViewController.h
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/24/16.
//  Copyright © 2016 Aloniki's Study. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackgroundGameView.h"
#import "SnakeGameView.h"
#import "NetworkManager.h"
#import "DisplayNetworkProcessUIDeleagte.h"

@interface SnakeGameViewController : UIViewController<DisplayNetworkProcessUIDeleagte>

@end
