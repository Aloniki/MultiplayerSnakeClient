//
//  RoomListCell.h
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/11/16.
//  Copyright © 2016 Aloniki's Study. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomListCell : UITableViewCell

@property (copy, nonatomic) NSString* host;
@property (readwrite, nonatomic) NSInteger maxPlayers;
@property (readwrite, nonatomic) NSInteger currentPlayers;

@property (weak, nonatomic) IBOutlet UIProgressView *playerNumbersProgress;
@end

