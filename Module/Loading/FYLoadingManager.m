//
//  FYLoadingAnimation.m
//  FFKit
//
//  Created by fan on 17/3/7.
//  Copyright © 2017年 fan. All rights reserved.
//

#import "FYLoadingManager.h"
#import "FYCommonAnimation.h"

@interface FYLoadingManager () {
    
}

@end

@implementation FYLoadingManager

- (instancetype)initWithView:(UIView *)attachView {
    if (self = [super init]) {
        if (!attachView) {
            attachView = [UIApplication sharedApplication].keyWindow;
        }
        
        _attachView = attachView;
        _orient = UIDeviceOrientationPortrait;
    }
    return self;
}

- (void)showLoading {
    [self showLoadingModel:LoadingModeCommonOne animation:LoadingAnimationModeFade];
}

- (void)showLoadingModel:(LoadingMode)mode animation:(LoadingAnimationMode)animationMode {
    if (mode == LoadingModeCommonOne || mode == LoadingModeCommonTow) {
        FYCommonAnimation* common = [[FYCommonAnimation alloc] initWithFrame:({
            CGRect rect;
            rect.size = CGSizeMake(KBackViewSize, KBackViewSize);
            rect.origin.x = (CGRectGetWidth(self.attachView.frame) - CGRectGetWidth(rect)) / 2;
            rect.origin.y = (CGRectGetHeight(self.attachView.frame) - CGRectGetHeight(rect)) / 2;
            rect;
        })];
        common.manager = self;
        [self.attachView addSubview:common];
        _animation = common;
        
        [common show];
    }
}

- (void)showLoadingWithAnimation:(FYLoadingAnimation *)animation {
    _animation = animation;
    
    [animation show];
}

- (void)hideLoading {
    [self hideLoadingCompletion:nil];
}

- (void)hideLoadingCompletion:(FYLoadingCompletionBlock)completionBlock {
    [_animation hideWithCompletion:completionBlock];
    [_animation removeFromSuperview];
}

#pragma mark - notification
- (void)orientationUpdate:(UIDeviceOrientation)interfaceOrientation {
    if (_orient == interfaceOrientation) {
        return ;
    }
    
    float angle = 0;
    
    switch (interfaceOrientation) {
        case UIDeviceOrientationPortrait: {
            switch (_orient) {
                case UIDeviceOrientationLandscapeLeft: {
                    angle = M_PI_2;
                }
                    break;
                case UIDeviceOrientationLandscapeRight: {
                    angle = -M_PI_2;
                }
                    break;
                case UIDeviceOrientationPortraitUpsideDown: {
                    angle = M_PI;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case UIDeviceOrientationLandscapeLeft: {
            switch (_orient) {
                case UIDeviceOrientationPortrait: {
                    angle = -M_PI_2;
                }
                    break;
                case UIDeviceOrientationLandscapeRight: {
                    angle = -M_PI;
                }
                    break;
                case UIDeviceOrientationPortraitUpsideDown: {
                    angle = M_PI_2;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case UIDeviceOrientationLandscapeRight: {
            switch (_orient) {
                case UIDeviceOrientationLandscapeLeft: {
                    angle = M_PI;
                }
                    break;
                case UIDeviceOrientationPortraitUpsideDown: {
                    angle = -M_PI_2;
                }
                    break;
                case UIDeviceOrientationPortrait: {
                    angle = M_PI_2;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case UIDeviceOrientationPortraitUpsideDown: {
            switch (_orient) {
                case UIDeviceOrientationLandscapeLeft: {
                    angle = -M_PI_2;
                }
                    break;
                case UIDeviceOrientationLandscapeRight: {
                    angle = M_PI_2;
                }
                    break;
                case UIDeviceOrientationPortrait: {
                    angle = M_PI;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    
    _orient = interfaceOrientation;
    
    [self updateLoadingOrient:angle];
}

#pragma mark - ClassMethod
+ (instancetype)showLoading {
    return [self showLoadingForView:nil];
}

+ (instancetype)showLoadingForView:(UIView *)view {
    return [self showLoadingForView:view mode:LoadingModeCommonOne animation:LoadingAnimationModeFade];
}

+ (instancetype)showLoadingForView:(UIView *)view mode:(LoadingMode)mode animation:(LoadingAnimationMode)animationMode {
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    FYLoadingManager* manager = [[FYLoadingManager alloc] initWithView:view];
    
    if (mode == LoadingModeCommonOne || mode == LoadingModeCommonTow) {
        FYCommonAnimation* common = [[FYCommonAnimation alloc] initWithFrame:({
            CGRect rect;
            rect.size = CGSizeMake(KBackViewSize, KBackViewSize);
            rect.origin.x = (CGRectGetWidth(view.frame) - CGRectGetWidth(rect)) / 2;
            rect.origin.y = (CGRectGetHeight(view.frame) - CGRectGetHeight(rect)) / 2;
            rect;
        })];
        [view addSubview:common];
        manager->_animation = common;
        common.manager = manager;
        [common show];
    }
    
    return manager;
}

+ (void)hideLoadingForView:(UIView *)view {
    [self hideLoadingForView:view completion:nil];
}

+ (void)hideLoadingForView:(UIView *)view completion:(FYLoadingCompletionBlock)completionBlock{
    FYLoadingAnimation* animationView = [FYLoadingManager loadingForView:view];
    [animationView hideWithCompletion:completionBlock];
    [animationView removeFromSuperview];
    animationView.manager = nil;
}

#pragma mark - tools
- (void)updateLoadingOrient:(float)angle {
    FYLoadingAnimation* animationView = [FYLoadingManager loadingForView:self.attachView];

    [UIView animateWithDuration:0.25 animations:^{
        animationView.transform = CGAffineTransformMakeRotation(angle);
        animationView.center = CGPointMake(CGRectGetWidth(self.attachView.frame) / 2, CGRectGetHeight(self.attachView.frame) / 2);
        
    } completion:^(BOOL finished) {
        [animationView setNeedsLayout];
    }];
}

+ (FYLoadingAnimation*)loadingForView:(UIView*)view {
    FYLoadingAnimation* animationView;
    for (UIView* subView in view.subviews) {
        if ([subView isKindOfClass:[FYLoadingAnimation class]]) {
            animationView = (FYLoadingAnimation*)subView;
            break;
        }
    }
    
    return animationView;
}

#pragma mark - setter
- (void)setOrient:(UIDeviceOrientation)orient {
    [self orientationUpdate:orient];
}

#pragma mark - getter

@end
