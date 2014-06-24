//
//  NIEViewController.m
//  CustomShareView
//
//  Created by Liuyong on 14-6-24.
//  Copyright (c) 2014年 NetEase. All rights reserved.
//

#import "NIEViewController.h"

#import "NIEShareView.h"

@interface NIEViewController ()

@property (nonatomic, strong) NIEShareView *shareView;
@property (nonatomic, strong) UIButton *btn;

@end

@implementation NIEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.shareView = [[NIEShareView alloc] initWithTitle:@"分享到" itemTitles:@[@"微信", @"易信"] images:@[ [UIImage imageNamed:@"shareToWeChat"],[UIImage imageNamed:@"shareToYixin"]]];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btn = btn;
    self.btn.titleLabel.text = @"Share";
    [self.btn setTitle:@"Share" forState:UIControlStateNormal];
    self.btn.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.btn];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.btn.frame = CGRectMake(50, 100, 120, 44);
   
}

- (void)onTapButton:(id)sender
{
    NSLog(@"onTapButton");
    [self.shareView showInview:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
