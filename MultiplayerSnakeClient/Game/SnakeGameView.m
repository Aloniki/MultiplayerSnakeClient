//
//  SnakeGameView.m
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/24/16.
//  Copyright © 2016 Aloniki's Study. All rights reserved.
//

#import "SnakeGameView.h"

#define MAPPINGWIDTH  40
#define MAPPINGHeight 30

@interface SnakeGameView()

@property (readwrite, nonatomic) CGFloat actualWidth;
@property (readwrite, nonatomic) CGFloat actualHeight;
@property (readwrite, nonatomic) CGFloat tileArea;
@property (readwrite, nonatomic) CGFloat tileSideX;
@property (readwrite, nonatomic) CGFloat tileSideY;
@property (readwrite, nonatomic) CGFloat tileRadiusX;
@property (readwrite, nonatomic) CGFloat tileRadiusY;

@end

@implementation SnakeGameView

-(void)initSetting{
    //        self.actualWidth = [UIScreen mainScreen].bounds.size.width;
    //        self.actualHeight = [UIScreen mainScreen].bounds.size.height;
    self.actualWidth = self.bounds.size.width;
    self.actualHeight = self.bounds.size.height;
    //        self.tileArea = self.actualHeight * self.actualWidth / (MAPPINGWIDTH * MAPPINGHeight);
    //        self.tileSide = sqrt(self.tileArea);
    //        self.tileRaidus = 0.5 * self.tileSide;
    self.tileSideX = self.actualWidth / MAPPINGWIDTH;
    self.tileSideY = self.actualHeight / MAPPINGHeight;
    self.tileRadiusX = self.tileSideX / 2.0;
    self.tileRadiusY = self.tileSideY / 2.0;
    //        self.inflectionPointsOfSnakes = [NSMutableArray array];
    self.food = [NSDictionary dictionary];
    self.snakeList = [NSArray array];
    
    NSLog(@"actual width: %f",self.actualWidth);
    NSLog(@"actual height: %f",self.actualHeight);
    NSLog(@"tile area: %f",self.tileArea);
    NSLog(@"tile side of X: %f",self.tileSideX);
    NSLog(@"tile side of Y: %f",self.tileSideY);
}

-(void)drawRect:(CGRect)rect{
//    [self clearsContextBeforeDrawing];
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//
//    });
    [self drawGameFrame];
}

- (void)drawGameFrame {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.tileSideY);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    int x = [[self.food valueForKey:@"x"]intValue];
    int y = [[self.food valueForKey:@"y"]intValue];
    BOOL beenEaten = [[self.food valueForKey:@"beenEaten"]boolValue];
    if (NO == beenEaten) {
        CGContextSetFillColorWithColor(context, [UIColor orangeColor].CGColor);
        CGContextFillRect(context, CGRectMake((x-1) * self.tileSideX, (y-1) * self.tileSideY, self.tileSideX, self.tileSideY));
    }
    
    for (NSDictionary* snake in self.snakeList) {
        
        UIColor* snakeColor = [self getColorByNum:[[snake valueForKey:@"snakeColor"]intValue]];
        CGContextSetStrokeColorWithColor(context, snakeColor.CGColor);
        
        if (SS_DEAD == [[snake valueForKey:@"snakeState"]intValue]) {
            CGContextSetAlpha(context, 0.5);
        }else {
            CGContextSetAlpha(context, 1);
        }
        
        NSArray* inflectionPoints = [snake valueForKey:@"inflectionPoints"];
        for (NSDictionary* point in [inflectionPoints reverseObjectEnumerator]) {
            int x = [[point valueForKey:@"x"]intValue];
            int y = [[point valueForKey:@"y"]intValue];
            int dir = [[point valueForKey:@"dir"]intValue];
            int actualX = x * self.tileSideX - self.tileRadiusX;
            int actualY = y * self.tileSideY - self.tileRadiusY;
            
            if (point != [inflectionPoints lastObject]) {
                CGContextAddLineToPoint(context, actualX, actualY);
            }else {
                CGContextMoveToPoint(context, actualX, actualY);
            }
        }
        CGContextStrokePath(context);
    }
//    for (NSMutableArray* snakePoints in self.inflectionPointsOfSnakes) {
//        for (NSValue* vpoint in snakePoints) {
//            if (vpoint == [snakePoints firstObject]) {
//                CGPoint point = vpoint.CGPointValue;
//                CGContextMoveToPoint(context, point.x * self.tileSideX - self.tileRadiusX, point.y * self.tileSideY - self.tileRadiusY);
//            }else{
//                CGPoint point = vpoint.CGPointValue;
//                CGContextAddLineToPoint(context, point.x * self.tileSideX - self.tileRadiusX, point.y * self.tileSideY - self.tileRadiusY);
//                if (1==0) {
//                    CGContextSetLineWidth(context, self.tileSideX);
//                }else{
//                    CGContextSetLineWidth(context, self.tileSideY);
//                }
//            }
//        }
//    }
}

-(UIColor*)getColorByNum:(int)num{
    switch (num) {
        case 1:{
            return [UIColor redColor];
            break;
        }
        case 2:{
            return [UIColor blueColor];
            break;
        }
        case 3:{
            return [UIColor greenColor];
            break;
        }
        case 4:{
            return [UIColor brownColor];
            break;
        }
        case 5:{
            return [UIColor blackColor];
            break;
        }
        default:
            break;
    }
    return [UIColor whiteColor];
}

@end
