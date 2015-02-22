//
//  GameScene.m
//  ProjectHangGlider
//
//  Michael Edelnant
//  Immersive Application Deployment Term 1502
//  Week 2 - Immersive Element Integration
//
//  Created by vAesthetic on 02/10/15.
//  Copyright (c) 2015 medelnant. All rights reserved.
//

#import "GameScene.h"
#import "EndScene.h"
#import "GCUtil.h"

@interface GameScene ()

@end


//Define animation speed constants
static const float CLOUDS_PPS = 10;
//static const float BUILDINGS_PPS = 30;

//Define scoring distance multiplier;
static const int SCORING_MULTIPLIER = 5;
static int GAME_SCORE = 0;

// Define my constants for category bitmasks.
// These allow for us to determine which physics bodies collide within the physics world.
static const uint32_t playerCategory    = 1;
static const uint32_t buildingCategory  = 2;
static const uint32_t groundCategory    = 4;
static const uint32_t edgeCategory      = 8;

//define bool bit/flag to track firstTouch used to trigger startGamePlay method

@implementation GameScene
{
@private
    //Flag to account for first touch to init sequence.
    BOOL firstTouch;
    
    //Global pause bit/flag within game scene
    BOOL gamePaused;
    
    //Player active/inactive state
    BOOL isPlayerFlying;
}

//Default method for handling contact between different physics bodies(SpriteNodes)
-(void)didBeginContact:(SKPhysicsContact *)contact {
    
    // create placeholder reference for the "non player" object
    // This helps us quickly exclude the player and deal directly with objects that the player is colliding into.
    SKPhysicsBody *collisionObject;
    
    if(isPlayerFlying) {
        //Compare bitmask category numbers (having the player be cat=1 helps with this approach)
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
            collisionObject = contact.bodyB;
        } else {
            collisionObject = contact.bodyA;
        }
        
        if (collisionObject.categoryBitMask == buildingCategory) {
            //NSLog(@"Building was hit!");
            [self runAction:_buildingTick];
            
        }
        
        if (collisionObject.categoryBitMask == edgeCategory) {
            //NSLog(@"Scene edge was hit!");
            //[self runAction:_edgeBoing];
            
        }
        
        if (collisionObject.categoryBitMask == groundCategory) {
            //NSLog(@"Ground was hit!");
            [self runAction:_groundSplat];
            
        }
        
        //Transition to game over scene
        if (collisionObject.categoryBitMask == buildingCategory) {
            EndScene *gameOverScene = [EndScene sceneWithSize:self.size];
            NSLog(@"GameScore %i", GAME_SCORE);
            [gameOverScene setFinalScore:GAME_SCORE];
            
            [[GCUtil sharedGameKitUtil] sendScoreToLeaderBoard:GAME_SCORE forLeaderboardID:@"scores"];
            [self.view presentScene:gameOverScene transition:[SKTransition doorsCloseHorizontalWithDuration:1.0]];
        }
    }
    

    
}


//Default method called when scene is fully loaded i believe. Utilizing this for pre-loading audio.
-(void)didMoveToView:(SKView *)view {
    
    //Define sound actions for preloading when scene/view is loaded
    //Bit of a bummer that you can't set audio levels for playSoundFileNamed within SKAction :/
    //Suggestions online say to use AVAudioPlayer which doesn't meet the requirements for this assignment since we need to use proprietary SpriteKit methods to play audio
    
    _edgeBoing      = [SKAction playSoundFileNamed:@"boing.mp3" waitForCompletion:NO];
    _buildingTick   = [SKAction playSoundFileNamed:@"bulbbreaking.mp3" waitForCompletion:NO];
    _groundSplat    = [SKAction playSoundFileNamed:@"splat.mp3" waitForCompletion:NO];
    _buildingPunch  = [SKAction playSoundFileNamed:@"punch.mp3" waitForCompletion:NO];
    _gamePauseTouch = [SKAction playSoundFileNamed:@"camerashutter.mp3" waitForCompletion:NO];
    _playerFlight   = [SKAction playSoundFileNamed:@"woosh.mp3" waitForCompletion:NO];
    
}

