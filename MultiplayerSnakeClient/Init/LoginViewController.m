//
//  LoginViewController.m
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/11/16.
//  Copyright © 2016 Aloniki's Study. All rights reserved.
//

#import "LoginViewController.h"
#import "NavigationController.h"

#pragma mark - interface -

@interface LoginViewController()

@property (assign, nonatomic) NetworkManager* networkManager;
@property (strong, nonatomic) NavigationController* navigationController;
@property (strong, nonatomic) UIActivityIndicatorView* daizy;
@property (strong, nonatomic) SignUpViewController* signUpViewController;

@end

#pragma mark - implementation -

@implementation LoginViewController

#pragma mark - view methods -
/**
 *  get the networkManager instance when view did load
 */
-(void)viewDidLoad{
    [super viewDidLoad];
    self.networkManager = [NetworkManager getNetworkManagerInstance];
    if (!_daizy) {
        _daizy = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_daizy setColor:[UIColor orangeColor]];
        [_daizy setCenter:self.view.center];
        [_daizy setHidesWhenStopped:YES];
        [self.view addSubview:_daizy];
    }
}

#pragma mark - sign up methods -
/**
 *  get the path of data file
 *
 *  @return the path of data file
 */
- (NSString*)dataFilePath{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentDirectory = [paths objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"data.plist"];
}
/**
 *  load the player data from data file if existing
 *  otherwise, present the sign up view to make a sign up
 */
- (void)checkLoginCache {
    NSString* filePath = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSMutableDictionary* content = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        [self.networkManager setPlayerName:[content valueForKey:@"playerName"]];
    }else{
        [self presentSignUpView];
    }
}

/**
 *  present the sign up view
 */
-(void)presentSignUpView{
    
    self.signUpViewController = [[SignUpViewController alloc]initWithNibName:@"SignUpView" bundle:nil];
    [self.signUpViewController view];
    //    UINavigationController* tmpNC = [[UINavigationController alloc]initWithRootViewController:tmpVC];
    [self.signUpViewController setDelegate:self];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        
        self.signUpViewController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        
    }else{
        
        self.signUpViewController.modalPresentationStyle=UIModalPresentationCurrentContext;
        
    }
    
    [self presentViewController:self.signUpViewController animated:YES completion:nil];
}

/**
 *  confirm sign up, save player data into the data file
 *
 *  @param name player name
 */
-(void)confirmSignUp:(NSString *)name{
    NSString* filePath = [self dataFilePath];
    NSDictionary* content = @{@"playerName":name};
    [content writeToFile:filePath atomically:YES];
    
    [self.signUpViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - login and change view -
/**
 *  login to game hall
 *
 *  @param sender login button
 */
- (IBAction)loginToGameHall:(id)sender {
    //check if the login cache is existing
    [self checkLoginCache];
    [self.daizy startAnimating];
    //launch the activity indicator while waiting
    [_daizy startAnimating];
    [self.view setUserInteractionEnabled:NO];
    
    //lauch a new thread to handle the network affairs
    //if done, interface 
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        if (YES == [self.networkManager connectToRole:SERVERROLE inPort:C2SPORT]) {
            dispatch_async(dispatch_get_main_queue(), ^{
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
                [self.daizy stopAnimating];
                [self.view setUserInteractionEnabled:YES];
                [UIView commitAnimations];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.daizy stopAnimating];
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Login Alert"
                                                                               message:@"Fail to login in the game hall, please try again."
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action){
                        [alert dismissViewControllerAnimated:YES completion:nil];
                        [self.view setUserInteractionEnabled:YES];
                    }];
                    [alert addAction:okAction];
                    [self presentViewController:alert animated:YES completion:nil];
                
            });
        }
    });

    
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
