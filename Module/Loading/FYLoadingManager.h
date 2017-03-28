//
//  FYLoadingAnimation.h
//  FFKit
//
//  Created by fan on 17/3/7.
//  Copyright © 2017年 fan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KBackViewSize   150

@class FYLoadingAnimation;

typedef NS_ENUM(NSInteger, LoadingMode) {
    LoadingModeCommonOne,
    LoadingModeCommonTow
};

typedef NS_ENUM(NSInteger, LoadingAnimationMode) {
    LoadingAnimationModeFade,
    LoadingAnimationModeZoom,
    LoadingAnimationModeZoomOut,
    LoadingAnimationModeZoomIn
};

typedef void (^FYLoadingCompletionBlock)();


@interface FYLoadingManager : NSObject

+ (instancetype)showLoading;
+ (instancetype)showLoadingForView:(UIView*)view;
+ (instancetype)showLoadingForView:(UIView*)view mode:(LoadingMode)mode animation:(LoadingAnimationMode)animationMode;

+ (void)hideLoadingForView:(UIView*)view;
+ (void)hideLoadingForView:(UIView*)view completion:(FYLoadingCompletionBlock)completionBlock;


@property (nonatomic, weak) UIView* attachView;

@property (nonatomic, copy) FYLoadingCompletionBlock completionBlock;

@property (nonatomic) LoadingMode mode;

@property (nonatomic) LoadingAnimationMode animationMode;

@property (nonatomic, strong, readonly) FYLoadingAnimation* animation;

@property (nonatomic, strong, readonly) UIView* backView;

@property (nonatomic) UIDeviceOrientation orient;

- (instancetype)initWithView:(UIView*)attachView;

- (void)showLoading;
- (void)showLoadingModel:(LoadingMode)mode animation:(LoadingAnimationMode)animationMode;

- (void)showLoadingWithAnimation:(FYLoadingAnimation*)animation;

- (void)hideLoading;
- (void)hideLoadingCompletion:(FYLoadingCompletionBlock)completionBlock;

// 修改界面外观代理

@end
