//
//  CreateRoomViewController.m
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/14/16.
//  Copyright © 2016 Aloniki's Study. All rights reserved.
//

#import "CreateRoomViewController.h"

#pragma mark - interface -

@interface CreateRoomViewController ()
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UITextField *roomName;
@property (weak, nonatomic) IBOutlet UILabel *sliderLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (readwrite, nonatomic) float oldValue;
@property (readwrite, nonatomic) float sliderWidth;
@property (readwrite, nonatomic) float sliderHeight;
@property (readwrite, nonatomic) float sliderRange;

@end

#pragma mark - implementation -

@implementation CreateRoomViewController

#pragma - view methods -
/**
 *  init the view appearance
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mainView.layer setCornerRadius:4.0f];//设置View圆角
    [self.shadowView.layer setShadowColor:[UIColor blackColor].CGColor];//设置View的阴影颜色
    [self.shadowView.layer setShadowOpacity:0.8f];//设置阴影的透明度
    [self.shadowView.layer setShadowRadius:4.0f];
    [self.shadowView.layer setShadowOffset:CGSizeMake(5.0, 4.0)];//设置View Shadow的偏移量
}
/**
 *  init the properties
 *
 *  @param animated BOOL
 */
-(void)viewDidAppear:(BOOL)animated{
    self.oldValue = self.slider.value;
    self.sliderWidth = self.slider.frame.size.width;
    self.sliderHeight = self.slider.frame.size.height;
    self.sliderRange = self.slider.maximumValue - self.slider.minimumValue;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UI methods -
/**
 *  update the player numbers and animation effects automatically when the value of player number slider 
 *  changed
 *
 *  @param sender the slider of player numbers
 */
- (IBAction)sliderValueChanged:(id)sender {
    self.sliderLabel.text = [[NSString alloc]initWithFormat:@"%d",(int)self.slider.value];
    
    float offset = (self.slider.value - self.oldValue)/ self.sliderRange * (self.sliderWidth-self.sliderHeight);
    [self.sliderLabel setTransform:CGAffineTransformTranslate(self.sliderLabel.transform, offset, 0)];
    self.oldValue = self.slider.value;
}
/**
 *  cancle createing room
 *
 *  @param sender cancle button
 */
- (IBAction)cancle:(id)sender {
    [self.delegate cancleCreatingRoom];
}
/**
 *  confirm creating room
 *
 *  @param sender confirm button
 */
- (IBAction)create:(id)sender {
    [self.delegate confirmCreatingRoom:self.roomName.text withMaxPlayers:(int)self.slider.value];
}













@end
