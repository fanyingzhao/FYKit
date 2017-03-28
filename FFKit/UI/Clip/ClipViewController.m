//
//  ClipViewController.m
//  FFKit
//
//  Created by fan on 16/7/27.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "ClipViewController.h"
#import "FYClipView.h"

@interface ClipViewController () {
    FYClipView* _clipView;
}
@property (nonatomic, strong) UIImageView* imageView;
@end

@implementation ClipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
    [self setNavRightItemWithTitle:@"裁剪" selector:@selector(btnClick:)];
    
    _clipView = [[FYClipView alloc] initWithFrame:self.view.bounds];
    _clipView.image = [UIImage imageNamed:@"smallImage.jpg"];
    _clipView.clipType = ClipTypeCircle;
    [self.view addSubview:_clipView];
    [self.view addSubview:self.imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnClick:(UIButton*)sender {
    self.imageView.image = [_clipView clip];
    _clipView.hidden = YES;
}

#pragma mark - getter
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:({
            CGRect rect;
            rect.size.width = 200;
            rect.size.height = 200;
            rect.origin.x = (CGRectGetWidth(self.view.bounds) - CGRectGetWidth(rect)) / 2;
            rect.origin.y = 200;
            rect;
        })];
    }
    return _imageView;
}

@end
