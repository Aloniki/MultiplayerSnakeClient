//
//  RoomViewController.m
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/18/16.
//  Copyright © 2016 Aloniki's Study. All rights reserved.
//

#import "RoomViewController.h"

@interface RoomViewController()

@property (strong, nonatomic) NetworkManager* networkManager;
@property (strong, nonnull) NSMutableDictionary* host;
@property (strong, nonatomic) NSMutableArray* guestList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation RoomViewController

-(void)viewDidLoad{
    self.host = nil;
    self.guestList = [[NSMutableArray alloc]init];
    
    //init networkManager instance
    self.networkManager = [NetworkManager getNetworkManagerInstance];
    [self.networkManager setDelegate:self];
    
    [self.networkManager joinRoom];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (0 == section) {
        if (nil != self.host) {
            return 1;
        }else{
            return 0;
        }
    }else{
        return self.guestList.count;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SimpleTableIdentifier"];
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SimpleTableIdentifier"];
    }
    
    NSDictionary* showObject;
    if (0 == [indexPath section]) {
        showObject = self.host;
    }else{
        showObject = [self.guestList objectAtIndex:[indexPath row]];
    }
    
    [cell.textLabel setText:[showObject valueForKey:@"playerName"]];
    if (PS_PREPARED == [[showObject valueForKey:@"playerState"]intValue]) {
        [cell setBackgroundColor:[UIColor orangeColor]];
    }else{
        [cell setBackgroundColor:[UIColor yellowColor]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* showObject;
    if (0 == [indexPath section]) {
        showObject = self.host;
    }else{
        showObject = [self.guestList objectAtIndex:[indexPath row]];
    }
    
    if (PS_PREPARED == [[showObject valueForKey:@"playerState"]intValue]) {
        [self.networkManager playerUnprepare];
    }else{
        [self.networkManager playerPrepare];
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (0 == section) {
        return @"Host";
    }else{
        return @"Guest";
    }
}


-(void)UpdatePlayerList:(NSMutableArray *)playerList{
    for (NSMutableDictionary* player in playerList){
        if (RR_HOST == [[player valueForKey:@"playerRole"]intValue]) {
            self.host = player;
            break;
        }
    }
    [playerList removeObject:self.host];
    self.guestList = playerList;
    
    [self.tableView reloadData];
}


-(IBAction)backToGameHall:(id)sender{
    [self.networkManager leaveRoom];
connectToGameHall:
    [self.networkManager disconnectSocket];
    if (NO == [self.networkManager connectToRole:SERVERROLE inPort:C2SPORT]) {
        NSLog(@"Room: connect back to game hall failed!");
        goto connectToGameHall;
    }
    [self performSegueWithIdentifier:@"ExitRoomSegue" sender:self];
}



















@end
