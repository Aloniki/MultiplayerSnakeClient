//
//  CircleIndicatorView.h
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/21/16.
//  Copyright © 2016 Aloniki's Study. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleIndicatorView : UIView

-(id)initWithFrame:(CGRect)frame withCenter:(CGPoint)center withRaidus:(float)radius withStartAngle:(float)angle withClockwise:(int)clockwise;
-(void)update:(float)percent;
-(void)hide;
-(void)show;
@end
