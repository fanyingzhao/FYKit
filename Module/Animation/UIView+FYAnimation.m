//
//  UIView+FYAnimation.m
//  StartAnimation
//
//  Created by fan on 16/10/20.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "UIView+FYAnimation.h"

@implementation UIView (FYAnimation)

#pragma mark - funcs
- (void)fadeIn:(NSTimeInterval)duration complete:(FYAnimationComplete)complete {
    [self fadeTo:duration alpha:0 complete:complete];
}

- (void)fadeOut:(NSTimeInterval)duration complete:(FYAnimationComplete)complete {
    [self fadeTo:duration alpha:1 complete:complete];
}

- (void)fadeTo:(NSTimeInterval)duration alpha:(CGFloat)alpha complete:(FYAnimationComplete)complete {
    if (duration == 0) {
        duration = 0.4;
    }
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alpha = alpha;
    } completion:^(BOOL finished) {
        complete(self, finished);
    }];
}

- (void)fadeToggle:(NSTimeInterval)duration complete:(FYAnimationComplete)complete {
    if (self.alpha == 0) {
        [self fadeOut:duration complete:complete];
    }else if (self.alpha == 1) {
        [self fadeIn:duration complete:complete];
    }
}


@end
