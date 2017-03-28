//
//  UIView+FYAdd.m
//  FFKit
//
//  Created by fan on 16/6/29.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "UIView+FYAdd.h"

@implementation UIView (FYAdd)


- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top {
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.bounds.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - self.bounds.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.bounds.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - self.bounds.size.height;
    self.frame = frame;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)width {
    return self.bounds.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.bounds.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    CGRect frame = self.frame;
    frame.origin.x = centerX - self.bounds.size.width / 2;
    self.frame = frame;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    CGRect frame = self.frame;
    frame.origin.y = centerY - self.bounds.size.height / 2;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.bounds;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.bounds.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)fy_sizeToFit:(NSInteger)option {
    switch (option) {
        case 0: {
            [self sizeToFit];
        }
            break;
        case 1: {
            CGFloat midY = CGRectGetMidY(self.frame);
            CGFloat width = self.width;
            [self sizeToFit];
            self.frame = ({
                CGRect rect;
                rect.size.width = width;
                rect.size.height = self.height;
                rect.origin.x = self.left;
                rect.origin.y = midY - CGRectGetHeight(rect) / 2;
                rect;
            });
        }
            break;
        case 2: {
            CGFloat midY = CGRectGetMidY(self.frame);
            CGFloat midX = CGRectGetMidX(self.frame);
            [self sizeToFit];
            self.frame = ({
                CGRect rect;
                rect.size = self.size;
                rect.origin.x = midX - CGRectGetWidth(rect) / 2;
                rect.origin.y = midY - CGRectGetHeight(rect) / 2;
                rect;
            });
        }
            break;
        case 3 : {
            NSString* str = ((UIButton*)self).titleLabel.text;
            CGSize size = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) font:((UIButton*)self).titleLabel.font];
            CGFloat midY = CGRectGetMidY(self.frame);
            CGFloat midX = CGRectGetMidX(self.frame);
            self.frame = ({
                CGRect rect;
                rect.size = size;
                rect.origin.x = midX - CGRectGetWidth(rect) / 2;
                rect.origin.y = midY - CGRectGetHeight(rect) / 2;
                rect;
            });
        }
            break;
        case 4 : {
            CGFloat midY = CGRectGetMidY(self.frame);
            CGFloat height = self.height;
            [self sizeToFit];
            self.frame = ({
                CGRect rect;
                rect.size.width = self.width;
                rect.size.height = height;
                rect.origin.x = self.left;
                rect.origin.y = midY - CGRectGetHeight(rect) / 2;
                rect;
            });
        }
            break;
            
        default:
            break;
    }
}

- (CGRect)convertRectToScreen {
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    return [self convertRect:self.bounds toView:window];
}

- (UIView*)duplicateView {
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:self];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}

- (UIWindow *)fy_getKeyWindow {
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    return window;
}

- (void)snap:(void (^)(UIImage *))complete {
    UIView* bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor = [UIColor whiteColor];
    [[self fy_getKeyWindow] addSubview:bgView];
    [UIView animateWithDuration:0.4 animations:^{
        bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [bgView removeFromSuperview];
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0);
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        complete(image);
    }];
}

@end
