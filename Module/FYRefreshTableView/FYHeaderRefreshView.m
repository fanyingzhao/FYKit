//
//  FYHeaderRefreshView.m
//  FYTableView
//
//  Created by fan on 16/8/1.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "FYHeaderRefreshView.h"
#import "FYMacro.h"
#import <SDWebImage/UIImage+GIF.h>

@interface FYHeaderRefreshView () {
    
}

@end

@implementation FYHeaderRefreshView
- (instancetype)initWithFrame:(CGRect)frame tableView:(UITableView *)tableView {
    if (self = [super initWithFrame:frame tableView:tableView]) {
        self.pullLimit = 80;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.frame = ({
        CGRect rect;
        rect.size.width = CGRectGetWidth(self.tableView.bounds);
        rect.size.height = CGRectGetHeight(self.bounds);
        rect.origin.x = 0;
        rect.origin.y = -CGRectGetHeight(rect);
        rect;
    });
}

#pragma mark - init

#pragma mar - setter
- (void)setPullLimit:(CGFloat)pullLimit {
    pullLimit = pullLimit < 0 || pullLimit > 200 ? 80 : pullLimit;
    [super setPullLimit:pullLimit];
}

@end



@interface FYGifHeaderRefreshView () {
}
@property (nonatomic, strong) UIImageView* imageView;
@end

@implementation FYGifHeaderRefreshView
- (instancetype)initWithFrame:(CGRect)frame tableView:(UITableView *)tableView {
    self = [super initWithFrame:frame tableView:tableView];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2);
}

#pragma mark - init
- (void)setUp {
    [self addSubview:self.imageView];
}

#pragma mark - funcs
- (void)startLoading {
    
}

- (void)stopLoading {

}

#pragma mark - setter
- (void)setGifImagePath:(NSString *)gifImagePath {
    if ([_gifImagePath isEqualToString:gifImagePath]) {
        return ;
    }
    _gifImagePath = gifImagePath;
    NSAssert(gifImagePath, @"gifImage 为nil");
    self.imageView.image = [UIImage sd_animatedGIFNamed:gifImagePath];
    [self.imageView sizeToFit];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _imageView;
}

@end