//Default method - main init trigger from view controller instatiating scene to load.
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        //Default First Touch
        firstTouch = NO;
        
        //Note: Targeting iphone 6 landscape 667x375/1334x750
        self.backgroundColor = [SKColor whiteColor];
    
        //Add physicsBody to the scene which will trigger collision/contact on edges of the screen
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsBody.categoryBitMask = edgeCategory;
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        
        
        //Need to set contact delegate to self in order to register contacts
        self.physicsWorld.contactDelegate = self;
    
        //Call custom method to build scene
        [self setScene];
        
    }
    return self;
}

//Custom method for building the entire scene
-(void)setScene {
    
    //Instruction Text
    _instructionLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue Bold"];
    _instructionLabel.text = @"Click anywhere to start";
    _instructionLabel.fontColor = [SKColor blackColor];
    _instructionLabel.fontSize = 25;
    _instructionLabel.position = CGPointMake(CGRectGetMidX(self.frame), 250);
    [self addChild:_instructionLabel];
    
    //Description Text
    _descriptionLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue Light"];
    _descriptionLabel.text = @"Keep tapping screen to keep Joe Hanglider in flight. Avoid the buildings.";
    _descriptionLabel.fontColor = [SKColor blackColor];
    _descriptionLabel.fontSize = 10;
    _descriptionLabel.position = CGPointMake(CGRectGetMidX(self.frame), 235);
    [self addChild:_descriptionLabel];
    
    
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
    
    //Add Ground
    _ground = [SKSpriteNode spriteNodeWithImageNamed:@"ground"];
    _ground.position = CGPointMake(CGRectGetMidX(self.frame),_ground.size.height/2);
    _ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_ground.frame.size];
    _ground.physicsBody.dynamic = NO;
    _ground.physicsBody.categoryBitMask = groundCategory;
    _ground.zPosition = 3;
    [self addChild:_ground];
    
    //Add Buildings
    [self setUpBuildings];
    
    //Init Player
    [self initPlayer];
    
    //Add Header Bar
    SKSpriteNode *headerBar = [SKSpriteNode spriteNodeWithImageNamed:@"headerBar"];
    headerBar.position = CGPointMake(CGRectGetMidX(self.frame),(self.frame.size.height - (headerBar.size.height/2)));
    headerBar.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:headerBar.frame.size];
    headerBar.physicsBody.dynamic = NO;
    headerBar.physicsBody.categoryBitMask = groundCategory;
    headerBar.name = @"headerBar";
    [self addChild:headerBar];
    
    
    //Add Pause Button
    SKSpriteNode *pauseButton = [SKSpriteNode spriteNodeWithImageNamed:@"pauseButton"];
    pauseButton.position = CGPointMake((self.frame.size.width -25),self.frame.size.height - pauseButton.size.height/1.5);
    pauseButton.name = @"pauseButton";
    pauseButton.zPosition = 1;
    [self addChild:pauseButton];
    
    //Add Score Labels
    self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue Bold"];
    self.scoreLabel.text = @"meters";
    self.scoreLabel.fontColor = [SKColor blackColor];
    self.scoreLabel.fontSize = 15;
    self.scoreLabel.position = CGPointMake(self.frame.size.width - (20+pauseButton.size.width), self.frame.size.height - headerBar.frame.size.height + self.scoreLabel.frame.size.height);
    self.scoreLabel.zPosition = 1;
    [self.scoreLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeRight];
    [self addChild:_scoreLabel];
    
    
    self.dynamicScore = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue Bold"];
    self.dynamicScore.text = @"000000";
    self.dynamicScore.fontColor = [SKColor colorWithHue:0.58 saturation:0.29 brightness:0.54 alpha:1];
    self.dynamicScore.fontSize = 25;
    self.dynamicScore.position = CGPointMake(self.frame.size.width - (_scoreLabel.frame.size.width+25+pauseButton.size.width), self.frame.size.height - headerBar.frame.size.height + self.dynamicScore.frame.size.height/1.5);
    self.dynamicScore.zPosition = 1;
    [self.dynamicScore setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeRight];
    [self addChild:self.dynamicScore];
    
}

