//
//  FYAnimationShowView.h
//  MyPlane
//
//  Created by fan on 16/8/18.
//  Copyright © 2016年 fan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, FYAnimationOptions) {
    FYAnimationOptionsShowFromLeft              = 1 << 0,
    FYAnimationOptionsShowFromRight             = 1 << 1,
    FYAnimationOptionsShowFromTop               = 1 << 2,
    FYAnimationOptionsShowFromBottom            = 1 << 3,
    FYAnimationOptionsShowFromAlpha             = 1 << 4,
    FYAnimationOptionsShowFromSmall             = 1 << 5,
    
    FYAnimationOptionsElastic                   = 1 << 16,
    FYAnimationOptionsLinear                    = 1 << 17,
};

@class FYAnimationShowView;
typedef void (^ShowAnimation)(FYAnimationShowView* animationView, CGRect finishRect);
typedef void (^HiddenAnimation)(FYAnimationShowView* animationView, CGRect originRect);
typedef void (^AnimationEnd)(FYAnimationShowView* animationView);
typedef void (^CoverViewDidClick)(FYAnimationShowView* animationView, CGPoint screenPoint);

@interface FYAnimationShowView : UIView
/**
 *  动画参数设置
 */
@property (nonatomic) FYAnimationOptions options;
/**
 *  显示动画
 */
@property (nonatomic, copy) ShowAnimation showAnimation;
/**
 *  隐藏动画
 */
@property (nonatomic, copy) HiddenAnimation hiddenAnimation;

/**
 *  显示动画结束回调
 */
@property (nonatomic, copy) AnimationEnd showAnimationEnd;

/**
 *  隐藏动画结束回调
 */
@property (nonatomic, copy) AnimationEnd hiddenAnimationEnd;

/**
 *  遮罩层被点击
 */
@property (nonatomic, copy) CoverViewDidClick coverClick;

/**
 *  是否点击了coverview层后自动消失，默认是yes
 */
@property (nonatomic) BOOL autoHidden;

/**
 *  动画时长
 */
@property (nonatomic) CGFloat duration;
/**
 *  是否遮盖后层视图，默认是YES
 */
@property (nonatomic) BOOL shouldCover;
/**
 *  遮盖层view
 */
@property (nonatomic, strong) UIView* coverView;
/**
 *  添加到哪个view上，默认是keywindow
 */
@property (nonatomic, weak) UIView* attachView;

@property (nonatomic) CGRect originRect;
@property (nonatomic) CGRect finishRect;



- (void)show;
- (void)hidden;

@end
