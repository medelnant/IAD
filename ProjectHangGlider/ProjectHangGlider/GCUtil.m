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
    //1
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    //2
    localPlayer.authenticateHandler  =
    ^(UIViewController *viewController, NSError *error) {
        //3
        [self setLastError:error];
        
        if(viewController != nil) {
            //4
            [self setAuthenticationViewController:viewController];
        } else if([GKLocalPlayer localPlayer].isAuthenticated) {
            //5
            _enableGameCenter = YES;
        } else {
            //6
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

@end