-(void) setUpBuildings {
    
    //Parent Node
    _buildingGroup = [SKNode node];
    _buildingGroup.name = @"buildingGroup";
    
    //Building SpriteNodes
    SKSpriteNode *building1 = [SKSpriteNode spriteNodeWithImageNamed:@"building1"];
    SKSpriteNode *building2 = [SKSpriteNode spriteNodeWithImageNamed:@"building2"];
    SKSpriteNode *building3 = [SKSpriteNode spriteNodeWithImageNamed:@"building3"];
    
    //Define array storing building spriteNode variations
    NSArray * buildingArray = [NSArray arrayWithObjects:building1, building2, building3, nil];
    
    //Loop Count although in the future I would only draw whats needed and then remove + append to the end to reduce node count
    int idealBuildingCount = 25;
    
    //Integer for storing last building x position
    int buildingLastX = 0;
    
    //Spacing in between building. In the future this will be randomized to offer some variety
    //Not using anymore to test out arc4random generation for spacing
    int buildingSpacing = 15;
    
    //Loop through loop count and randomize buildings to be added to parent SkNode group name buildingGroup
    for (int i = 0; i < idealBuildingCount; i++) {
        
        //Randomize building type
        SKSpriteNode * buildingObject = [buildingArray objectAtIndex:arc4random() %3];
        
        //Position building and add all other attributes
        
        //Random building spacing not looking too pretty. Removing for now.
        //buildingObject.position = CGPointMake(buildingLastX + ((buildingObject.size.width/2) + (buildingSpacing + abs(arc4random() %75))),(buildingObject.size.height/2) + _ground.size.height - 35);

        buildingObject.position = CGPointMake(buildingLastX + (buildingObject.size.width/2) + buildingSpacing,(buildingObject.size.height/2) + _ground.size.height - 35);
        buildingLastX = buildingLastX + buildingObject.size.width + buildingSpacing;
        buildingObject.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:buildingObject.frame.size];
        buildingObject.physicsBody.dynamic = NO;
        buildingObject.physicsBody.categoryBitMask = buildingCategory;
        buildingObject.name = [NSString stringWithFormat:@"building%i", i];
        
        //Add building to parent node
        [_buildingGroup addChild:[buildingObject copy]];
    };
    
    //Add parent node to scene view
    [self addChild:_buildingGroup];
    
}

//Custom method to start player animation when game play begins
-(void) animatePlayer {
    if(!isPlayerFlying) {
        
        //play action
        [_player runAction:_playerFlying];
        isPlayerFlying = YES;
    
    } else {
        
        //stop action
        [_player removeAllActions];
        isPlayerFlying = NO;
    }
}

//Custom Method to intialize player sprite node with all of its attributes including physics
-(void) initPlayer {
    NSArray *animationFrames = [self loadFramesFromAtlas:@"player" base:@"player" num:2];
    //Add Player
    _player = [SKSpriteNode spriteNodeWithTexture:[animationFrames objectAtIndex:0]];
    _player.position = CGPointMake(CGRectGetMidX(self.frame), 200);
    _player.name = @"player";
    _player.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:_player.frame.size.width/2];
    _player.physicsBody.friction = 0;
    _player.physicsBody.linearDamping = 0;
    _player.physicsBody.restitution = 1.0f;
    _player.physicsBody.categoryBitMask = playerCategory;
    _player.physicsBody.contactTestBitMask = edgeCategory | buildingCategory | groundCategory;
    _player.zPosition = 2;
    [self addChild:_player];
    
    //Define player animation action to be referenced to global constant SKAction _playerFlying
    SKAction *animationAction = [SKAction animateWithTextures:animationFrames timePerFrame:0.05 resize:YES restore:NO];
    _playerFlying = [SKAction repeatActionForever:animationAction];
    
}

