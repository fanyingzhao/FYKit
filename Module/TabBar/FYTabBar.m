//
//  FYTabBar.m
//  TaskManager
//
//  Created by fan on 16/8/29.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "FYTabBar.h"
#import "FYMacro.h"

#define myImageViewWidth 25
#define myImageViewHeight 25
@interface FYTabBar () {
    
}
@property (nonatomic, strong) UIView* lineView;

@end

@implementation FYTabBar

- (instancetype)init {
    if (self = [super initWithFrame:({
        CGRect rect;
        rect.size.width = UIDEVICE_SCREEN_WIDTH;
        rect.size.height = 49;
        rect.origin.x = 0;
        rect.origin.y = UIDEVICE_SCREEN_HEIGHT - rect.size.height;
        rect;
    })]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:({
        CGRect rect;
        rect.size.width = UIDEVICE_SCREEN_WIDTH;
        rect.size.height = 49;
        rect.origin.x = 0;
        rect.origin.y = UIDEVICE_SCREEN_HEIGHT - rect.size.height;
        rect;
    })]) {
        [self setUp];
    }
    return self;
}

#pragma mark - init
- (void)setUp {
    self.backgroundColor = [UIColor whiteColor];
    
    self.shouldShowTopSeparation = YES;
}

#pragma mark - tools
- (void)setUI {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.centerView = nil;
    
    CGFloat itemWidth = self.shouldShowCenterAddView ? CGRectGetWidth(self.bounds) / (_viewControllers.count + 1) : CGRectGetWidth(self.bounds) / _viewControllers.count;
    [_viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FYBarView* barView = [[FYBarView alloc] initWithFrame: ({
            CGRect rect;
            if (self.shouldShowCenterAddView)
                rect.origin.x = idx > (_viewControllers.count - 1) / 2 ? (idx + 1) * itemWidth : idx * itemWidth;
            else
                rect.origin.x = idx * itemWidth;
            rect.origin.y = 0;
            rect.size.width = itemWidth;
            rect.size.height = CGRectGetHeight(self.bounds);
            rect;
        }) title:obj.tabBarItem.title image:obj.tabBarItem.image selectedImage:obj.tabBarItem.selectedImage];
        barView.imageView.frame = CGRectMake(0, 0, myImageViewWidth, myImageViewHeight);
        barView.delegate = self.delegate;
        barView.tag = idx + 100;
        [self addSubview:barView];
    }];
    
    [self addSubview:self.lineView];
    
    if (self.shouldShowCenterAddView) {
        self.centerView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.centerView.layer.shadowOffset = CGSizeMake(-2, 2);
        self.centerView.layer.shadowRadius = 4;
        self.centerView.layer.shadowOpacity = 0.6f;
        [self addSubview:self.centerView];
        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = self.centerView.bounds;
        [btn addTarget:self.delegate action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.centerView addSubview:btn];
    }
}

#pragma mark - overwrite
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (CGRectContainsPoint(self.centerView.frame, point)) {
        return YES;
    }else {
        return [super pointInside:point withEvent:event];
    }
}

#pragma mark - setter
- (void)setViewControllers:(NSArray *)viewControllers {
    _viewControllers = viewControllers;
    
    [self setUI];
}

#pragma mark - setter
- (void)setShouldShowCenterAddView:(BOOL)shouldShowCenterAddView {
    _shouldShowCenterAddView = shouldShowCenterAddView;
    
    [self setUI];
}

- (void)setShouldShowTopSeparation:(BOOL)shouldShowTopSeparation {
    _shouldShowTopSeparation = shouldShowTopSeparation;
    
    if (shouldShowTopSeparation) {
        self.lineView.hidden = NO;
    }else {
        self.lineView.hidden = YES;
    }
}

#pragma mark - getter
- (UIView *)centerView {
    if (!_centerView) {
        CGFloat itemWidth = self.shouldShowCenterAddView ? CGRectGetWidth(self.bounds) / (_viewControllers.count + 1) : CGRectGetWidth(self.bounds) / _viewControllers.count;
        _centerView = [[UIView alloc] initWithFrame:({
            CGRect rect;
            rect.size.width = itemWidth;
            rect.size.height = CGRectGetHeight(self.bounds);
            rect.origin.x = (CGRectGetWidth(self.bounds) - CGRectGetWidth(rect)) / 2;
            rect.origin.y = -CGRectGetHeight(rect) / 3;
            rect;
        })];
        
        UIImageView* img = [[UIImageView alloc] initWithFrame:({
            CGRect rect;
            rect.size.width = 50;
            rect.size.height = 50;
            rect.origin.x = (CGRectGetWidth(_centerView.bounds) - CGRectGetWidth(rect)) / 2;
            rect.origin.y = (CGRectGetHeight(_centerView.bounds) - CGRectGetHeight(rect)) / 2;
            rect;
        })];
        img.image = [UIImage imageNamed:@"plus"];
        [_centerView addSubview:img];
    }
    return _centerView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:({
            CGRect rect;
            rect.origin.x = 0;
            rect.origin.y = 0;
            rect.size.width = CGRectGetWidth(self.bounds);
            rect.size.height = 1;
            rect;
        })];
        _lineView.backgroundColor = UICOLOR_RGB(222, 222, 222);
        _lineView.hidden = YES;
    }
    return _lineView;
}

@end
