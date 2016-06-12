//
//  NavigationController.m
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/11/16.
//  Copyright © 2016 Aloniki's Study. All rights reserved.
//

#import "NavigationController.h"

@implementation NavigationController

-(void)viewDidLoad{
    [super viewDidLoad];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.1529 green:0.0804 blue:0.0454 alpha:1.0]];
    [[UINavigationBar appearance] setTranslucent:NO];
}

@end
