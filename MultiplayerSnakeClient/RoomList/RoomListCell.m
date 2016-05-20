//
//  RoomListCell.m
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/11/16.
//  Copyright © 2016 Aloniki's Study. All rights reserved.
//

#import "RoomListCell.h"

#pragma mark - interface -
@interface RoomListCell()

@property (weak, nonatomic) IBOutlet UILabel* roomNameLabel;
@property (weak, nonatomic) IBOutlet UILabel* playerNumbersLabel;



@end

#pragma mark - implementation -

@implementation RoomListCell

#pragma makr - set properties and update UI

-(void)setCell:(NSDictionary *)roomInfo{
    [self setRoomName:[roomInfo valueForKey:@"roomName"]];
    [self setMaxPlayers:[[roomInfo valueForKey:@"maxPlayers"]integerValue]];
    [self setCurrentPlayers:[[roomInfo valueForKey:@"currentPlayers"]integerValue]];
    [self.playerNumbersProgress setTransform:CGAffineTransformMakeScale(1, 25)];
}
-(void)setRoomName:(NSString *)roomName{
    _roomName = [roomName copy];
    self.roomNameLabel.text = _roomName;
}
-(void)setMaxPlayers:(NSInteger)maxPlayers{
    _maxPlayers = maxPlayers;
    self.playerNumbersLabel.text = [NSString stringWithFormat:@"%d / %d",(int)_currentPlayers, (int)_maxPlayers];
    [self.playerNumbersProgress setProgress:(float)_currentPlayers/(float)_maxPlayers];
}
-(void)setCurrentPlayers:(NSInteger)currentPlayers{
    _currentPlayers = currentPlayers;
    self.playerNumbersLabel.text = [NSString stringWithFormat:@"%d / %d",(int)_currentPlayers, (int)_maxPlayers];
    [self.playerNumbersProgress setProgress:(float)_currentPlayers/(float)_maxPlayers];
}


@end
