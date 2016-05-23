//
//  GameScene.m
//  MultiplayerSnakeClient
//
//  Created by Apple on 5/11/16.
//  Copyright (c) 2016 Aloniki's Study. All rights reserved.
//

#import "GameScene.h"

@interface GameScene()

@property (strong, nonatomic) NetworkManager* networkManager;
@property (readwrite, nonatomic) bool isGaming;
@property (strong, nonatomic) SKLabelNode* myLabel;

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    self.myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    self.myLabel.text = @"Wating for others!";
    self.myLabel.fontSize = 45;
    self.myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    
    [self addChild:self.myLabel];
    [self setIsGaming:NO];
    [self setUserInteractionEnabled:NO];
    
    
    self.networkManager = [NetworkManager getNetworkManagerInstance];
    [self.networkManager setDelegate:nil];
    [self.networkManager setDelegate:self];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        [self.networkManager GameSceneLoaded];
    });
}


-(void)StartPlaying{
    [self setIsGaming:YES];
    [self setUserInteractionEnabled:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.xScale = 0.5;
        sprite.yScale = 0.5;
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if (self.isGaming) {
        [self.myLabel setPosition:CGPointMake(self.position.x + 1, self.position.y)];
    }
}

@end
