//
//  GameViewController.m
//  ProjectHangGlider
//
//  Michael Edelnant
//  Immersive Application Deployment Term 1502
//  Week 2 - Immersive Element Integration
//
//  Created by vAesthetic on 02/10/15.
//  Copyright (c) 2015 medelnant. All rights reserved.
//

#import "GameViewController.h"
#import "MainMenu.h"
#import "GCUtil.h"

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    skView.showsPhysics = NO;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    // GameScene *scene = [GameScene unarchiveFromFile:@"GameScene"];
    
    // Using sceneWithSize which triggers my initWithSize method within the scene class. From reading, my understanding is that this approach
    // is more efficient and called earlier than didMoveToScene.
    SKScene * scene = [MainMenu sceneWithSize:skView.bounds.size];
    
    // Set the scalemode which default is set to AspectFill
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    //NSLog the size of the skView (width/height) for debugging purposes
    NSLog(@"screen width: %f", skView.bounds.size.width);
    NSLog(@"screen height: %f", skView.bounds.size.height);
    
    // Present the scene.
    [skView presentScene:scene];

}


- (BOOL)shouldAutorotate
{
    return YES;
}


- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


@end
