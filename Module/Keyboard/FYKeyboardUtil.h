//
//  FYKeyboardUtil.h
//  FFKit
//
//  Created by fan on 16/7/13.
//  Copyright © 2016年 fan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface KeyboardInfo : NSObject

@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, assign) CGRect originFrame;
@property (nonatomic, assign) CGRect endFrame;
@end


typedef void (^FYKeyboardAppear)(UIView* firstResponseView, KeyboardInfo* keyInfo, BOOL finish);
typedef void (^FYKeyboardDisappear)(KeyboardInfo* keyInfo, BOOL finish);

@interface FYKeyboardUtil : NSObject

@property (nonatomic, strong, readonly) NSMutableArray* keyboardAttachViewList;

/**
 *  是否由 FYKeyboardUtil 自动管理键盘，默认为YES
 */
@property (nonatomic) BOOL shouldAutoManager;

/**
 *  键盘出现后，点击其他位置是否隐藏键盘，默认是YES
 */
@property (nonatomic) BOOL shouldHiddenKeyboardWhildClick;

/**
 *  是否在编辑时根据输入框高度实时改变视图位置,默认为YES
 */
@property (nonatomic) BOOL shouldChangeWhileEditing;

/**
 *  键盘出现后的默认背景视图，可以通过这个属性改变键盘出现后背景的透明度（shouldHiddenKeyboardWhildClick 为YES时，有效）
 */
@property (nonatomic, strong) UIView* backgroundView;

/**
 *  键盘出现时，第一响应者距离键盘的偏移量，默认是 5
 */
@property (nonatomic) CGFloat offset;

/**
 *  键盘显示在attachView下方，默认为自身
 */
@property (nonatomic, weak) UIView* attachView;

/**
 *  单例类
 */
+ (instancetype)sharedKeyboardUtil;

/**
 *  键盘出现回调
 *
 *  @param keyboardAppearBlock 键盘出现调用的block，如果设置则FYKeyboardUtil 不在管理键盘事件，在vc退出时，将这个属性清空
 */
- (void)setAppearBlockWhenKeyboardAppear:(FYKeyboardAppear)keyboardAppearBlock;

/**
 *  键盘隐藏回调
 *
 *  @param keyboardDisappearBlock 键盘出现调用的block, 如果设置则FYKeyboardUtil 不在管理键盘事件，在vc退出时，将这个属性清空
 */
- (void)setDisappearBlockWhenKeyboardDisappear:(FYKeyboardDisappear)keyboardDisappearBlock;

@end
