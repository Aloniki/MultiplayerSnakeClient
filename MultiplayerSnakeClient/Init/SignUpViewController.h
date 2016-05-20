//
//  SignUpViewController.h
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/16/16.
//  Copyright © 2016 Aloniki's Study. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SignUpDelegate <NSObject>

-(void)confirmSignUp:(NSString*)name;

@end

@interface SignUpViewController : UIViewController{
    id<SignUpDelegate> delegate;
}
@property (assign, nonatomic) id<SignUpDelegate> delegate;

@end
