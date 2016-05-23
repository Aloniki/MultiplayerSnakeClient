//
//  GameScene.h
//  MultiplayerSnakeClient
//

//  Copyright (c) 2016 Aloniki's Study. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "NetworkManager.h"
#import "DisplayNetworkProcessUIDeleagte.h"

@interface GameScene : SKScene<DisplayNetworkProcessUIDeleagte>

@end
