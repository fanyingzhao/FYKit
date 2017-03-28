//
//  FYLoadingView.m
//  FFKit
//
//  Created by fan on 17/3/7.
//  Copyright © 2017年 fan. All rights reserved.
//

#import "FYLoadingAnimation.h"

@implementation FYLoadingAnimation

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.backView];
    }
    return self;
}

#pragma mark - tools

#pragma mark - layout
- (void)layoutSubviews {
    switch (self.manager.orient) {
        case UIDeviceOrientationPortrait: {
            self.backView.layer.shadowOffset = CGSizeMake(4, 4);
        }
            break;
        case UIDeviceOrientationLandscapeLeft: {
            self.backView.layer.shadowOffset = CGSizeMake(-4, 4);
        }
            break;
        case UIDeviceOrientationLandscapeRight: {
            self.backView.layer.shadowOffset = CGSizeMake(4, -4);
        }
            break;
        case UIDeviceOrientationFaceDown: {
            self.backView.layer.shadowOffset = CGSizeMake(-4, -4);
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - getter
- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:({
            CGRect rect;
            rect.size.width = 150;
            rect.size.height = 150;
            rect.origin = CGPointMake(0, 0);
            rect;
        })];
        _backView.backgroundColor = UICOLOR_RGB(70, 70, 70);
        _backView.layer.cornerRadius = 8;
        _backView.layer.shadowOpacity = 0.5;
        _backView.layer.shadowOffset = CGSizeMake(4, 4);
    }
    return _backView;
}


@end
