//
//  CreditsScene.m
//  ProjectHangGlider
//
//  Michael Edelnant
//  Immersive Application Deployment Term 1502
//  Week 3 - Leaderboards
//
//  Created by vAesthetic on 02/10/15.
//  Copyright (c) 2015 medelnant. All rights reserved.
//

#import "CreditsScene.h"
#import "GameScene.h"
#import "EndScene.h"
#import "MainMenu.h"

@implementation CreditsScene


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
    
    //Add Background
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"creditsScreen"];
    background.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    [self addChild:background];
    
}

//Default method called when scene is fully loaded i believe. Utilizing this for pre-loading audio.
-(void)didMoveToView:(SKView *)view {

    
}

//Default method to account for touches within the scene
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //Tapping anywhere will init transition back to main game scene to try again.
    MainMenu *mainMenuScene = [MainMenu sceneWithSize:self.size];
    [self.view presentScene:mainMenuScene transition:[SKTransition flipHorizontalWithDuration:1.0]];
    
}


@end
