//
//  EndScene.h
//  ProjectHangGlider
//
//  Michael Edelnant
//  Immersive Application Deployment Term 1502
//  Week 2 - Immersive Element Integration
//
//  Created by vAesthetic on 02/10/15.
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
