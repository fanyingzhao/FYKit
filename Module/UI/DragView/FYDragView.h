//
//  FYDragView.h
//  BeautyPupil
//
//  Created by fan on 16/9/30.
//  Copyright © 2016年 fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FYDragView;
@protocol FYDragViewDelegate <NSObject>
@optional
- (BOOL)dragViewDidStartDrig:(FYDragView*)dragView;
- (BOOL)dragView:(FYDragView*)dragView canMove:(CGRect)frame;
- (BOOL)dragViewDidEndDrag:(FYDragView*)dragView;

@end

@interface FYDragView : UIView<NSMutableCopying> {
    
}

/**
 *  拖动view的运动区域（相对于屏幕）,默认是屏幕范围
 */
@property (nonatomic, assign) CGRect restrictRect;

/**
 *  能否被拖动
 */
@property (nonatomic) BOOL shouldDrag;

/**
 *  在开始移动时是否复制一个，默认为NO
 */
@property (nonatomic) BOOL shouldCopyWhileDragStart;

/**
 *  如果 shouldCopyWhileDragStart 为YES，则移动的是复制的view，否则为自身
 */
@property (nonatomic, strong) FYDragView* dragView;

/**
 *  代理
 */
@property (nonatomic, weak) id<FYDragViewDelegate> delegate;

/**
 *  是否可以继续分裂出子视图
 */
@property (nonatomic) BOOL shouldSplit;


/**
 *  开始拖拽
 */
- (void)startDrag;

/**
 *  移动过程
 *
 *  @param currentPoint  当前点
 *  @param proviousPoint 以后点
 */
- (void)dragProgress:(CGPoint)currentPoint previousPoint:(CGPoint)proviousPoint;

/**
 *  拖拽结束
 */
- (void)dragEnd;

@end
