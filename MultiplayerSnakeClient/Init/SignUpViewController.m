//
//  SignUpViewController.m
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/16/16.
//  Copyright © 2016 Aloniki's Study. All rights reserved.
//

#import "SignUpViewController.h"

#pragma mark - interface -

@interface SignUpViewController ()

@property (weak, nonatomic) IBOutlet UITextField *playerNameTextField;

@end

#pragma mark - implementation -

@implementation SignUpViewController

#pragma mark - view methods -

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - confirm sign up -

- (IBAction)confirmPlayerName:(id)sender {
    [self.delegate confirmSignUp:self.playerNameTextField.text];
}






@end
