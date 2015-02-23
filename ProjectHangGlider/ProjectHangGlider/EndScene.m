//
//  EndScene.m
//  ProjectHangGlider
//
//  Michael Edelnant
//  Immersive Application Deployment Term 1502
//  Week 3 - Leaderboards
//
//  Created by vAesthetic on 02/10/15.
//  Copyright (c) 2015 medelnant. All rights reserved.
//

#import "EndScene.h"
#import "GameScene.h"
#import "MainMenu.h"
#import "LocalLeaderBoard.h"
#import "GCUtil.h"

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
    
    //Game Over Label
    _gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue Bold"];
    _gameOverLabel.text = @"GAME OVER";
    _gameOverLabel.fontColor = [SKColor whiteColor];
    _gameOverLabel.fontSize = 45;
    _gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 95);
    _gameOverLabel.zPosition = 1;
    [self addChild:_gameOverLabel];
    
    
    //High Score Label
    _highScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue Bold"];
    _highScoreLabel.fontColor = [SKColor whiteColor];
    _highScoreLabel.fontSize = 45;
    _highScoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 45);
    _highScoreLabel.zPosition = 1;
    [self addChild:_highScoreLabel];
    
    SKLabelNode *mainMenu = [SKLabelNode labelNodeWithFontNamed:@"AvenirNextCondensed-Heavy"];
    mainMenu.text = @"MAIN MENU";
    mainMenu.fontSize = 25;
    mainMenu.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    mainMenu.name = @"mainMenu";
    [self addChild:mainMenu];
    
    SKLabelNode *leaderBoards = [SKLabelNode labelNodeWithFontNamed:@"AvenirNextCondensed-Heavy"];
    leaderBoards.text = @"GAMECENTER LEADERBOARDS";
    leaderBoards.fontSize = 25;
    leaderBoards.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame) - 30);
    leaderBoards.name = @"leaderBoards";
    [self addChild:leaderBoards];
    
    SKLabelNode *localLeaderBoards = [SKLabelNode labelNodeWithFontNamed:@"AvenirNextCondensed-Heavy"];
    localLeaderBoards.text = @"LOCAL LEADERBOARDS";
    localLeaderBoards.fontSize = 25;
    localLeaderBoards.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame) - 60);
    localLeaderBoards.name = @"localLeaderBoards";
    [self addChild:localLeaderBoards];
    
    
}

//Default method called when scene is fully loaded i believe. Utilizing this for pre-loading audio.
-(void)didMoveToView:(SKView *)view {
    
    //Define sound actions for preloading when scene/view is loaded
    _ambulanceTrack = [SKAction playSoundFileNamed:@"ambulance.mp3" waitForCompletion:NO];
    [self runAction:_ambulanceTrack];
    
    //Fetch Final Score From NSUserDefaults
    NSInteger playerFinalScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"playerFinalScore"];
    _highScoreLabel.text = [NSString stringWithFormat: @"%ld meters", (long)playerFinalScore];
    
    if(playerFinalScore >= [self returnLowestHighScore]) {
        NSLog(@"We have a new high score!");
        
        UIAlertView *highScoreUserNameAlert = [[UIAlertView alloc] initWithTitle:@"Add your name to the wall of fame" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        highScoreUserNameAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [highScoreUserNameAlert show];
    }

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
                if ([spriteNode.name isEqualToString:@"mainMenu"])
                {
                    //Tapping startButton will init transition to story scene
                    MainMenu *mainMenu = [MainMenu sceneWithSize:self.size];
                    [self.view presentScene:mainMenu transition:[SKTransition doorsOpenHorizontalWithDuration:1.0]];
                    
                } else if([spriteNode.name isEqualToString:@"leaderBoards"])
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
                    
                    
                } else if([spriteNode.name isEqualToString:@"localLeaderBoards"])
                {
                    
                    //Tapping localLeaderBoards will init transition to localLeaderBoard scene
                    LocalLeaderBoard *localLeaderBoard = [LocalLeaderBoard sceneWithSize:self.size];
                    [self.view presentScene:localLeaderBoard transition:[SKTransition doorsOpenHorizontalWithDuration:1.0]];
                
                }
                
                else {
                    //Do nothing
                }
            }
        }
    }
}


