//
//  RoomListTableViewController.m
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/11/16.
//  Copyright © 2016 Aloniki's Study. All rights reserved.
//

#import "RoomListTableViewController.h"
#import "RoomListCell.h"

static NSString *RoomListCellIdentifier = @"CellTableIdentifier";

#pragma mark - interface -
@interface RoomListTableViewController()

@property (strong, nonatomic) UIActivityIndicatorView* daizy;

@property (strong, nonatomic) NetworkManager* networkManager;
@property (strong, nonatomic) NSArray* roomList;

@property (strong, nonatomic) CreateRoomViewController* createRoomView;

@end

#pragma mark - implementation -

@implementation RoomListTableViewController

#pragma mark - view methods -


-(void)viewDidLoad{
    [super viewDidLoad];
    //view settings
    UITableView* tableView = (id)[self.view viewWithTag:1];
    tableView.rowHeight = 50;
    UIEdgeInsets contentInset = tableView.contentInset;
    contentInset.top = 20;
    //load table view cell from nib
    UINib* nib = [UINib nibWithNibName:@"RoomListCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:RoomListCellIdentifier];
    //launch daizy
    [self launchDaizy];
    
    //init properties;
    [self initProperties];
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
}

-(void)stopDaizy{
    [self.daizy stopAnimating];
    [self.view setUserInteractionEnabled:YES];
}

- (void)initProperties {
    self.roomList = [[NSArray alloc]init];
    
    //init networkManager instance
    self.networkManager = [NetworkManager getNetworkManagerInstance];
    [self.networkManager setDelegate:self];
    
    //launch a new thread to require the room list
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self.networkManager requireRoomList];
    });
}


#pragma mark - tableViewDelegateMethod -
//cell count
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.roomList count];
}
//cell content
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RoomListCell* cell = [tableView dequeueReusableCellWithIdentifier:RoomListCellIdentifier];
    NSDictionary* roomInfo = [self.roomList objectAtIndex:[indexPath row]];
    [cell setCell:roomInfo];
    return cell;
}
//cell will display
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)joinRoom:(NSIndexPath *)indexPath {
    [self.networkManager exitGameHallServer];
    [self.networkManager disconnectSocket];
    [self.networkManager connectToRole:ROOMROLE inPort:[[[self.roomList objectAtIndex:[indexPath row]]valueForKey:@"port"]intValue]];
    [self.networkManager setPlayerRole:RR_GUEST];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (0 == [self.roomList count]) {
        return;
    }
    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self joinRoom:indexPath];
    [self performSegueWithIdentifier:@"JoinInRoomViewSegue" sender:selectedCell];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    UIViewController* testview = [segue destinationViewController];
//    [testview.navigationItem setTitle:@"fuck"];
}

#pragma mark - ShowRoomList -
/**
 *  reload the room list and reconnect to server if it is needed
 *
 *  @param sender reload button
 */
- (IBAction)reloadRoomList:(id)sender {
//    [self.daizy startAnimating];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        if ([self.networkManager testSocket]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.networkManager requireRoomList];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                LoginViewController* loginController = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
                [self.networkManager connectToRole:SERVERROLE inPort:C2SPORT];
            });
        }
    });
}

/**
 *  delegate method:refresh the room list
 *
 *  @param roomList new room list
 */
-(void)UpdateRoomList:(NSArray *)roomList{
    self.roomList = roomList;
    [self.tableView reloadData];
    [self stopDaizy];
}

#pragma mark - createNewRoom -
/**
 *  present the create new room view
 *
 *  @param sender create new room button
 */
- (IBAction)presentCreatNewRoomView:(id)sender {
    //init the create new room view
    self.createRoomView = [[CreateRoomViewController alloc]initWithNibName:@"CreateRoomView" bundle:nil];
    [self.createRoomView view];
    [self.createRoomView setDelegate:self];
    //match to os version
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        self.createRoomView.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    }else{
        self.createRoomView.modalPresentationStyle=UIModalPresentationCurrentContext;
    }
    //present
    [self presentViewController:self.createRoomView animated:YES completion:nil];
}

/**
 *  delegate method:cancle the operation of creating room
 */
-(void)cancleCreatingRoom{
    [self.createRoomView dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  delegate method: confirm the operation of creating room and send a sign to server
 *
 *  @param roomName    room name
 *  @param players max player numbers
 */
-(void)confirmCreatingRoom:(NSString *)roomName withMaxPlayers:(int)players{
    [self.createRoomView dismissViewControllerAnimated:YES completion:nil];
    [self launchDaizy];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self.networkManager createRoom:roomName withMaxPlayers:players];
    });
}

/**
 *  delegate method: when receive room created sign from the server
 *
 *  @param roomInfo the info of the room which is just created
 */
-(void)RoomCreated:(NSDictionary*)roomInfo{
    [self.networkManager exitGameHallServer];
    [self.networkManager disconnectSocket];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        if ([self.networkManager connectToRole:ROOMROLE
                                        inPort:[[roomInfo valueForKey:@"port"]intValue]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self stopDaizy];
                [self performSegueWithIdentifier:@"JoinInRoomViewSegue" sender:self];
            });
        }else{
            [self.networkManager disconnectSocket];
            [self.networkManager connectToRole:SERVERROLE inPort:C2SPORT];
        }
    });
}

-(IBAction)backToGameHall:(UIStoryboardSegue*)sender{
    NSLog(@"unwind segue!");
    [self launchDaizy];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        if (NO == [self.networkManager connectToRole:SERVERROLE inPort:C2SPORT]) {
            NSLog(@"Room: connect back to game hall failed!");
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self initProperties];
            });
        }
        
    });
}









@end
