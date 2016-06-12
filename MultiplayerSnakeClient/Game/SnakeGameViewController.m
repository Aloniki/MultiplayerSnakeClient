//
//  SnakeGameViewController.m
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/24/16.
//  Copyright © 2016 Aloniki's Study. All rights reserved.
//

#import "SnakeGameViewController.h"

#define LogicScreenRatio (4.0 / 3.0)

@interface SnakeGameViewController ()

@property (strong, nonatomic) IBOutlet BackgroundGameView *backgroundGameView;
@property (strong, nonatomic) SnakeGameView *snakeGameView;

@property (strong, nonatomic) NetworkManager* networkManager;
@property (readwrite, nonatomic) bool isGaming;

@property (strong, nonatomic) NSMutableArray* snakeList;
@end

@implementation SnakeGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initGestureRecognizer];
    [self setIsGaming:NO];
    
    if (!self.snakeGameView) {
        CGFloat actualWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat logicHeight = actualWidth * LogicScreenRatio;
        
        self.snakeGameView = [[SnakeGameView alloc]initWithFrame:CGRectMake(0, 0, logicHeight, actualWidth)];
        [self.snakeGameView setCenter:CGPointMake(CGRectGetMidY([UIScreen mainScreen].bounds), CGRectGetMidX([UIScreen mainScreen].bounds))];
        [self.snakeGameView setBackgroundColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.5]];
        [self.view insertSubview:self.snakeGameView atIndex:0];
        [self.snakeGameView initSetting];
        
        [self.backgroundGameView setDrawArea:CGSizeMake(logicHeight, actualWidth)];
        [self.backgroundGameView setNeedsDisplay];
    }
    [self.snakeGameView setUserInteractionEnabled:NO];
    
    self.networkManager = [NetworkManager getNetworkManagerInstance];
    [self.networkManager setDelegate:self];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:0.5];
        [self.networkManager GameSceneLoaded];
    });
}

-(void)StartPlaying:(NSMutableArray*)gameFrameContent{
    [self setIsGaming:YES];
    [self.view setUserInteractionEnabled:YES];
    [self draw:gameFrameContent];
}

-(void)draw:(NSMutableArray*)gameFrameContent{
    [self.snakeGameView setFood:[gameFrameContent lastObject]];
    
    [gameFrameContent removeLastObject];
    [self.snakeGameView setSnakeList:gameFrameContent];
    
    [self.backgroundGameView setNeedsDisplay];
    [self.snakeGameView setNeedsDisplay];
}

-(void)newFrame:(NSMutableArray *)gameFrameContent{
    [self draw:gameFrameContent];
}

-(void)gameOver{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Game Over!"
                                                                   message:@"Only one player is still alive. This game is over!"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"Back" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action){
        [alert dismissViewControllerAnimated:YES completion:nil];
        [self.networkManager leaveRoom];
        [self.networkManager disconnectSocket];
        [self performSegueWithIdentifier:@"GameOverBackToHallSegue" sender:self];
}];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}



-(void)initGestureRecognizer{
    UISwipeGestureRecognizer* upGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(turnUp:)];
    upGesture.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:upGesture];
    
    UISwipeGestureRecognizer* downGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(turnDown:)];
    downGesture.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:downGesture];
    
    UISwipeGestureRecognizer* leftGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(turnLeft:)];
    leftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftGesture];
    
    UISwipeGestureRecognizer* rightGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(turnRight:)];
    rightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightGesture];
}

-(void)turnUp:(UIGestureRecognizer*)recognizer{
    [self.networkManager changeDirection:P2G_UP];
    NSLog(@"up");
}
-(void)turnDown:(UIGestureRecognizer*)recognizer{
    [self.networkManager changeDirection:P2G_DOWN];
    NSLog(@"down");
}
-(void)turnLeft:(UIGestureRecognizer*)recognizer{
    [self.networkManager changeDirection:P2G_LEFT];
    NSLog(@"left");
}
-(void)turnRight:(UIGestureRecognizer*)recognizer{
    [self.networkManager changeDirection:P2G_RIGHT];
    NSLog(@"right");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskLandscapeRight;
    } else {
        return UIInterfaceOrientationMaskLandscapeRight;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