-(NSInteger)returnLowestHighScore {
    
    //Define comparator to handle sorting for the final array returned from NSUserDefaults
    NSComparator sortByNumber = ^(id dict1, id dict2) {
        NSNumber* n1 = [dict1 objectForKey:@"playerScore"];
        NSNumber* n2 = [dict2 objectForKey:@"playerScore"];
        return (NSComparisonResult)[n1 compare:n2];
    };
    
    //Pull back from NSUserDefaults
    NSMutableArray *userDefaultScores = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"highScores"]];
    [userDefaultScores sortUsingComparator:sortByNumber];
    
    //Grab Lowest Score which should be first object within array
    NSDictionary * lowerScoreFromDefaults = userDefaultScores[0];
    
    //Grab score value from object
    NSNumber * lowScoreInteger = [lowerScoreFromDefaults valueForKey:@"playerScore"];
    
    //Return score value
    return [lowScoreInteger integerValue];
}


-(void)addScoreToLocalLeaderBoard:(NSInteger *)playerFinalScore withName:(NSString *)playerName {
    
    //Alloc init mutableDictionary to add to main scores array
    NSMutableDictionary * currentScore = [[NSMutableDictionary alloc]init];
    
    //Build NSDictionary for current final score
    [currentScore setObject:playerName forKey:@"playerName"];
    [currentScore setObject:[NSNumber numberWithInteger:*playerFinalScore] forKey:@"playerScore"];
    
    //Pull back from NSUserDefaults
    NSMutableArray *userDefaultScores = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"highScores"]];
    
    if(userDefaultScores != nil) {
        //Add NSDictionary to NSMutableArray from NSUserDefaults
        [userDefaultScores addObject:currentScore];
        //Add Array to NSUserDefaults
        [[NSUserDefaults standardUserDefaults] setObject:userDefaultScores forKey:@"highScores"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        //Alloc init new NSMutableArray
        NSMutableArray * userDefaultScores = [[NSMutableArray alloc]init];
        //Add NSDictionary to NSMutableArray
        [userDefaultScores addObject:currentScore];
        //Add Array to NSUserDefaults
        [[NSUserDefaults standardUserDefaults] setObject:userDefaultScores forKey:@"highScores"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    //Define comparator to handle sorting for the final array returned from NSUserDefaults
    NSComparator sortByNumber = ^(id dict1, id dict2) {
        NSNumber* n1 = [dict1 objectForKey:@"playerScore"];
        NSNumber* n2 = [dict2 objectForKey:@"playerScore"];
        return (NSComparisonResult)[n2 compare:n1];
    };
    
    
    //Pull back from NSUserDefaults
    NSMutableArray *newUserDefaultScores = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"highScores"]];
    [newUserDefaultScores sortUsingComparator:sortByNumber];
    
}


-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    UIViewController *rootViewController = self.view.window.rootViewController;
    [rootViewController dismissViewControllerAnimated:YES completion:nil];
}


//Wait for player to enter name before enabling the ok button
-(BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView{
    return [[alertView textFieldAtIndex:0].text length] > 0 && [[alertView textFieldAtIndex:0].text length]<9;
}

//Once the playername is captured, get score and entered name to add to object
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"AlertView Button Clicked! : %ld", (long)buttonIndex);
    UITextField *captureField = [alertView textFieldAtIndex:0];
    
    //Define string from what user entered within alertView
    NSString *playerNameEntered = captureField.text;
    
    //Fetch Final Score From NSUserDefaults
    NSInteger playerFinalScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"playerFinalScore"];
    
    //If the OK Button was tapped
    if(buttonIndex == 1) {
        //add score+playername to NSUserDefaults Score array
        [self addScoreToLocalLeaderBoard:&playerFinalScore withName:playerNameEntered];
    }
    
}


@end
