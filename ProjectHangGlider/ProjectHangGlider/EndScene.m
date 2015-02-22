//
//  EndScene.m
//  ProjectHangGlider
//
//  Michael Edelnant
//  Immersive Application Deployment Term 1502
//  Week 2 - Immersive Element Integration
//
//  Created by vAesthetic on 02/10/15.
//  Copyright (c) 2015 medelnant. All rights reserved.
//

#import "EndScene.h"
#import "GameScene.h"

@implementation EndScene


//Default method - main init trigger from view controller instatiating scene to load.
-(instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        //Note: Targeting iphone 6 landscape 667x375/1334x750
        self.backgroundColor = [SKColor whiteColor];
        
        
        //Call custom method to build scene
        [self setScene];
        
    }
    return self;
}

-(void) setScene {
    
    NSLog(@"End Scene Initialized!");
    
    //Add Background
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
    background.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    [self addChild:background];
    
    //Add Clouds
    _clouds = [SKSpriteNode spriteNodeWithImageNamed:@"clouds"];
    _clouds.position = CGPointMake(CGRectGetMidX(self.frame),(self.frame.size.height-_clouds.size.height)-20);
    _clouds.alpha = .5;
    _clouds.name = @"clouds";
    [self addChild:_clouds];
    
    //Instruction Text
    _instructionLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue Bold"];
    _instructionLabel.text = @"GAME OVER";
    _instructionLabel.fontColor = [SKColor blackColor];
    _instructionLabel.fontSize = 25;
    _instructionLabel.position = CGPointMake(CGRectGetMidX(self.frame), 250);
    _instructionLabel.zPosition = 1;
    [self addChild:_instructionLabel];
    
    NSLog(@"Instruction text should be added");
    
    //Description Text
    _descriptionLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue Light"];
    _descriptionLabel.text = @"Tap the Screen to try again";
    _descriptionLabel.fontColor = [SKColor blackColor];
    _descriptionLabel.fontSize = 10;
    _descriptionLabel.position = CGPointMake(CGRectGetMidX(self.frame), 235);
    _descriptionLabel.zPosition = 1;
    [self addChild:_descriptionLabel];
    
    NSLog(@"Description label should be added");
    
    
}

//Default method called when scene is fully loaded i believe. Utilizing this for pre-loading audio.
-(void)didMoveToView:(SKView *)view {
    
    //Define sound actions for preloading when scene/view is loaded
    _ambulanceTrack = [SKAction playSoundFileNamed:@"ambulance.mp3" waitForCompletion:NO];
    [self runAction:_ambulanceTrack];
    
    NSLog(@"GameScore Sent Over = %i", _finalScore);

}

//Default method to account for touches within the scene
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //Tapping anywhere will init transition back to main game scene to try again.
    GameScene *gameScene = [GameScene sceneWithSize:self.size];
    [self.view presentScene:gameScene transition:[SKTransition doorsOpenHorizontalWithDuration:1.0]];

}

@end
