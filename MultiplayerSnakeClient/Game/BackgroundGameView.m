//
//  BackgroundGameView.m
//  MultiplayerSnakeClient
//
//  Created by Apple on 6/4/16.
//  Copyright © 2016 Aloniki's Study. All rights reserved.
//

#import "BackgroundGameView.h"

#define MAPPINGWIDTH  40
#define MAPPINGHeight 30

@interface BackgroundGameView()

@property (readwrite, nonatomic) CGFloat actualWidth;
@property (readwrite, nonatomic) CGFloat actualHeight;
@property (readwrite, nonatomic) CGFloat tileArea;
@property (readwrite, nonatomic) CGFloat tileSideX;
@property (readwrite, nonatomic) CGFloat tileSideY;
@property (readwrite, nonatomic) CGFloat tileRadiusX;
@property (readwrite, nonatomic) CGFloat tileRadiusY;
@property (readwrite, nonatomic) CGFloat offsetX;

@end

@implementation BackgroundGameView

-(void)setDrawArea:(CGSize)area{
    self.actualWidth = area.width;
    self.actualHeight = area.height;
    self.tileSideX = self.actualWidth / MAPPINGWIDTH;
    self.tileSideY = self.actualHeight / MAPPINGHeight;
    self.tileRadiusX = self.tileSideX / 2;
    self.tileRadiusY = self.tileSideY / 2;
    self.offsetX = (self.bounds.size.height - self.actualWidth) / 2.0;
    
    NSLog(@"background view's bounds size: %f x %f",self.bounds.size.width,self.bounds.size.height);
    NSLog(@"background view's actual size: %f x %f",self.actualWidth,self.actualHeight);
    NSLog(@"background view's actual offset x: %f",self.offsetX);
//    NSLog(@"actual width: %f",self.actualWidth);
//    NSLog(@"actual height: %f",self.actualHeight);
//    NSLog(@"tile area: %f",self.tileArea);
//    NSLog(@"tile side of X: %f",self.tileSideX);
//    NSLog(@"tile side of Y: %f",self.tileSideY);
}

-(void)drawRect:(CGRect)rect{
    [self drawBackground];
}


- (void)drawBackground {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.offsetX = (self.bounds.size.width - self.actualWidth) / 2.0;
        
        NSLog(@"background view's bounds size: %f x %f",self.bounds.size.width,self.bounds.size.height);
        NSLog(@"background view's actual size: %f x %f",self.actualWidth,self.actualHeight);
        NSLog(@"background view's actual offset x: %f",self.offsetX);
    });
    CGContextRef cgBG = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(cgBG, 1);
    CGContextSetStrokeColorWithColor(cgBG, [UIColor blackColor].CGColor);
    CGContextSetAlpha(cgBG, 0.5);
    for (int i = 0; i <= MAPPINGWIDTH; i++) {
        CGContextMoveToPoint(cgBG, i * self.tileSideX + self.offsetX , 0);
        CGContextAddLineToPoint(cgBG, i * self.tileSideX + self.offsetX, MAPPINGHeight * self.tileSideY);
    }
    CGContextStrokePath(cgBG);
    for (int i = 0; i <= MAPPINGHeight; i++) {
        CGContextMoveToPoint(cgBG, 0 + self.offsetX, i * self.tileSideY);
        CGContextAddLineToPoint(cgBG, MAPPINGWIDTH * self.tileSideX + self.offsetX, i * self.tileSideY);
    }
    CGContextStrokePath(cgBG);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
