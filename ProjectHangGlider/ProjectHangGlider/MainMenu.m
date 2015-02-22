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
#import <GameKit/GameKit.h>

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
    
    SKLabelNode *startButton = [SKLabelNode labelNodeWithFontNamed:@"AvenirNextCondensed-Heavy"];
    startButton.text = @"START";
    startButton.fontSize = 30;
    startButton.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame) + 40);
    startButton.name = @"startButton";
    [self addChild:startButton];
    
    SKLabelNode *creditsButton = [SKLabelNode labelNodeWithFontNamed:@"AvenirNextCondensed-Heavy"];
    creditsButton.text = @"CREDITS";
    creditsButton.fontSize = 30;
    creditsButton.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame) - 20);
    creditsButton.name = @"creditsButton";
    [self addChild:creditsButton];
    
    SKLabelNode *leaderBoards = [SKLabelNode labelNodeWithFontNamed:@"AvenirNextCondensed-Heavy"];
    leaderBoards.text = @"LEADERBOARDS";
    leaderBoards.fontSize = 30;
    leaderBoards.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame) + 10);
    leaderBoards.name = @"leaderBoards";
    [self addChild:leaderBoards];

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
                    bool hasSeenStory = [[NSUserDefaults standardUserDefaults] boolForKey:@"hasSeenStory"];
                    NSLog(@"Has User Scene Story: %@", hasSeenStory ? @"YES" : @"NO");
                    
                    if(hasSeenStory) {
                        GameScene *gameScene = [GameScene sceneWithSize:self.size];
                        [self.view presentScene:gameScene transition:[SKTransition doorsOpenHorizontalWithDuration:1.0]];
                    } else {
                        StoryScene *storyScene = [StoryScene sceneWithSize:self.size];
                        [self.view presentScene:storyScene transition:[SKTransition doorsOpenHorizontalWithDuration:1.0]];
                    }

                }
                else if ([spriteNode.name isEqualToString:@"creditsButton"])
                {
                    //Tapping creditsButton will init transition to credits scene
                    CreditsScene *creditsScene = [CreditsScene sceneWithSize:self.size];
                    [self.view presentScene:creditsScene transition:[SKTransition flipHorizontalWithDuration:1.0]];
                }
                else if ([spriteNode.name isEqualToString:@"leaderBoards"])
                {
                    //Authenticate gameCenter.
                    if ([GKLocalPlayer localPlayer].isAuthenticated) {

                        //IF authenticated,
                        
                        [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                            
                            GKGameCenterViewController *leaderboardViewController = [[GKGameCenterViewController alloc] init];
                            UIViewController *rootViewController = self.view.window.rootViewController;
                            [leaderboardViewController setGameCenterDelegate:self];
                            [rootViewController presentViewController:leaderboardViewController animated:YES completion:nil];
                            
                         }];
                        
                    } else if (![GKLocalPlayer localPlayer].isAuthenticated){
                        NSLog(@"Cant Connect to GameCenter");
                    }

                }
                else {
                    //Do nothing
                }
            }
        }
    }
}

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    UIViewController *rootViewController = self.view.window.rootViewController;
    [rootViewController dismissViewControllerAnimated:YES completion:nil];
}



@end
