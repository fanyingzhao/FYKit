//
//  FYPopView.h
//  FFKit
//
//  Created by fan on 17/3/14.
//  Copyright © 2017年 fan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FYPopAnimationOptions) {
    FYPopAnimationOptionsNone,
    FYPopAnimationOptionsDrop,
    FYPopAnimationOptionsUp,
    FYPopAnimationOptionsBigger,
};

@class FYPopView, FYPopCoverView;
typedef void (^FYPopAnimationBlock)(FYPopView* view);
typedef void (^FYPopCompletionBlock)(FYPopView* view);
typedef void (^FYPopStartBlock)(FYPopView* view);

@interface FYPopView : UIView

@property (nonatomic, copy) FYPopAnimationBlock showAnimationBlock;
@property (nonatomic, copy) FYPopAnimationBlock hideAnimationBlock;

@property (nonatomic, copy) FYPopCompletionBlock showCompletionBlock;
@property (nonatomic, copy) FYPopCompletionBlock hideCompletionBlock;

@property (nonatomic, copy) FYPopStartBlock showStartBlock;
@property (nonatomic, copy) FYPopStartBlock hideStartBlock;

@property (nonatomic, weak) UIView* coverView;

@property (nonatomic, weak) UIView* attacView;

@property (nonatomic) NSTimeInterval duration;

@property (nonatomic) FYPopAnimationOptions options;

@property (nonatomic) BOOL modal;           // 是否点击背景消失，默认为YES

@property (nonatomic) BOOL shouldUseCover;

- (void)show;
- (void)show:(FYPopCompletionBlock)completionBlock;
- (void)showWithBlock:(FYPopStartBlock)startBlock completion:(FYPopCompletionBlock)completionBlock;
- (void)showWithDuration:(NSTimeInterval)duration options:(FYPopAnimationOptions)options startBlock:(FYPopStartBlock)startBlock completion:(FYPopCompletionBlock)completionBlock;

- (void)hide;
- (void)hide:(FYPopCompletionBlock)completionBlock;
- (void)hide:(FYPopStartBlock)startBlock completion:(FYPopCompletionBlock)completionBlock;

@end
