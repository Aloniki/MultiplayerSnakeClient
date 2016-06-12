//
//  SnakeGameView.h
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/24/16.
//  Copyright © 2016 Aloniki's Study. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataPacketProtocol.h"

@interface SnakeGameView : UIView

//@property (strong, nonatomic)NSMutableArray* inflectionPointsOfSnakes;
@property (strong, nonatomic)NSArray* snakeList;
@property (strong, nonatomic)NSDictionary* food;

-(void)initSetting;

@end
