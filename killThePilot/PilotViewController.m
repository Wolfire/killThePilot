//
//  PilotViewController.m
//  killThePilot
//
//  Created by wolfire on 3/27/14.
//  Copyright (c) 2014 wolfire. All rights reserved.
//

#import "PilotViewController.h"
#import "PlaneScene.h"
#import <SpriteKit/SpriteKit.h>
#import <QuartzCore/QuartzCore.h>

@interface PilotViewController ()

@end

@implementation PilotViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    
    // Create and configure the scene.
    SKScene * scene = [PlaneScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
    
    UIImage *image = [UIImage imageNamed:@"BurstAircraftPause"];
    UIButton *button = [[UIButton alloc]init];
    [button setFrame:CGRectMake(10, 25, image.size.width,image.size.height)];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    // waiting for game over
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(gameOver)
                                                name:@"gameOverNotification"
                                              object:nil];
    // waiting for an inactive status
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(inactive)
                                                name:UIApplicationWillResignActiveNotification
                                              object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)inactive {
    [self pause];
}

- (void)gameOver {
    ((SKView *)self.view).paused = YES;
    UIView *backgroundView =  [[UIView alloc]initWithFrame:self.view.bounds];
    
    UIButton *button = [[UIButton alloc]init];
    [button setBounds:CGRectMake(0, 0, 200, 30)];
    [button setCenter:backgroundView.center];
    [button setTitle:@"重新开始" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.layer setBorderWidth:2.0];
    [button.layer setCornerRadius:15.0];
    [button.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [button addTarget:self action:@selector(restart:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:button];
    [backgroundView setCenter:self.view.center];
    
    [self.view addSubview:backgroundView];
}

- (void)pause {
    ((SKView *)self.view).paused = YES;
    UIView *pauseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 200)];
    
    UIButton *button1 = [[UIButton alloc]init];
    [button1 setFrame:CGRectMake(CGRectGetWidth(self.view.frame) / 2 - 100, 50, 200, 30)];
    [button1 setTitle:@"继续" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button1.layer setBorderWidth:2.0];
    [button1.layer setCornerRadius:15.0];
    [button1.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [button1 addTarget:self action:@selector(continueGame:) forControlEvents:UIControlEventTouchUpInside];
    [pauseView addSubview:button1];
    
    UIButton *button2 = [[UIButton alloc]init];
    [button2 setFrame:CGRectMake(CGRectGetWidth(self.view.frame) / 2 - 100, 100, 200, 30)];
    [button2 setTitle:@"重新开始" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button2.layer setBorderWidth:2.0];
    [button2.layer setCornerRadius:15.0];
    [button2.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [button2 addTarget:self action:@selector(restart:) forControlEvents:UIControlEventTouchUpInside];
    [pauseView addSubview:button2];
    pauseView.center = self.view.center;
    
    [self.view addSubview:pauseView];
}

- (void)restart:(UIButton *)button{
    [button.superview removeFromSuperview];
    ((SKView *)self.view).paused = NO;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"restartNotification" object:nil];
}

- (void)continueGame:(UIButton *)button{
    [button.superview removeFromSuperview];
    ((SKView *)self.view).paused = NO;
}

@end
