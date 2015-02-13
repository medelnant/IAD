//
//  StoryScene.m
//  ProjectHangGlider
//
//  Michael Edelnant
//  Immersive Application Deployment Term 1502
//  Week 2 - Immersive Element Integration
//
//  Created by vAesthetic on 02/10/15.
//  Copyright (c) 2015 medelnant. All rights reserved.
//

#import "StoryScene.h"
#import "GameScene.h"

static int PAGE_COUNT = 1;

@implementation StoryScene
{
@private

}

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
    _page_1 = [SKSpriteNode spriteNodeWithImageNamed:@"story1"];
    _page_1.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    
    _page_2 = [SKSpriteNode spriteNodeWithImageNamed:@"story2"];
    _page_2.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    
    _page_3 = [SKSpriteNode spriteNodeWithImageNamed:@"story3"];
    _page_3.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    
    _page_4 = [SKSpriteNode spriteNodeWithImageNamed:@"story4"];
    _page_4.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    
    _page_5 = [SKSpriteNode spriteNodeWithImageNamed:@"story5"];
    _page_5.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    
    [self addChild:_page_5];
    [self addChild:_page_4];
    [self addChild:_page_3];
    [self addChild:_page_2];
    [self addChild:_page_1];
    
}

//Default method called when scene is fully loaded i believe. Utilizing this for pre-loading audio.
-(void)didMoveToView:(SKView *)view {
    
    
}

-(void)showStoryPage:(int)pageCount {
    
    
    //Reset/Remove all story pages
    [_page_1 removeFromParent];
    [_page_2 removeFromParent];
    [_page_3 removeFromParent];
    [_page_4 removeFromParent];
    [_page_5 removeFromParent];
    
    //Re-introduce the correct story page per the pageCount int being passed into this method
    switch (pageCount)
    {
        case 1:
            [self addChild:_page_1];
            break;
            
        case 2:
            [self addChild:_page_2];
            break;
            
        case 3:
            [self addChild:_page_3];
            break;
            
        case 4:
            [self addChild:_page_4];
            break;
        
        case 5:
            [self addChild:_page_5];
            break;
            
        default:
            break;
            
    }
    
}

//Default method to account for touches within the scene
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //Tapping anywhere will increment the story page count and show next "page" of story....
    //Unless you are already on the 5th then we will transition you to the game play
    if(PAGE_COUNT < 5) {
        PAGE_COUNT = PAGE_COUNT + 1;
        NSLog(@"Page Count: %i", PAGE_COUNT);
    } else if(PAGE_COUNT == 5) {
        NSLog(@"Time to play the friggin game already...");
        //Story time is OVER...Transition to the actual game play now.
        //Tapping startButton will init transition to story scene
        GameScene *gameScene = [GameScene sceneWithSize:self.size];
        [self.view presentScene:gameScene transition:[SKTransition doorsOpenHorizontalWithDuration:1.0]];
    }
    
    [self showStoryPage:PAGE_COUNT];
    
    

    
}

@end
