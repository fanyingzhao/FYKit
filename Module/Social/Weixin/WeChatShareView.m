//
//  WeChatShareView.m
//  FFKit
//
//  Created by fan on 16/7/28.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "WeChatShareView.h"

static const CGFloat containViewHeight  = 150.f;
static const CGFloat animationDuration  = 0.3f;

#define PADDING 8.F

@interface WeChatShareView ()
@property (nonatomic, strong) UIView* containView;

@end

@implementation WeChatShareView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)didMoveToSuperview {
    [self shareViewShow];
}

#pragma mark - init
- (void)setUp {
    self.backgroundColor = UICOLOR_HEX_ALPHA(0x000000, 0.7);
    [self addSubview:self.containView];
    [self setShareButtonView];
}

- (void)setShareButtonView {
    NSArray *normalButtonImageArray = @[@"btn_wechat_normal", @"btn_moment_normal"];
    NSArray *highButtonImageArray = @[@"btn_wechat_pressed", @"btn_moment_pressed"];
    
    CGFloat shareButtonWidth = 44.f;
    CGFloat originX = CGRectGetWidth(self.containView.bounds) / 2 - PADDING * 4 - shareButtonWidth;
    for (int i = 0; i < normalButtonImageArray.count; ++i) {
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareButton setImage:[UIImage imageNamed:normalButtonImageArray[i]] forState:UIControlStateNormal];
        [shareButton setImage:[UIImage imageNamed:highButtonImageArray[i]] forState:UIControlStateHighlighted];
        [shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        shareButton.tag = i + 100;
        shareButton.size = CGSizeMake(shareButtonWidth, shareButtonWidth);
        shareButton.origin = CGPointMake(originX, (CGRectGetHeight(self.containView.bounds) / 2 - PADDING * 3.5));
        [self.containView addSubview:shareButton];
        
        originX = self.width / 2 + PADDING * 4;
    }
}

#pragma mark - animation
- (void)shareViewShow {
    if (self.showAnimation) self.showAnimation();
    else {
        self.containView.frame = ({
            CGRect rect;
            rect.size = self.containView.bounds.size;
            rect.origin.x = CGRectGetMinX(self.containView.frame);
            rect.origin.y = CGRectGetHeight(self.bounds);
            rect;
        });
        [UIView animateWithDuration:animationDuration animations:^{
            self.containView.frame = ({
                CGRect rect;
                rect.size = self.containView.bounds.size;
                rect.origin.x = CGRectGetMinX(self.containView.frame);
                rect.origin.y = CGRectGetHeight(self.bounds) - CGRectGetHeight(rect);
                rect;
            });
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)shareViewHidden {
    if (self.hiddenAnimation) self.hiddenAnimation();
    else {
        self.containView.frame = ({
            CGRect rect;
            rect.size = self.containView.bounds.size;
            rect.origin.x = CGRectGetMinX(self.containView.frame);
            rect.origin.y = CGRectGetHeight(self.bounds) - CGRectGetHeight(rect);
            rect;
        });
        [UIView animateWithDuration:animationDuration animations:^{
            self.containView.frame = ({
                CGRect rect;
                rect.size = self.containView.bounds.size;
                rect.origin.x = CGRectGetMinX(self.containView.frame);
                rect.origin.y = CGRectGetHeight(self.bounds);
                rect;
            });
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

#pragma mark - events
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self shareViewHidden];
}

- (void)shareButtonAction:(UIButton*)sender {
    if (self.btnClick) {
        self.btnClick((ShareType)(sender.tag - 100));
    }
}

#pragma mark - getter
- (UIView *)containView {
    if (!_containView) {
        _containView = [[UIView alloc] initWithFrame:({
            CGRect rect;
            rect.size.width = CGRectGetWidth(self.bounds);
            rect.size.height = containViewHeight;
            rect.origin.x = 0;
            rect.origin.y = CGRectGetHeight(self.bounds);
            rect;
        })];
        _containView.backgroundColor = [UIColor whiteColor];
    }
    return _containView;
}

@end
