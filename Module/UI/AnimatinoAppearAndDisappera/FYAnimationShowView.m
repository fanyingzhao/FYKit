//
//  FYAnimationShowView.m
//  MyPlane
//
//  Created by fan on 16/8/18.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "FYAnimationShowView.h"

@interface FYAnimationShowView () {

}

@end

@implementation FYAnimationShowView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.shouldCover = YES;
        self.autoHidden = YES;
        self.duration = 0.3;
        self.backgroundColor = [UIColor whiteColor];
        self.options = FYAnimationOptionsShowFromSmall;
        
        self.finishRect = ({
            CGRect rect;
            rect.size = self.size;
            rect.origin.x = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth(rect)) / 2;
            rect.origin.y = (CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetHeight(rect)) / 2;
            rect;
        });
    }
    return self;
}

- (void)dealloc {
    FYLog(@"view destory");
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (void)show {
    [self.attachView addSubview:self];

    if (self.shouldCover) {
        [self.attachView insertSubview:self.coverView belowSubview:self];
    }
    
    if (self.options & FYAnimationOptionsShowFromLeft) {
        _originRect =  ({
            CGRect rect;
            rect.size = self.size;
            rect.origin.x = -CGRectGetWidth(rect);
            rect.origin.y = (CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetHeight(rect)) / 2;
            rect;
        });
    }else if (self.options & FYAnimationOptionsShowFromRight) {
        _originRect =  ({
            CGRect rect;
            rect.size = self.size;
            rect.origin.x = CGRectGetWidth(rect);
            rect.origin.y = (CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetHeight(rect)) / 2;
            rect;
        });
    }else if (self.options & FYAnimationOptionsShowFromTop) {
        _originRect =  ({
            CGRect rect;
            rect.size = self.size;
            rect.origin.x = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth(rect)) / 2;
            rect.origin.y = -CGRectGetHeight(rect);
            rect;
        });
    }else if (self.options & FYAnimationOptionsShowFromBottom) {
        _originRect =  ({
            CGRect rect;
            rect.size = self.size;
            rect.origin.x = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth(rect)) / 2;
            rect.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds);
            rect;
        });
    }else if (self.options & FYAnimationOptionsShowFromAlpha) {
        _originRect = ({
            CGRect rect;
            rect.size = self.size;
            rect.origin.x = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth(rect)) / 2;
            rect.origin.y = (CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetHeight(rect)) / 2;
            rect;
        });
        self.alpha = 0.f;
    }else if (self.options & FYAnimationOptionsShowFromSmall) {
        _originRect = ({
            CGRect rect;
            rect.origin.x = UIDEVICE_SCREEN_WIDTH / 2;
            rect.origin.y = UIDEVICE_SCREEN_HEIGHT / 2;
            rect.size.width = 0;
            rect.size.height = 0;
            rect;
        });
    }
    
    if (self.showAnimation) {
        self.showAnimation(self, self.finishRect);
        
        return ;
    }
    
    self.frame = _originRect;
    
    if (self.options & FYAnimationOptionsShowFromSmall) {
        if (self.layer.cornerRadius) {
            self.frame = self.finishRect;
            if (self.options & FYAnimationOptionsElastic) {
                CASpringAnimation* animation = [CASpringAnimation animationWithKeyPath:@"transform.scale"];
                animation.damping = 5;
                animation.mass = 1;
                animation.initialVelocity = 6;
                animation.stiffness = 50;
                animation.fromValue = @(0);
                animation.toValue = @(1);
                animation.duration = self.duration;
                [self.layer addAnimation:animation forKey:@"show_elastic"];
                
                [UIView animateWithDuration:self.duration animations:^{
                    self.alpha = 1.f;
                    self.coverView.alpha = 0.7;
                } completion:^(BOOL finished) {
                    if (self.showAnimationEnd) {
                        self.showAnimationEnd(self);
                    }
                }];
            }else if (self.options & FYAnimationOptionsLinear) {
                CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                animation.fromValue = @(0);
                animation.toValue = @(1);
                animation.duration = self.duration;
                [self.layer addAnimation:animation forKey:@"show_line"];
                
                [UIView animateWithDuration:self.duration animations:^{
                    self.alpha = 1.f;
                    self.coverView.alpha = 0.7;
                } completion:^(BOOL finished) {
                    if (self.showAnimationEnd) {
                        self.showAnimationEnd(self);
                    }
                }];
            }
            
            return ;
        }
    }
    
    if (self.options & FYAnimationOptionsElastic) {
        [UIView animateWithDuration:self.duration delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.frame = self.finishRect;
            self.alpha = 1.f;
            self.coverView.alpha = 0.7;
        } completion:^(BOOL finished) {
            if (self.showAnimationEnd) {
                self.showAnimationEnd(self);
            }
        }];
    }else {
        [UIView animateWithDuration:self.duration animations:^{
            self.frame = self.finishRect;
            self.alpha = 1.f;
            self.coverView.alpha = 0.7;
        } completion:^(BOOL finished) {
            if (self.showAnimationEnd) {
                self.showAnimationEnd(self);
            }
        }];
    }
}

