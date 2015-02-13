//
//  EndScene.h
//  ProjectHangGlider
//
//  Michael Edelnant
//  Mobile Game Design Term 1501
//  Week 4 - Game Beta
//
//  Created by vAesthetic on 1/24/15.
//  Copyright (c) 2015 medelnant. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface EndScene : SKScene

//Define Label for welcome/instruction text
@property (strong, nonatomic) SKLabelNode *instructionLabel;
@property (strong, nonatomic) SKLabelNode *descriptionLabel;

//Define clouds BG element
@property (strong, nonatomic) SKSpriteNode *clouds;

//Define Sound Actions
@property (strong, nonatomic) SKAction *ambulanceTrack;

@end
