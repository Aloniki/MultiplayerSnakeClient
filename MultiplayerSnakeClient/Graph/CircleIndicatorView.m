//
//  CircleIndicatorView.m
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/21/16.
//  Copyright © 2016 Aloniki's Study. All rights reserved.
//

#import "CircleIndicatorView.h"


#define radians(degrees)  (degrees)*M_PI/180.0f
#define RINGRADIUSOFFSET 3

@interface CircleIndicatorView()

@property (readwrite, nonatomic) float percent;
@property (readwrite, nonatomic) CGPoint circleCenter;
@property (readwrite, nonatomic) float radius;
@property (readwrite, nonatomic) float startAngle;
@property (readwrite, nonatomic) int clockwise;

@end

@implementation CircleIndicatorView

-(id)initWithFrame:(CGRect)frame withCenter:(CGPoint)center withRaidus:(float)radius withStartAngle:(float)angle withClockwise:(int)clockwise{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.circleCenter = center;
        self.radius = radius;
        self.startAngle = angle;
        self.clockwise = clockwise;
        [self setHidden:YES];
        
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

-(void)click:(id)sender{
    [self.delegate StartGameByHost];
}


-(void)update:(float)percent{
    self.percent = percent;
}

-(void)hide{
    [self setHidden:YES];
    [self setPercent:0];
    [self setNeedsDisplay];
}

-(void)show{
    [self setHidden:NO];
}

-(void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //设置矩形填充颜色：红色
    CGContextSetRGBFillColor(context, 0.2, 1.0, 1.0, 1.0);
    //设置画笔颜色：黑色
    CGContextSetRGBStrokeColor(context, 0.2, 1.0, 1.0, 1.0);
    //设置画笔线条粗细
    CGContextSetLineWidth(context, 1);
    
    //画外圈
    CGContextMoveToPoint(context, self.circleCenter.x, self.circleCenter.y);
    CGContextAddArc(context, self.circleCenter.x, self.circleCenter.y, self.radius + RINGRADIUSOFFSET, radians(-90), radians(270), self.clockwise);
//    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathStroke);
    
    //顺时针画扇形
    CGContextMoveToPoint(context, self.circleCenter.x, self.circleCenter.y);
    CGContextAddArc(context, self.circleCenter.x, self.circleCenter.y, self.radius, radians(self.startAngle), radians(self.startAngle + 360 * self.percent), self.clockwise);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathEOFillStroke);
}

@end
