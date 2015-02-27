//
//  LocalLeaderBoard.m
//  ProjectHangGlider
//
//  Michael Edelnant
//  Immersive Application Deployment Term 1502
//  Week 4 - Achievements
//
//  Created by vAesthetic on 2/18/15.
//  Copyright (c) 2015 medelnant. All rights reserved.
//

#import "LocalLeaderBoard.h"
#import "MainMenu.h"

@implementation LocalLeaderBoard

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


//Custom method to build scene
-(void) setScene {
    
    NSLog(@"End Scene Initialized for LocalLeaderBoard!");
    
    //Add Background
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
    background.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    [self addChild:background];
    
    SKLabelNode *leaderBoardTitle = [SKLabelNode labelNodeWithFontNamed:@"AvenirNextCondensed-Heavy"];
    leaderBoardTitle.text = @"LOCAL LEADERBOARD";
    leaderBoardTitle.fontSize = 25;
    leaderBoardTitle.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame) +115);
    leaderBoardTitle.name = @"leaderBoardTitle";
    [self addChild:leaderBoardTitle];
    
    SKLabelNode *highToLowLabel = [SKLabelNode labelNodeWithFontNamed:@"AvenirNextCondensed-Heavy"];
    highToLowLabel.text = @"Highest to Lowest";
    highToLowLabel.fontSize = 15;
    highToLowLabel.position = CGPointMake((CGRectGetMidX(self.frame) - (highToLowLabel.frame.size.width) + 50),CGRectGetMidY(self.frame) + 90);
    highToLowLabel.name = @"highToLowLabel";
    [self addChild:highToLowLabel];
    
    SKLabelNode *lowToHightLabel = [SKLabelNode labelNodeWithFontNamed:@"AvenirNextCondensed-Heavy"];
    lowToHightLabel.text = @"Lowest to Highest";
    lowToHightLabel.fontSize = 15;
    lowToHightLabel.position = CGPointMake((CGRectGetMidX(self.frame) + (lowToHightLabel.frame.size.width) - 50),CGRectGetMidY(self.frame) + 90);
    lowToHightLabel.name = @"lowToHightLabel";
    [self addChild:lowToHightLabel];
    
    SKLabelNode *mainMenu = [SKLabelNode labelNodeWithFontNamed:@"AvenirNextCondensed-Heavy"];
    mainMenu.text = @"Main Menu";
    mainMenu.fontSize = 15;
    mainMenu.position = CGPointMake((mainMenu.frame.size.width/2)+20,CGRectGetMidY(self.frame) + 115);
    mainMenu.name = @"mainMenu";
    [self addChild:mainMenu];
    
}

//Custom method for initial printing of leaderboard on scene load
-(void)printLeaderBoard {
    
    //Fetch HighScores from UserDefaults
    //Define comparator to handle sorting for the final array returned from NSUserDefaults
    NSComparator sortByNumber = ^(id dict1, id dict2) {
        NSNumber* n1 = [dict1 objectForKey:@"playerScore"];
        NSNumber* n2 = [dict2 objectForKey:@"playerScore"];
        return (NSComparisonResult)[n2 compare:n1];
    };
    
    //Pull back from NSUserDefaults
    NSMutableArray *userDefaultScores = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"highScores"]];
    [userDefaultScores sortUsingComparator:sortByNumber];
    
    for(int i=0; i<10; i++) {
        
        NSDictionary *leaderBoardScoreObject = userDefaultScores[i];
        NSString *leaderBoardName = [leaderBoardScoreObject valueForKey:@"playerName"];
        NSNumber * leaderBoardScoreNum = [leaderBoardScoreObject valueForKey:@"playerScore"];
        
        
        NSString *leaderBoardScoreLine = [NSString stringWithFormat:@"%@            %ld", leaderBoardName,(long)[leaderBoardScoreNum integerValue]];
        
        SKLabelNode *leaderBoardScore = [SKLabelNode labelNodeWithFontNamed:@"AvenirNextCondensed-Heavy"];
        [leaderBoardScore setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeLeft];
        leaderBoardScore.text = leaderBoardScoreLine;
        leaderBoardScore.fontSize = 15;
        leaderBoardScore.name = [NSString stringWithFormat:@"leaderBoardScore%ld", (long)i+1];
        leaderBoardScore.fontColor = [SKColor colorWithRed:0.33 green:0.49 blue:0.73 alpha:1];
        leaderBoardScore.position = CGPointMake(CGRectGetMidX(self.frame) - 75,(CGRectGetMidY(self.frame) + 75) - ((i+1)*20));
        
        [self addChild:leaderBoardScore];
    }

}

