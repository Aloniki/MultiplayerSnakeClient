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
@property (strong, nonatomic) NSMutableDictionary* roomInfo;
@property (strong, nonatomic) NSMutableDictionary* host;
@property (strong, nonatomic) NSMutableDictionary* me;
@property (strong, nonatomic) NSMutableArray* guestList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView* statusView;
@property (strong, nonatomic) CircleIndicatorView* circleIndicator ;
@property (strong, nonatomic) UIActivityIndicatorView* daizy;

@property (readwrite, nonatomic) int waitingTimes;

@property (readwrite, nonatomic) BOOL isStarting;

@end

@implementation RoomViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self.statusView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.statusView.frame.size.height)];
    self.circleIndicator = [[CircleIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 45, 45) withCenter:CGPointMake(22.5, 22.5) withRaidus:18 withStartAngle:-90 withClockwise:0];
    [self.circleIndicator setCenter:CGPointMake(self.statusView.center.x, self.statusView.frame.size.height/2)];
    [self.circleIndicator setDelegate:self];
    [self.statusView addSubview:self.circleIndicator];
    [self.circleIndicator show];
    
    self.host = nil;
    self.guestList = [[NSMutableArray alloc]init];
    self.waitingTimes = 0;
    self.isStarting = NO;
    
    //launch daizy
    [self launchDaizy];
    //init network manager and join room
    [self connectAndJoinRoom];
    
}

- (void)launchDaizy {
    if (!_daizy) {
        _daizy = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_daizy setColor:[UIColor orangeColor]];
        [_daizy setCenter:self.view.center];
        [_daizy setHidesWhenStopped:YES];
        [self.view addSubview:_daizy];
    }
    [self.daizy startAnimating];
    [self.view setUserInteractionEnabled:NO];
    [self.tableView setUserInteractionEnabled:NO];
}

-(void)stopDaizy{
    [self.daizy stopAnimating];
    [self.view setUserInteractionEnabled:YES];
    [self.tableView setUserInteractionEnabled:YES];
}


-(void)connectAndJoinRoom{
    //init networkManager instance
    self.networkManager = [NetworkManager getNetworkManagerInstance];
    [self.networkManager setDelegate:self];
    //join room
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        int port = [[self.roomInfo valueForKey:@"port"]intValue];
        if ([self.networkManager connectToRole:ROOMROLE inPort:port]) {
            [self.networkManager joinRoom];
        }
    });
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

-(void)releaseInteractProtection:(NSTimer*)timer{
    [self stopDaizy];
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (0 == section) {
        return @"Host";
    }else{
        return @"Guest";
    }
}

-(void)UpdateSelfPlayer:(NSMutableDictionary *)player{
    [self setMe:player];
    [self.networkManager setMinePlayerStatus:player];
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
    [self stopDaizy];
}

-(IBAction)backToGameHall:(id)sender{
    [self.networkManager leaveRoom];
    [self.networkManager disconnectSocket];
    [self performSegueWithIdentifier:@"ExitRoomSegue" sender:self];
}




-(void)GameWillStart{
    [self setIsStarting:YES];
//    [self.circleIndicator show];
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
        if (60 > ++self.waitingTimes) {
            [self.circleIndicator update:(float)self.waitingTimes / 60.0];
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

-(void)StartGameByHost{
    NSLog(@"start game by host!");
    if (!self.isStarting) {
        if (RR_HOST == [[self.me valueForKey:@"playerRole"]intValue]) {
            [self.networkManager startGame];
        }else{
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Start Alert"
                                                                           message:@"Only the host of the room can start game."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action){
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }else{
        NSLog(@"already starting!");
    }
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskPortrait;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}














@end
