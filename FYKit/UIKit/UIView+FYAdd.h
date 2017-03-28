//
//  UIView+FYAdd.h
//  FFKit
//
//  Created by fan on 16/6/29.
//  Copyright © 2016年 fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FYAdd)

@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;

/**
 *  根据内容自适应大小
 *
 *  @param option 
 *  0 : 默认，左上角
 *  1 : 只改变高度，高度自适应，宽度不变, 水平方向left不变，竖直方向中心位置不变
 *  2 : 宽高自适应，中心位置不变
 *  3 : 针对按钮，中心位置不变，
 *  4 : 只改变宽度，高度不变，水平方向left不变，垂直方向中心位置不变
 */
- (void)fy_sizeToFit:(NSInteger)option;

/**
 *  视图相对于屏幕的frame
 *
 *  @return frame
 */
- (CGRect)convertRectToScreen;

/**
 *  完全复制一个相同的view，有弊端，无法复制属性，一些子类无法复制
 *  重写 copyWithZone
 *
 *  @return 复制的view
 */
- (UIView*)duplicateView;

/**
 得到主window

 @return 主window
 */
- (UIWindow*)fy_getKeyWindow;

/**
 屏幕截图快照
 */
- (void)snap:(void (^)(UIImage* image))complete;

@end
