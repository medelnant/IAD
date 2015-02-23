//
//  GCNavigationViewController.m
//  ProjectHangGlider
//
//  Michael Edelnant
//  Immersive Application Deployment Term 1502
//  Week 3 - Leaderboards
//
//  Created by vAesthetic on 2/19/15.
//  Copyright (c) 2015 medelnant. All rights reserved.
//

#import "GCNavigationViewController.h"
#import "GCUtil.h"

@implementation GCNavigationViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showAuthenticationViewController)
     name:PresentAuthenticationViewController
     object:nil];
    
    [[GCUtil sharedGameKitUtil]
     authenticateLocalPlayer];
}

- (void)showAuthenticationViewController
{
    GCUtil *gameKitUtil =
    [GCUtil sharedGameKitUtil];
    
    [self.topViewController presentViewController:
     gameKitUtil.authenticationViewController
                                         animated:YES
                                       completion:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
