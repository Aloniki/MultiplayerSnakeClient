//
//  LoginViewController.m
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/11/16.
//  Copyright © 2016 Aloniki's Study. All rights reserved.
//

#import "LoginViewController.h"
#import "NavigationController.h"

@interface LoginViewController()

@property (strong, nonatomic) NavigationController* navigationController;

@end

@implementation LoginViewController


- (IBAction)loginToGameHall:(id)sender {
    [UIView beginAnimations:@"View Flip" context:NULL];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view.superview cache:YES];
    [UIView setAnimationDuration:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    if (!self.navigationController.view.superview) {
        if (!self.navigationController) {
            self.navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"Navigation"];
        }
        [self.view.superview insertSubview:self.navigationController.view atIndex:0];
        [self.view removeFromSuperview];
    }
    [UIView commitAnimations];
}


@end
