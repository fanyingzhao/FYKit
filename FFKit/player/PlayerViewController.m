//
//  PlayerViewController.m
//  FFKit
//
//  Created by fan on 16/7/26.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "PlayerViewController.h"
#import "FYPlayerView.h"
#import "DownManagerViewController.h"

@interface PlayerViewController ()<FYPlayerViewDelegate> {
    FYPlayerView* _playerView;
}

@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setNavRightItemWithTitle:@"设置" selector:@selector(navRightBtnClick:)];
    
    VideoModel* model = [[VideoModel alloc] init];
    model.videoUrl = [NSURL URLWithString:@"http://o9u0b7owm.bkt.clouddn.com/1007/vr/quqianqiao.mp4"];
    model.panorama = YES;
    VideoModel* model1 = [[VideoModel alloc] init];
    model1.videoUrl = [NSURL URLWithString:@"http://o9u0b7owm.bkt.clouddn.com/1007/vr/fqdj0712.mp4"];
    model1.panorama = YES;
    
    _playerView = [[FYPlayerView alloc] initWithFrame:({
        CGRect rect;
        rect.size.width = CGRectGetWidth(self.view.bounds);
        rect.size.height = CGRectGetWidth(rect) / 16 * 9;
        rect.origin.x = 0;
        rect.origin.y = 64;
        rect;
    })];
    _playerView.backgroundColor = [UIColor orangeColor];
//    _playerView.model = model;
    _playerView.shouldDownloadWhilePlaying = YES;
    _playerView.playList = @[model,model1].mutableCopy;
    _playerView.delegate = self;
    [self.view addSubview:_playerView];
}

#pragma mark - FYPlayerViewDelegate
- (void)playerViewBackBtnDidTouched:(FYPlayerView *)playerView {
   
}

- (void)playerViewFullBtnDidTouched:(FYPlayerView *)playerView {
    if (playerView.full) [self.navigationController setNavigationBarHidden:YES animated:YES];
    else [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - events
- (void)navRightBtnClick:(UIButton*)sender {
    DownManagerViewController* vc = [[DownManagerViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
