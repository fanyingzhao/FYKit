//
//  FYLongPressDragView.m
//  BeautyPupil
//
//  Created by fan on 16/10/8.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "FYLongPressDragView.h"

@interface FYLongPressDragView () {
    
}
@property (assign) CGPoint previousPoint;

@end

@implementation FYLongPressDragView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.shouldDrag = YES;
        self.restrictRect = [UIScreen mainScreen].bounds;

        self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressUpdate:)];
        [self addGestureRecognizer:self.longPressGestureRecognizer];
    }
    return self;
}

#pragma mark - events
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

#pragma mark - gestureRecognizer
- (void)longPressUpdate:(UILongPressGestureRecognizer*)longPressGestureRecognizer {
    if (!self.shouldDrag) {
        return ;
    }
    
    CGPoint currentPoint = [longPressGestureRecognizer locationInView:longPressGestureRecognizer.view];
    CGRect rect = [self convertRectToScreen];
    
    switch (longPressGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            self.previousPoint = currentPoint;

            if (self.dragDelegate && [self.dragDelegate respondsToSelector:@selector(dragViewDidStarted:)]) {
                [self.dragDelegate dragViewDidStarted:self];
            }
        }
            break;
        case UIGestureRecognizerStateChanged: {
            CGFloat offsetX = currentPoint.x - self.previousPoint.x;
            CGFloat offsetY = currentPoint.y - self.previousPoint.y;
            
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
            
            if (self.dragDelegate && [self.dragDelegate respondsToSelector:@selector(dragViewDidDraged:)]) {
                [self.dragDelegate dragViewDidDraged:self];
            }
            
            self.frame = finishRect;
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateEnded: {
            if (self.dragDelegate && [self.dragDelegate respondsToSelector:@selector(dragViewDidEnd:)]) {
                [self.dragDelegate dragViewDidEnd:self];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - overwrite
- (id)mutableCopyWithZone:(NSZone *)zone {
    FYLongPressDragView* view = [[FYLongPressDragView alloc] initWithFrame:self.frame];
    view.backgroundColor = self.backgroundColor;
    view.restrictRect = _restrictRect;
    view.shouldDrag = _shouldDrag;
    view.dragDelegate = _dragDelegate;
    view.alpha = self.alpha;
    
    return view;
}

@end
