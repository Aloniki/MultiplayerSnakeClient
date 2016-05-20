//
//  RoomListCell.m
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/11/16.
//  Copyright © 2016 Aloniki's Study. All rights reserved.
//

#import "RoomListCell.h"

@interface RoomListCell()

@property (weak, nonatomic) IBOutlet UILabel* hostLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerNumbersLabel;



@end

@implementation RoomListCell

-(void)setHost:(NSString *)host{
    _host = [host copy];
    self.hostLabel.text = _host;
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