//Custom method to load frames from generic atlas passed to this method.
-(NSArray *)loadFramesFromAtlas:(NSString *)atlasName base:(NSString *)baseFileName num:(int)numberOfFrames {
    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:numberOfFrames];
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:atlasName];
    for(int i=1; i<= numberOfFrames; i++) {
        NSString *fileName = [NSString stringWithFormat:@"%@%01d.png", baseFileName, i];
        [frames addObject:[atlas textureNamed:fileName]];
    }
    
    return frames;
}

//Default method to account for touches within the scene
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    /*
    Looping through all nodes at the touch point. My understanding is that this becomes troublesome
    with parent & child node relationships but works for this assignment.
    Same applies for overlapping nodes.
        -- Will fire touch event for all nodes at that given touch point
    */
    
    if(firstTouch == NO) {
        NSLog(@"firstTouch! - call startGamePlay method");
        [self startGamePlay];
        firstTouch = YES;
    }
    
    for (UITouch *touch in touches)
    {
        CGPoint touchPoint = [touch locationInNode:self];
        NSArray *spriteNodes = [self nodesAtPoint:touchPoint];
        
        if ([spriteNodes count])
        {
            for (SKNode *spriteNode in spriteNodes)
            {
                if ([spriteNode.name isEqualToString:@"building1"])
                {
                    //Building 1
                    //NSLog(@"Building1 Clicked!");
                    [self runAction:_buildingPunch];
                }
                else if ([spriteNode.name isEqualToString:@"building2"])
                {
                    //Building2
                    //NSLog(@"Building2 Clicked!");
                    [self runAction:_buildingPunch];
                }
                else if ([spriteNode.name isEqualToString:@"building3"])
                {
                    //Building3
                    //NSLog(@"Building3 Clicked!");
                    [self runAction:_buildingPunch];
                }
                else if ([spriteNode.name isEqualToString:@"player"])
                {
                    //Player
                    //NSLog(@"Player Clicked!");
                    [self runAction:_playerTouch];
                }
                else if ([spriteNode.name isEqualToString:@"pauseButton"])
                {
                    [self runAction:_gamePauseTouch];
                    [self togglePauseGame];
                    
                    
                }
                else {
                    // create the vector to apply to player
                    CGVector myVector = CGVectorMake(0, 15);
                    // apply the vector as an impulse to launch player to bouncy land.
                    [_player.physicsBody applyImpulse:myVector];
                    [self runAction:_playerFlight];
                }
            }
        }
    }
    
    
}

//Custom method to init gameplay sequence. Otherwise it would be more annoying than it already is.
-(void)startGamePlay {
    
    //Reset Game Score
    GAME_SCORE = 0;
    
    //Remove SKLabelNodes from scene
    [_instructionLabel removeFromParent];
    [_descriptionLabel removeFromParent];
    
    //Trigger Background music to start playing
    [self playBackgroundAudioTrack];
    
    //Set world gravity
    //Change gravity settings of the physics world
    self.physicsWorld.gravity = CGVectorMake(0, -1.5);
    
    [self animatePlayer];
}

//Custom method to play background audio track
-(void)playBackgroundAudioTrack {
    
    //Play Soundtrack/Background Music utilizing AVFoundation AVAudioPlayer
    
    //Specify url of file location
    NSURL * soundTrackURL = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"soundtrack" ofType:@"mp3"]];
    
    //Alloc init and set track for player to play
    _soundTrackPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:soundTrackURL error:nil];
    
    //Specify num of loops (negative number means infinite loops)
    _soundTrackPlayer.numberOfLoops = -1;
    
    //Set Volumne to be substantially lower
    _soundTrackPlayer.volume = .25;
    
    //Play background audio track
    [_soundTrackPlayer play];
    
}

