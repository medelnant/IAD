//
//  MainMenu.m
//  ProjectHangGlider
//
//  Michael Edelnant
//  Immersive Application Deployment Term 1502
//  Week 2 - Immersive Element Integration
//
//  Created by vAesthetic on 02/10/15.
//  Copyright (c) 2015 medelnant. All rights reserved.
//

#import "MainMenu.h"
#import "GameScene.h"
#import "EndScene.h"
#import "CreditsScene.h"
#import "StoryScene.h"

@implementation MainMenu

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
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"mainMenu"];
    background.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    [self addChild:background];
    
    //Add Start Button
    SKSpriteNode *startButton = [SKSpriteNode spriteNodeWithImageNamed:@"startButton"];
    startButton.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame) + 50);
    startButton.name = @"startButton";
    [self addChild:startButton];
    
    //Add Credit Button
    SKSpriteNode *creditsButton = [SKSpriteNode spriteNodeWithImageNamed:@"creditsButton"];
    creditsButton.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    creditsButton.name = @"creditsButton";
    [self addChild:creditsButton];
    
    
    
}

//Default method called when scene is fully loaded i believe. Utilizing this for pre-loading audio.
-(void)didMoveToView:(SKView *)view {
    
    
}

//Default method to account for touches within the scene
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches)
    {
        CGPoint touchPoint = [touch locationInNode:self];
        NSArray *spriteNodes = [self nodesAtPoint:touchPoint];
        
        if ([spriteNodes count])
        {
            for (SKNode *spriteNode in spriteNodes)
            {
                if ([spriteNode.name isEqualToString:@"startButton"])
                {
                    //Tapping startButton will init transition to story scene
                    StoryScene *storyScene = [StoryScene sceneWithSize:self.size];
                    [self.view presentScene:storyScene transition:[SKTransition doorsOpenHorizontalWithDuration:1.0]];

                }
                else if ([spriteNode.name isEqualToString:@"creditsButton"])
                {
                    //Tapping creditsButton will init transition to credits scene
                    CreditsScene *creditsScene = [CreditsScene sceneWithSize:self.size];
                    [self.view presentScene:creditsScene transition:[SKTransition flipHorizontalWithDuration:1.0]];
                }
                else {
                    //Do nothing
                }
            }
        }
    }
}


@end
