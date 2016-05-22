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
@property (strong, nonatomic) NSMutableDictionary* host;
@property (strong, nonatomic) NSMutableArray* guestList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView* statusView;
@property (strong, nonatomic) CircleIndicatorView* circleIndicator ;

@property (readwrite, nonatomic) int waitingTimes;

@property (readwrite, nonatomic) BOOL isStarting;

@end

@implementation RoomViewController

-(void)viewDidLoad{
    [self.statusView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.statusView.frame.size.height)];
    self.circleIndicator = [[CircleIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 45, 45) withCenter:CGPointMake(22.5, 22.5) withRaidus:18 withStartAngle:-90 withClockwise:0];
    [self.circleIndicator setCenter:CGPointMake(self.statusView.center.x, self.statusView.frame.size.height/2)];
    [self.statusView addSubview:self.circleIndicator];
    
    self.host = nil;
    self.guestList = [[NSMutableArray alloc]init];
    self.waitingTimes = 0;
    
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
    [self.networkManager disconnectSocket];
    [self performSegueWithIdentifier:@"ExitRoomSegue" sender:self];
}

-(void)GameWillStart{
    [self setIsStarting:YES];
    [self.circleIndicator show];
    [NSTimer scheduledTimerWithTimeInterval:1.0/60.0 target:self selector:@selector(countDownToStart:) userInfo:nil repeats:YES];
}

-(void)InvalidOperation{
    [self.tableView reloadData];
}

-(void)GameStopStarting{
    [self setIsStarting:NO];
}

-(void)countDownToStart:(NSTimer*)timer{
    if (self.isStarting) {
        if (240 > ++self.waitingTimes) {
            [self.circleIndicator update:(float)self.waitingTimes / 240.0];
            [self.circleIndicator setNeedsDisplay];
        }else{
            [self setWaitingTimes:0];
            [timer invalidate];
            [self.circleIndicator hide];
            [self performSegueWithIdentifier:@"StartGameSegue" sender:self];
        }
    }else{
        [self setWaitingTimes:0];
        [timer invalidate];
        [self.circleIndicator hide];
    }
}



















@end