//Custom Helper Method for Animating Buildings right to left
-(void) scrollBuildings {
    
    //For each instance or child node with the name of clouds...do something
    //Similar to a loop construct but simply enumerating through all instances of provided name.
    [self enumerateChildNodesWithName:@"buildingGroup" usingBlock:^(SKNode *node, BOOL *stop) {
        
        //Placeholder node that will be set to the node being enumerated.
        SKSpriteNode *buildings = (SKSpriteNode*) node;
        
        //Setting the speed/velocity of the node. Only affecting the x for the horizontal scrolling effect
        CGPoint bgVelocity = CGPointMake((-5) * CLOUDS_PPS, 0);
        
        //Calculated point
        CGPoint distanceToMove = CGPointMultiplyScalar(bgVelocity, _dt);
        buildings.position = CGPointAdd(buildings.position, distanceToMove);
        
        
        //Check if position is past left edge of scene
        //Buggy.. needs to be readdressed
        if(buildings.position.x <= -self.size.width) {
            //NSLog(@"We are moving past that certain point!");
        }
        
        
    }];
    
}


//Custom Helper Method for Animating Clouds right to left
-(void) scrollClouds {
    
    //For each instance or child node with the name of clouds...do something
    //Similar to a loop construct but simply enumerating through all instances of provided name.
    [self enumerateChildNodesWithName:@"clouds" usingBlock:^(SKNode *node, BOOL *stop) {
        
        //Placeholder node that will be set to the node being enumerated.
        SKSpriteNode *clouds = (SKSpriteNode*) node;
        
        //Setting the speed/velocity of the node. Only affecting the x for the horizontal scrolling effect
        CGPoint bgVelocity = CGPointMake((-1) * CLOUDS_PPS, 0);
        
        //Calculated point
        CGPoint distanceToMove = CGPointMultiplyScalar(bgVelocity, _dt);
        clouds.position = CGPointAdd(clouds.position, distanceToMove);
        
        
        //Check if position is past left edge of scene
        //Buggy.. needs to be readdressed
        if(clouds.position.x <= -self.size.width) {
            //NSLog(@"We are moving past that certain point!");
        }
        
        
    }];
    
}
-(void) updateScore {
    
    GAME_SCORE = GAME_SCORE + SCORING_MULTIPLIER;
    _dynamicScore.text = [NSString stringWithFormat:@"%i", GAME_SCORE];
}

//Custom Helper Methods
//found via Ray Wenderlich forums/articles
static inline CGPoint CGPointMultiplyScalar(const CGPoint a, const CGFloat b) {
    return CGPointMake(a.x * b,a.y *b);
}

static inline CGPoint CGPointAdd(const CGPoint a, const CGPoint b) {
    return CGPointMake(a.x + b.x, a.y + b.y);
}

//Custom method for pausing the game
-(void) togglePauseGame {
    
    if(gamePaused) {
        gamePaused = NO;
        NSLog(@"Game already paused. Unpausing!");
        self.scene.physicsWorld.speed = 1.0;
        self.scene.view.paused = NO;
        
        //Play Game Background Music
        if(![_soundTrackPlayer isPlaying]) {
            [_soundTrackPlayer play];
        }
        
    } else {
        NSLog(@"Pausing Game!");
        gamePaused = YES;
        self.scene.physicsWorld.speed = 0.0;
        self.scene.view.paused = YES;
        
        //Pause Game Background Music
        if([_soundTrackPlayer isPlaying]) {
            [_soundTrackPlayer pause];
        }
    }
}


//Default Method called at each frame interval
-(void)update:(CFTimeInterval)currentTime {
    
    //Conditional to set the deltaTime
    if(_lastFrameUpdateTimeInt) {
        _dt = currentTime - _lastFrameUpdateTimeInt;
    } else {
        _dt = 0;
    }
    
    
    
    //Capture the time for use on next user for lastFrameUpdateTimeInt
    _lastFrameUpdateTimeInt = currentTime;
    
    
    
    if(firstTouch) {
        [self updateScore];
        //Call Methods I want to update
        [self scrollClouds];
        [self scrollBuildings];
    }
    
    
    
}

@end
