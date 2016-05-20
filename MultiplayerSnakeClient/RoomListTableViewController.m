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

@interface RoomListTableViewController()

@property (copy, nonatomic) NSMutableArray* roomList;

@end

@implementation RoomListTableViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    UITableView* tableView = (id)[self.view viewWithTag:1];
    tableView.rowHeight = 50;
    UINib* nib = [UINib nibWithNibName:@"RoomListCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:RoomListCellIdentifier];
    
    UIEdgeInsets contentInset = tableView.contentInset;
    contentInset.top = 20;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RoomListCell* cell = [tableView dequeueReusableCellWithIdentifier:RoomListCellIdentifier];
    cell.host = @"皮尼斯鳗鱼";
    cell.maxPlayers = 4;
    cell.currentPlayers = random()%5;
    [cell.playerNumbersProgress setTransform:CGAffineTransformMakeScale(1, 25)];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
}



@end
