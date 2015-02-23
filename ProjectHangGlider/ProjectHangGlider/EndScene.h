//
//  EndScene.h
//  ProjectHangGlider
//
//  Michael Edelnant
//  Immersive Application Deployment Term 1502
//  Week 3 - Leaderboards
//
//  Created by vAesthetic on 02/10/15.
//  Copyright (c) 2015 medelnant. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <GameKit/GameKit.h>

@interface EndScene : SKScene <GKGameCenterControllerDelegate>

//Define Label for welcome/instruction text
@property (strong, nonatomic) SKLabelNode *gameOverLabel;
@property (strong, nonatomic) SKLabelNode *highScoreLabel;

//Define clouds BG element
@property (strong, nonatomic) SKSpriteNode *clouds;

//Define Sound Actions
@property (strong, nonatomic) SKAction *ambulanceTrack;

//Define Score
@property (nonatomic) int finalScore;

@end
