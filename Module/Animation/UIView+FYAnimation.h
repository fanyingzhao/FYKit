//
//  UIView+FYAnimation.h
//  StartAnimation
//
//  Created by fan on 16/10/20.
//  Copyright © 2016年 fan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FYAnimationComplete) (UIView* view, BOOL finished);

@interface UIView (FYAnimation)

/**
 @param duration 时长，传入 0 则默认为 0.4
 @param complete 完成回调
 */
- (void)fadeIn:(NSTimeInterval)duration complete:(FYAnimationComplete)complete;
- (void)fadeOut:(NSTimeInterval)duration complete:(FYAnimationComplete)complete;
- (void)fadeTo:(NSTimeInterval)duration alpha:(CGFloat)alpha complete:(FYAnimationComplete)complete;
- (void)fadeToggle:(NSTimeInterval)duration complete:(FYAnimationComplete)complete;


@end
