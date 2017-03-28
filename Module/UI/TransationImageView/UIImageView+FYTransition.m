//
//  UIImageView+FYTransition.m
//  ImageTransition
//
//  Created by fan on 16/10/25.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "UIImageView+FYTransition.h"
#import <objc/runtime.h>

static char nextImage;
@implementation UIImageView (FYTransition)

- (UIImage *)nextImage {
    return objc_getAssociatedObject(self, &nextImage);
}

- (void)setNextImage:(UIImage *)nextImage {
    objc_setAssociatedObject(self, &nextImage, nextImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
#warning 添加动画未完成直接返回处理
    
    BOOL mask = self.layer.masksToBounds;
    
    self.layer.masksToBounds = YES;
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.image = nextImage;
    imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
    [self addSubview:imageView];
    
    // 动画转场
    NSMutableArray* viewList = [NSMutableArray array];
    NSMutableArray* imageList = [NSMutableArray array];
    for (NSInteger i = 0; i < 4; i ++) {
        UIView* view = [[UIView alloc] initWithFrame:({
            CGRect rect;
            rect.origin.x = (i + 1) % 2 ? 0 : CGRectGetWidth(self.bounds) / 2;
            rect.origin.y = i / 2 ? CGRectGetHeight(self.bounds) / 2 : 0;
            rect.size.width = CGRectGetWidth(self.bounds) / 2;
            rect.size.height = CGRectGetHeight(self.bounds) / 2;
            rect;
        })];
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.image = self.image;
        imageView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -CGRectGetMinX(view.frame), -CGRectGetMinY(view.frame));
        view.layer.masksToBounds = YES;
        [view addSubview:imageView];
        
        [viewList addObject:view];
        [imageList addObject:imageView];
    }
    
    [viewList enumerateObjectsUsingBlock:^(UIView*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addSubview:obj];
    }];


    [UIView animateWithDuration:2 animations:^{
        ((UIImageView*)imageList[0]).frame = CGRectOffset(((UIImageView*)imageList[0]).frame , 0, CGRectGetHeight(((UIView*)viewList[0]).bounds));
        ((UIImageView*)imageList[1]).frame = CGRectOffset(((UIImageView*)imageList[1]).frame , -CGRectGetWidth(((UIView*)viewList[1]).bounds), 0);
        ((UIImageView*)imageList[2]).frame = CGRectOffset(((UIImageView*)imageList[2]).frame , CGRectGetWidth(((UIView*)viewList[2]).bounds), 0);
        ((UIImageView*)imageList[3]).frame = CGRectOffset(((UIImageView*)imageList[3]).frame , 0, -CGRectGetHeight(((UIView*)viewList[3]).bounds));
        imageView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [viewList enumerateObjectsUsingBlock:^(UIImageView*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [imageView removeFromSuperview];
        self.image = nextImage;
        self.layer.masksToBounds = mask;
    }];
}


@end
