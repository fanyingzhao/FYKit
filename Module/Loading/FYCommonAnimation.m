//
//  FYCommonAnimation.m
//  FFKit
//
//  Created by fan on 17/3/7.
//  Copyright © 2017年 fan. All rights reserved.
//

#import "FYCommonAnimation.h"

#define angle2Radian(angle)  ((angle)/180.0*M_PI)


@interface FYCommonAnimation () {
    
}
@property (nonatomic, strong) UIView* sectorView;

@end

@implementation FYCommonAnimation

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.backView addSubview:[self loadingView]];
    }
    return self;
}


#pragma mark - FYLoadingAnimationDelegate
- (UIView *)loadingView {
    if (self.manager.mode == LoadingModeCommonOne) {
        return self.sectorView;
    }else if (self.manager.mode == LoadingModeCommonTow) {
        return [self getLoadingViewTwo];
    }
    
    return nil;
}

- (void)show {
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    animation.values = @[@(angle2Radian(0)), @(angle2Radian(60)), @(angle2Radian(360))];
    animation.duration = 1;
    animation.repeatCount = 1000;
    animation.calculationMode = kCAAnimationLinear;
    [self.sectorView.layer addAnimation:animation forKey:@"sector"];
}

- (void)hideWithCompletion:(FYLoadingCompletionBlock)completionBlock {
    [self.sectorView.layer removeAllAnimations];
}

#pragma mark - one
- (UIView*)getLoadingViewOne {
    
    return nil;
}

#pragma mark - tow
- (UIView*)getLoadingViewTwo {
    return nil;
}

#pragma mark - getter
- (UIView *)sectorView {
    if (!_sectorView) {
        _sectorView = [[UIView alloc] initWithFrame:({
            CGRect rect;
            rect.size.width = 80;
            rect.size.height = 80;
            rect.origin.x = (CGRectGetWidth(self.backView.bounds) - CGRectGetWidth(rect)) / 2;
            rect.origin.y = (CGRectGetHeight(self.backView.bounds) - CGRectGetHeight(rect)) / 2;
            rect;
        })];
        
        CGPoint centerPotin = CGPointMake(CGRectGetWidth(_sectorView.frame) / 2, CGRectGetHeight(_sectorView.frame) / 2);

        CAShapeLayer* shape = [CAShapeLayer layer];
        shape.frame = _sectorView.bounds;
        
        UIBezierPath* path = [UIBezierPath bezierPath];

        UIBezierPath* circle = [UIBezierPath bezierPathWithArcCenter:centerPotin radius:CGRectGetWidth(_sectorView.frame) * 0.5 startAngle:-M_PI_2-M_PI_4 endAngle:-M_PI_2+M_PI_4 clockwise:YES];
        [circle addLineToPoint:centerPotin];
        [circle closePath];
        
        UIBezierPath* circle2 = [UIBezierPath bezierPathWithArcCenter:centerPotin radius:CGRectGetWidth(_sectorView.frame) * 0.5 startAngle:M_PI_2-M_PI_4 endAngle:M_PI_2+M_PI_4 clockwise:YES];
        [circle2 addLineToPoint:centerPotin];
        [circle2 closePath];
        
        [path appendPath:circle];
        [path appendPath:circle2];
        
        [path fill];
        shape.path = path.CGPath;
        
        shape.fillColor = UICOLOR_HEX(0x4DB6AC).CGColor;
        
        [_sectorView.layer addSublayer:shape];
    }
    return _sectorView;
}

@end
