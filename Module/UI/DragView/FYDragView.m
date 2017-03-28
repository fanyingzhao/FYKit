//
//  FYDragView.m
//  BeautyPupil
//
//  Created by fan on 16/9/30.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "FYDragView.h"

@interface FYDragView () {
    CGRect _originRect;
}

@end

@implementation FYDragView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.shouldDrag = YES;
        self.shouldSplit = YES;
        self.restrictRect = [UIScreen mainScreen].bounds;
    }
    return self;
}

#pragma mark - events
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.shouldDrag) {
        return ;
    }
    
    [self startDrag];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.shouldDrag) {
        return ;
    }
    
    CGPoint currentPoint = [[touches anyObject] locationInView:self];
    CGPoint previousPoint = [[touches anyObject] previousLocationInView:self];
    
    CGFloat offsetX = currentPoint.x - previousPoint.x;
    CGFloat offsetY = currentPoint.y - previousPoint.y;
    
    CGRect rect = [self convertRectToScreen];
    
    CGRect finishRect = self.frame;
    if (offsetX > 0) {
        // 右边缘判断
        if (CGRectGetMaxX(rect) + offsetX <= CGRectGetMaxX(self.restrictRect)) {
            finishRect = CGRectOffset(finishRect, offsetX, 0);
        }else {
            UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
            finishRect = [window convertRect:rect toView:self.superview];
        }
    }else {
        // 左边缘判断
        if (CGRectGetMinX(rect) + offsetX >= CGRectGetMinX(self.restrictRect)) {
            finishRect = CGRectOffset(finishRect, offsetX, 0);
        }else {
            UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
            finishRect = [window convertRect:rect toView:self.superview];
        }
    }
    
    if (offsetY > 0) {
        // 下边缘判断
        if (CGRectGetMaxY(rect) + offsetY <= CGRectGetMaxY(self.restrictRect)) {
            finishRect = CGRectOffset(finishRect, 0, offsetY);
        }else {
            UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
            finishRect = [window convertRect:rect toView:self.superview];
        }
    }else {
        if (CGRectGetMinY(rect) + offsetY >= CGRectGetMinY(self.restrictRect)) {
            finishRect = CGRectOffset(finishRect, 0, offsetY);
        }else {
            UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
            finishRect = [window convertRect:rect toView:self.superview];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(dragView:canMove:)]) {
        if (![self.delegate dragView:self canMove:finishRect]) {
            return ;
        }
    }
    
    self.frame = finishRect;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.shouldDrag) {
        return ;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dragViewDidEndDrag:)]) {
        [self.delegate dragViewDidEndDrag:self];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.shouldDrag) {
        return ;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dragViewDidEndDrag:)]) {
        [self.delegate dragViewDidEndDrag:self];
    }
}

#pragma mark - funcs
- (void)startDrag {
    if (self.shouldCopyWhileDragStart) {
        if (!self.shouldSplit) {
            self.dragView = self;
        }else {
            self.dragView = [self mutableCopy];
            [self.superview insertSubview:self.dragView belowSubview:self];
            self.shouldSplit = NO;
        }
    }else {
        self.dragView = self;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dragViewDidStartDrig:)]) {
        [self.delegate dragViewDidStartDrig:self];
    }
}

- (void)dragEnd {
    [self removeDragView];
}

#pragma mark - tools
- (void)removeDragView {
    [self removeFromSuperview];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    FYDragView* view = [[FYDragView alloc] initWithFrame:self.frame];
    view.backgroundColor = self.backgroundColor;
    view.backgroundColor = [UIColor orangeColor];
    view.restrictRect = _restrictRect;
    view.shouldDrag = _shouldDrag;
    view.shouldCopyWhileDragStart = _shouldCopyWhileDragStart;
    view.delegate = _delegate;
    view.shouldSplit = _shouldSplit;
    
    return view;
}

#pragma mark - setter

@end
