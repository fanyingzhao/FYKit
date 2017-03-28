//
//  FYPopView.m
//  FFKit
//
//  Created by fan on 17/3/14.
//  Copyright © 2017年 fan. All rights reserved.
//

#import "FYPopView.h"

@interface FYPopView () {
    
}

@end

@implementation FYPopView

- (void)dealloc {
    FYLog(@"phpView destory");
}

#pragma mark - init
- (instancetype)init {
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.duration = 0.3;
    self.attacView = [UIApplication sharedApplication].keyWindow;
    self.shouldUseCover = YES;
    self.modal = YES;
}

#pragma mark - funcs
- (void)show {
    [self show:nil];
}

- (void)show:(FYPopCompletionBlock)completionBlock {
    [self showWithBlock:nil completion:completionBlock];
}

- (void)showWithBlock:(FYPopStartBlock)startBlock completion:(FYPopCompletionBlock)completionBlock {
    [self showWithDuration:self.duration options:FYPopAnimationOptionsNone startBlock:startBlock completion:completionBlock];
}

- (void)showWithDuration:(NSTimeInterval)duration options:(FYPopAnimationOptions)options startBlock:(FYPopStartBlock)startBlock completion:(FYPopCompletionBlock)completionBlock {
    self.showStartBlock = startBlock;
    self.showCompletionBlock = completionBlock;
    
    [self showDimCover];
    
    if (self.showAnimationBlock) {
        self.showAnimationBlock(self);
    }else {
        switch (self.options) {
            case FYPopAnimationOptionsNone: {
                
            }
                break;
            case FYPopAnimationOptionsDrop: {
                [self dropShowAnimation];
            }
                break;
            case FYPopAnimationOptionsUp: {
                [self upShowAnimation];
            }
                break;
            case FYPopAnimationOptionsBigger: {
                [self biggerShowAnimation];
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)hide {
    [self hide:nil];
}

- (void)hide:(FYPopCompletionBlock)completionBlock {
    [self hide:nil completion:completionBlock];
}

- (void)hide:(FYPopStartBlock)startBlock completion:(FYPopCompletionBlock)completionBlock {
    self.hideStartBlock = startBlock;
    self.hideCompletionBlock = completionBlock;
    
    if (self.hideAnimationBlock) {
        self.hideAnimationBlock(self);
    }else {
        switch (self.options) {
            case FYPopAnimationOptionsNone: {
                
            }
                break;
            case FYPopAnimationOptionsDrop: {
                [self dropHideAnimation];
            }
                break;
            case FYPopAnimationOptionsUp: {
                [self upHideAnimation];
            }
                break;
            case FYPopAnimationOptionsBigger: {
                [self biggerHideAnimation];
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - animation
- (void)dropShowAnimation {
    CAKeyframeAnimation* keyframe = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
    keyframe.values = @[@(0),@(200),@(100)];
    keyframe.duration = self.duration;
    keyframe.removedOnCompletion = NO;
    keyframe.fillMode = kCAFillModeBackwards;
    [self.layer addAnimation:keyframe forKey:@""];
    
    CABasicAnimation* base = [CABasicAnimation animationWithKeyPath:@"opacity"];
    base.toValue = @(1.);
    base.duration = self.duration;
    base.removedOnCompletion = NO;
    base.fillMode = kCAFillModeForwards;
    [self.coverView.layer addAnimation:base forKey:@""];
    self.coverView.layer.opacity = 1;
}

- (void)dropHideAnimation {
    CAKeyframeAnimation* keyframe = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
    keyframe.values = @[@(self.top),@(0)];
    keyframe.duration = self.duration;
    keyframe.removedOnCompletion = NO;
    keyframe.fillMode = kCAFillModeBackwards;
    [self.layer addAnimation:keyframe forKey:@""];

    CABasicAnimation* base = [CABasicAnimation animationWithKeyPath:@"opacity"];
    base.toValue = @(0.);
    base.duration = self.duration;
    base.removedOnCompletion = NO;
    base.fillMode = kCAFillModeForwards;
    [self.coverView.layer addAnimation:base forKey:@""];
    self.coverView.layer.opacity = 0;
}

- (void)upShowAnimation {
    
}

- (void)upHideAnimation {
    
}

- (void)biggerShowAnimation {
    
}

- (void)biggerHideAnimation {
    
}

#pragma mark - events
- (void)tapClick:(UITapGestureRecognizer*)tap {
    [self.attacView.subviews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[FYPopView class]]) {
            FYPopView* view = (FYPopView*)obj;
            [view hide:view.hideStartBlock completion:view.hideCompletionBlock];
        }
    }];
}

#pragma mark - tools
- (void)showDimCover {
    BOOL res = NO;
    for (UIView* view in self.attacView.subviews) {
        if (view.tag == 1000) {
            res = YES;
            break;
        }
    }
    
    if (!res) {
        UIView* coverView = [self getCoverView];
        self.coverView = coverView;
        [self.attacView addSubview:self.coverView];
        [self.coverView addSubview:self];        
    }else {
        [self.attacView addSubview:self];
    }
}

- (UIView*)getCoverView {
    UIView* coverView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    coverView.backgroundColor = UICOLOR_HEX_ALPHA(0x000000, 0.7);
    coverView.layer.opacity = 0;
    coverView.tag = 1000;
    
    if (self.modal) {
        coverView.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [coverView addGestureRecognizer:tap];
    }
    
    return coverView;
}

#pragma mark - setter

#pragma mark - getter


@end
