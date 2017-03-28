//
//  VideoRecordViewController.m
//  FFKit
//
//  Created by fan on 16/7/27.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "VideoRecordViewController.h"

@interface VideoRecordViewController () {
//    FYVideoRecordView* _videoView;
}

@end

@implementation VideoRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavRightItemWithTitle:@"结束" selector:@selector(btnClick:)];
    
//    _videoView = [[FYVideoRecordView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:_videoView];
//    [_videoView.session startRunning];
//    [_videoView startRecord];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [_videoView startRecord];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnClick:(UIButton*)sender {
//    [_videoView stopRecord];
}

@end
