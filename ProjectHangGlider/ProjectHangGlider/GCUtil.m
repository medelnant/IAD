//
//  GCUtil.m
//  ProjectHangGlider
//
//  Michael Edelnant
//  Immersive Application Deployment Term 1502
//  Week 3 - Leaderboards
//
//  Created by vAesthetic on 2/20/15.
//  Copyright (c) 2015 medelnant. All rights reserved.
//

#import "GCUtil.h"

NSString *const PresentAuthenticationViewController = @"present_authentication_view_controller";

/* Preface: A majority of this helper class code was modeled from Ray Weinderlich's tutorial on working with gameCenter */

@implementation GCUtil {
    BOOL _enableGameCenter;
}

+ (instancetype)sharedGameKitUtil
{
    static GCUtil *sharedGameKitUtil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGameKitUtil = [[GCUtil alloc] init];
    });
    return sharedGameKitUtil;
}

- (id)init
{
    self = [super init];
    if (self) {
        _enableGameCenter = YES;
    }
    return self;
}

- (void)authenticateLocalPlayer
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler  =
    ^(UIViewController *viewController, NSError *error) {
        [self setLastError:error];
        
        if(viewController != nil) {
            [self setAuthenticationViewController:viewController];
        } else if([GKLocalPlayer localPlayer].isAuthenticated) {
            _enableGameCenter = YES;
            [self retrieveAchievmentMetadata];
        } else {
            _enableGameCenter = NO;
        }
    };
}

- (void)setAuthenticationViewController:(UIViewController *)authenticationViewController {
    if (authenticationViewController != nil) {
        _authenticationViewController = authenticationViewController;
        [[NSNotificationCenter defaultCenter]
         postNotificationName:PresentAuthenticationViewController
         object:self];
    }
}

- (void)setLastError:(NSError *)error {
    _lastError = [error copy];
    if (_lastError) {
        NSLog(@"GameKitHelper ERROR: %@",
              [[_lastError userInfo] description]);
    }
}

-(void)sendScoreToLeaderBoard:(int64_t)score forLeaderboardID:(NSString *)identifier {
    
    NSLog(@"Sending Scores to leaderboard");
    
    GKScore *_score = [[GKScore alloc] initWithLeaderboardIdentifier:identifier];
    _score.value = score;
    _score.context = 0;
    _score.shouldSetDefaultLeaderboard = YES;
    
    [GKScore reportScores:@[_score] withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        } else {
            NSLog(@"Score Sent to GameCenter!");
        }
    }];
    
}

- (void) retrieveAchievmentMetadata
{
    self.achievementsDescDictionary = [[NSMutableDictionary alloc] initWithCapacity:2];
    
    [GKAchievementDescription loadAchievementDescriptionsWithCompletionHandler:
     ^(NSArray *descriptions, NSError *error) {
         if (error != nil) {
             NSLog(@"Error %@", error);
             
         } else {
             if (descriptions != nil){
                 for (GKAchievementDescription* descriptionObj in descriptions) {
                     [_achievementsDescDictionary setObject: descriptionObj forKey: descriptionObj.identifier];
                 }
             }
         }
     }];
}






@end
