//
//  EndScene.m
//  ProjectHangGlider
//
//  Michael Edelnant
//  Immersive Application Deployment Term 1502
//  Week 4 - Achievements
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
    
    /* To Reset Achievements for user uncomment resetAchievements and comment checkAllAchievements */
    
    //[self resetAchievements]; // To reset uncomment this method call and...
    
    //Check for Achievements
    [self checkAllAchievements]; // To reset comment this method call
    
    //Were those instructions redundant enough?

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

//Custom Wrapper Method to check all achievements
-(void)checkAllAchievements {
    [self checkForAdventureSeekerAchievement];
    [self checkForDeterminationAchievement];
    [self checkForBuildingCrasherAchievement];
    [self checkForMeasurementAchievement];
}

//Custom method to trip flag for first time play
-(void)checkForAdventureSeekerAchievement {
    
    NSLog(@"Checking for adventure seeker");
    
    //Check if Adventure Seeker has been set from NSUserDefaults
    bool isAdventureSeeker = [[NSUserDefaults standardUserDefaults] boolForKey:@"isAdventureSeeker"];
    
    if(!isAdventureSeeker) {
        //Set bool for isAdventureSeeker to NSUserDefaults
        NSLog(@"AdventureSeeker Achievement Noted!");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isAdventureSeeker"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //Report to Gamecenter
        [self reportAchievementIdentifier:@"adventureSeeker" percentComplete:100];
        
        
    } else {
        NSLog(@"adventureSeeker: %s",isAdventureSeeker ? "true" : "false");
    }
}

//Custom method to count gamePlays and award determination achievement
-(void)checkForDeterminationAchievement {
    
    //Check if hasDetermination has been set from NSUserDefaults
    bool hasDetermination = [[NSUserDefaults standardUserDefaults] boolForKey:@"hasDetermination"];
    NSLog(@"hasDetermination: %s",hasDetermination ? "true" : "false");
    
    //If user has determination achievement
    if(!hasDetermination) {
        
        //Fetch determination count to test if exists
        int determinationGameCount = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"determinationGameCount"];
        
        //If Determination Count does not exist within NSUserDefaults
        if(!determinationGameCount || determinationGameCount == 0) {
            NSLog(@"No Determination Game Count");
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"determinationGameCount"];
        
        //Increment Count and Report Achievement once "3" games is hit
        } else {
            
            //Fetch determinationCount from NSUserDefaults
            int dCount = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"determinationGameCount"];
            
            
            if(dCount < 3) {
                //Increment determinationCount
                dCount ++;
                NSLog(@"Determination Count: %i", dCount);
                
                //Set Determination Count within NSUserDefaults to new count
                [[NSUserDefaults standardUserDefaults] setInteger:(NSInteger)dCount forKey:@"determinationGameCount"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                if(dCount == 3) {
                    NSLog(@"hasDetermination awarded!");
                    
                    //Report to Gamecenter
                    [self reportAchievementIdentifier:@"determination" percentComplete:100];

                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasDetermination"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                
            }
        
        }
    
    }
}

//Custom method to check if player is horrible and can't get past 500 meters.
-(void)checkForBuildingCrasherAchievement {
    
    //Check if building crasher has been set from NSUserDefaults
    bool isBuildingCrasher = [[NSUserDefaults standardUserDefaults] boolForKey:@"isBuildingCrasher"];
    NSLog(@"isBuildingCrasher: %s",isBuildingCrasher ? "true" : "false");
    
    if(!isBuildingCrasher) {
        
        //Fetch Final Score From NSUserDefaults
        NSInteger playerFinalScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"playerFinalScore"];
        
        if(playerFinalScore < 500) {
            NSLog(@"This player sucks!");
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isBuildingCrasher"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self reportAchievementIdentifier:@"buildingCrasher" percentComplete:100];
        }
    
    }
    

}


//Custom Method to check against measurement of 1000 meters
-(void)checkForMeasurementAchievement {
    
    //Check if distance flyer has been set from NSUserDefaults
    bool isDistanceFlyer = [[NSUserDefaults standardUserDefaults] boolForKey:@"isDistanceFlyer"];
    NSLog(@"isDistanceFlyer: %s",isDistanceFlyer ? "true" : "false");
    
    if(!isDistanceFlyer) {
        //Fetch Final Score From NSUserDefaults
        NSInteger playerFinalScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"playerFinalScore"];
        
        if(playerFinalScore > 1000) {
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isDistanceFlyer"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            NSLog(@"Player passed 1000 meters");
            [self reportAchievementIdentifier:@"distanceFlyer" percentComplete:100];
        }
    }
    

    
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

- (void) reportAchievementIdentifier: (NSString*) identifier percentComplete: (float) percent
{
    GKAchievement *achievement = [[GKAchievement alloc] initWithIdentifier: identifier];
    if (achievement)
    {
        achievement.percentComplete = percent;
        achievement.showsCompletionBanner = YES;
        
        [GKAchievement reportAchievements:@[achievement] withCompletionHandler:^(NSError *error)
         {
             if (error != nil)
             {
                 NSLog(@"Error in reporting achievements: %@", error);
             } else {
                 NSLog(@"%@ Achievement reported to gameCenter", identifier);
             }
         }];
    }
}

- (void) resetAchievements
{
    [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error)
     {
         if (error != nil) {
             NSLog(@"Could not reset achievements due to %@", error);
         } else {
             NSLog(@"Achievements Reset");
             
             //Reset Distance Flyer
             [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isDistanceFlyer"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             
             //Reset Building Crasher
             [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isBuildingCrasher"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             
             //Reset HasDetermination
             [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"hasDetermination"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             
             [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"determinationGameCount"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             
             //Reset AdventureSeeker
             [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isAdventureSeeker"];
             [[NSUserDefaults standardUserDefaults] synchronize];
         }
         
     }];
}




@end
