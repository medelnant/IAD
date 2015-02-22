//
//  GCUtil.h
//  ProjectHangGlider
//
//  Created by vAesthetic on 2/22/15.
//  Copyright (c) 2015 medelnant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

extern NSString *const PresentAuthenticationViewController;

@interface GCUtil : NSObject

@property (nonatomic, readonly) UIViewController *authenticationViewController;
@property (nonatomic, readonly) NSError *lastError;

+ (instancetype)sharedGameKitUtil;
- (void)authenticateLocalPlayer;
- (void) sendScoreToLeaderBoard: (int64_t)score forLeaderboardID:(NSString*)identifier;


@end