//Custom method to handle sorting from buttons/labels that user taps
-(void)sortLeaderBoard:(NSString *)isDefault {
    
    //Define comparator to handle sorting for the final array returned from NSUserDefaults - HighToLow
    NSComparator sortByHighToLow = ^(id dict1, id dict2) {
        NSNumber* n1 = [dict1 objectForKey:@"playerScore"];
        NSNumber* n2 = [dict2 objectForKey:@"playerScore"];
        return (NSComparisonResult)[n2 compare:n1];
    };
    
    //Define comparator to handle sorting for the final array returned from NSUserDefaults - LowToHigh
    NSComparator sortByLowToHigh = ^(id dict1, id dict2) {
        NSNumber* n1 = [dict1 objectForKey:@"playerScore"];
        NSNumber* n2 = [dict2 objectForKey:@"playerScore"];
        return (NSComparisonResult)[n1 compare:n2];
    };
    
    //Pull back from NSUserDefaults
    NSMutableArray *userDefaultScores = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"highScores"]];
    
    
    //Hacky way to listen to toggle sorting action
    if([isDefault isEqualToString:@"YES"]) {
        [userDefaultScores sortUsingComparator:sortByHighToLow];
        
    } else {
        [userDefaultScores sortUsingComparator:sortByLowToHigh];
    }
    
    //Loop and write over existing labels
    for(int i=0; i<10; i++) {
        
        //Fetch Dictionary within scores array
        NSDictionary *leaderBoardScoreObject = userDefaultScores[i];
        
        //Grab values from nsDictionary
        NSString *leaderBoardName = [leaderBoardScoreObject valueForKey:@"playerName"];
        NSNumber * leaderBoardScoreNum = [leaderBoardScoreObject valueForKey:@"playerScore"];
        
        //Format String
        NSString *leaderBoardScoreLine = [NSString stringWithFormat:@"%@            %ld", leaderBoardName,(long)[leaderBoardScoreNum integerValue]];
        
        //Write to the correct label
        NSString *labelNodeName = [NSString stringWithFormat:@"leaderBoardScore%ld", (long)i+1];
        SKLabelNode * labelNodeToEdit  = (SKLabelNode *)[self childNodeWithName:labelNodeName];
        labelNodeToEdit.text = leaderBoardScoreLine;

    }
    
    

}

//Default method called when scene is fully loaded i believe. Utilizing this for pre-loading audio.
-(void)didMoveToView:(SKView *)view {
    
    [self printLeaderBoard];

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
                if ([spriteNode.name isEqualToString:@"highToLowLabel"])
                {
                 
                    [self sortLeaderBoard:@"YES"];
                    
                } else if([spriteNode.name isEqualToString:@"lowToHightLabel"])
                {
                    [self sortLeaderBoard:@"NO"];
                    
                } else if([spriteNode.name isEqualToString:@"mainMenu"])
                {
                    
                    //Tapping localLeaderBoards will init transition to localLeaderBoard scene
                    MainMenu *mainMenu = [MainMenu sceneWithSize:self.size];
                    [self.view presentScene:mainMenu transition:[SKTransition doorsCloseHorizontalWithDuration:1.0]];
                    
                }
                
                else {
                    //Do nothing
                }
            }
        }
    }
}


@end
