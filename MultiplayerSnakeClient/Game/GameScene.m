//
//  GameScene.m
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/11/16.
//  Copyright (c) 2016 Aloniki's Study. All rights reserved.
//

#import "GameScene.h"

#define MAPPINGWIDTH  160
#define MAPPINGHEIGHT 100
#define INITLENGTH    30
#define ACTUALWIDTH [UIScreen mainScreen].bounds.size.width;
#define ACTUALHEIGHT [UIScreen mainScreen].bounds.size.height;

@interface GameScene()

@property (strong, nonatomic) NetworkManager* networkManager;
@property (readwrite, nonatomic) bool isGaming;
@property (strong, nonatomic) SKLabelNode* remindLabel;

@property (strong, nonatomic) NSMutableArray* snakeList;

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    self.remindLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    self.remindLabel.text = @"Wating for others!";
    self.remindLabel.fontSize = 45;
    self.remindLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    
    [self addChild:self.remindLabel];
    NSLog(@"label x:%f, y:%f",self.remindLabel.position.x,self.remindLabel.position.y);
    [self setIsGaming:NO];
    [self setUserInteractionEnabled:NO];
    
    
    self.networkManager = [NetworkManager getNetworkManagerInstance];
    [self.networkManager setDelegate:nil];
    [self.networkManager setDelegate:self];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:0.5];
        [self.networkManager GameSceneLoaded];
    });
    
}


-(void)initGestureRecognizer{
    UISwipeGestureRecognizer* upGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(turnUp:)];
    upGesture.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:upGesture];
    
    UISwipeGestureRecognizer* downGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(turnDown:)];
    upGesture.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:downGesture];
    
    UISwipeGestureRecognizer* leftGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(turnLeft:)];
    upGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftGesture];
    
    UISwipeGestureRecognizer* rightGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(turnRight:)];
    upGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightGesture];
}

-(void)turnUp:(UIGestureRecognizer*)recognizer{
    
}
-(void)turnDown:(UIGestureRecognizer*)recognizer{
    
}
-(void)turnLeft:(UIGestureRecognizer*)recognizer{
    
}
-(void)turnRight:(UIGestureRecognizer*)recognizer{
    
}

-(void)StartPlaying:(NSMutableArray*)snakeList{
    [self.remindLabel setHidden:YES];
    [self setIsGaming:YES];
    [self setUserInteractionEnabled:YES];
    [self draw:snakeList];
}

-(void)draw:(NSArray*)snakeList{
    /* Setup your scene here */
    SKLabelNode* remindLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    remindLabel.text = @"Wating for others!";
    remindLabel.fontSize = 45;
    remindLabel.position = CGPointMake(22.5,45);

    [self addChild:remindLabel];
    
    SKShapeNode *yourline = [SKShapeNode node];
    CGMutablePathRef pathToDraw = CGPathCreateMutable();
    CGPathMoveToPoint(pathToDraw, NULL, 100, 0);
    CGPathAddLineToPoint(pathToDraw, NULL, 200, -200);
    CGPathAddLineToPoint(pathToDraw, NULL, 200, 0);
    yourline.path = pathToDraw;
    [yourline setStrokeColor:[SKColor blueColor]];
    [yourline setLineWidth:10];
    SKSpriteNode* spk = [SKSpriteNode node];
    [spk addChild:yourline];
    [spk setAnchorPoint:CGPointMake(0, 1)];
    [spk setPosition:CGPointMake(0, self.frame.size.height)];
    [self addChild:spk];
    NSLog(@"blue position, x:%f, y:%f",yourline.position.x, yourline.position.y);
    
    CGFloat mappingArea = [UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].bounds.size.height / (MAPPINGWIDTH * MAPPINGHEIGHT);
    CGFloat side = sqrt(mappingArea);
    
    for (NSDictionary* snake in snakeList) {
        NSArray* inflectionPoints = [[snakeList valueForKey:@"inflectionPoints"]objectAtIndex:0];
        NSEnumerator* pitor = [inflectionPoints objectEnumerator];
        NSDictionary* inflectionPoint;
        NSMutableArray* pointArray = [NSMutableArray array];
        while (inflectionPoint = [pitor nextObject]) {
            int x = [[inflectionPoint valueForKey:@"x"]intValue];
            int y = [[inflectionPoint valueForKey:@"y"]intValue];
            [pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
        }
        int i = 0;
        while (i < [pointArray count]-1) {
            CGPoint point1 = [[pointArray objectAtIndex:i]CGPointValue];
            CGPoint point2 = [[pointArray objectAtIndex:++i]CGPointValue];
            
            CGPoint actualPoint1 = CGPointMake(point1.x * side, point1.y * side);
            CGPoint actualPoint2 = CGPointMake(point2.x * side, point2.y * side);
            
            
//            CGContextRef context = UIGraphicsGetCurrentContext();
//            CGContextSetLineWidth(context, side);
//            CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
//            CGContextMoveToPoint(context, actualPoint1.x, actualPoint1.y);
//            CGContextAddLineToPoint(context, actualPoint2.x, actualPoint2.y);
//            CGContextStrokePath(context);
            
            SKShapeNode *yourline = [SKShapeNode node];
            CGMutablePathRef pathToDraw = CGPathCreateMutable();
            CGPathMoveToPoint(pathToDraw, NULL, actualPoint1.x, [UIScreen mainScreen].bounds.size.height - actualPoint1.y);
            CGPathAddLineToPoint(pathToDraw, NULL, actualPoint2.x, [UIScreen mainScreen].bounds.size.height - actualPoint1.y);
            
            yourline.path = pathToDraw;
            [yourline setStrokeColor:[SKColor redColor]];
            [yourline setLineWidth:side];
            yourline.position = CGPointMake(0,[UIScreen mainScreen].bounds.size.height);
            [self addChild:yourline];
            NSLog(@"red position, x:%f, y:%f",yourline.position.x, yourline.position.y);
        }
    }
}



-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if (self.isGaming) {
    }
}

@end