- (void)hidden {
    if (self.coverView.superview) {
        [self.coverView removeFromSuperview];
    }
    
    if (self.hiddenAnimation) {
        self.hiddenAnimation(self, _originRect);
        
        return ;
    }
    
    CGFloat alpha = 1.f;
    if (self.options & FYAnimationOptionsShowFromAlpha) {
        alpha = 0.f;
    }
    
    if (self.options & FYAnimationOptionsShowFromSmall) {
        if (self.layer.cornerRadius) {
            CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            animation.fromValue = @(1);
            animation.toValue = @(0);
            animation.duration = self.duration * 0.8;
            animation.delegate = self;
            animation.removedOnCompletion = NO;
            animation.fillMode = kCAFillModeForwards;
            [self.layer addAnimation:animation forKey:@"hidden_line"];
            
            [UIView animateWithDuration:self.duration animations:^{
                self.alpha = alpha;
                self.coverView.alpha = 0.f;
            } completion:^(BOOL finished) {
                if (self.hiddenAnimationEnd) {
                    self.hiddenAnimationEnd(self);
                }
                
                [self removeFromSuperview];
            }];

            return;
        }
    }
    
    if (self.options & FYAnimationOptionsElastic) {
        [UIView animateWithDuration:self.duration * 0.8 animations:^{
            self.frame = _originRect;
            self.alpha = alpha;
            self.coverView.alpha = 0.f;
        } completion:^(BOOL finished) {
            if (self.hiddenAnimationEnd) {
                self.hiddenAnimationEnd(self);
            }
            
            [self removeFromSuperview];
        }];
    }else {
        [UIView animateWithDuration:self.duration animations:^{
            self.frame = _originRect;
            self.alpha = alpha;
            self.coverView.alpha = 0.f;
        } completion:^(BOOL finished) {
            if (self.hiddenAnimationEnd) {
                self.hiddenAnimationEnd(self);
            }
            
            [self removeFromSuperview];
        }];
    }
}

#pragma mark - 
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([self.layer animationForKey:@"hidden_line"]) {
        [self.layer removeAnimationForKey:@"hidden_line"];
        [self removeFromSuperview];
    }
}

#pragma mark - evnets
- (void)coverViewDidClick:(UITapGestureRecognizer*)tap {
    if (self.coverClick) {
        self.coverClick(self, [tap locationInView:tap.view]);
    }else {
        if (self.autoHidden) {
            [self hidden];
        }
    }
}

#pragma mark - getter
- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _coverView.backgroundColor = UICOLOR_HEX(0x000000);
        _coverView.alpha = 0;
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverViewDidClick:)];
        [_coverView addGestureRecognizer:tap];
    }
    return _coverView;
}

- (UIView *)attachView {
    if (!_attachView) {
        _attachView = [UIApplication sharedApplication].keyWindow;
    }
    return _attachView;
}

@end
