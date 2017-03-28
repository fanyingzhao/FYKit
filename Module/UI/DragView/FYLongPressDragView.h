//
//  FYLongPressDragView.h
//  BeautyPupil
//
//  Created by fan on 16/10/8.
//  Copyright © 2016年 fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FYLongPressDragView;
@protocol FYLongPressDragViewDelegate <NSObject>
@optional
- (void)dragViewDidStarted:(FYLongPressDragView*)dragView;
- (void)dragViewDidDraged:(FYLongPressDragView*)dragView;
- (void)dragViewDidEnd:(FYLongPressDragView*)dragView;

@end

@interface FYLongPressDragView : UIView<NSMutableCopying> {
    
}
/**
 *  拖动view的运动区域（相对于屏幕）,默认是屏幕范围
 */
@property (nonatomic, assign) CGRect restrictRect;

/**
 *  长按手势
 */
@property (nonatomic, strong) UILongPressGestureRecognizer* longPressGestureRecognizer;

/**
 *  能否被拖动
 */
@property (nonatomic) BOOL shouldDrag;

/**
 *  拖动代理
 */
@property (nonatomic, weak) id<FYLongPressDragViewDelegate> dragDelegate;


@end
