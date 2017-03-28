//
//  FYTabBarController.m
//  TaskManager
//
//  Created by fan on 16/8/29.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "FYTabBarController.h"
#import "FYMacro.h"
#import "FYBarView.h"

@interface FYTabBarController ()<FYBarViewDelegate> {

}
@property (nonatomic, strong) FYTabBar* tabBarView;

@end

@implementation FYTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animation {
    [super viewWillAppear:animation];
}

#pragma mark - tools

#pragma mark - events
- (void)btnClick:(UIButton*)sender {
    if ([self.tabBarDelegate respondsToSelector:@selector(tabBarCenterViewDidTouched:)]) {
        [self.tabBarDelegate tabBarCenterViewDidTouched:self];
    }
}

#pragma mark - FYBarViewDelegate
- (void)barViewDidTouched:(FYBarView *)barView {
    [self setSelectedIndex:barView.tag - 100];
}

#pragma mark - funcs
- (void)setTabbarHidden:(BOOL)hidden animated:(BOOL)animated {
    CGRect frame;
    if (hidden) {
        frame = ({
            CGRect rect;
            rect.size = self.tabBarView.size;
            rect.origin.x = 0;
            if (self.tabBarView.centerView) rect.origin.y = UIDEVICE_SCREEN_HEIGHT + ABS(CGRectGetMinY(self.centerView.frame));
            else rect.origin.y = UIDEVICE_SCREEN_HEIGHT;
            rect;
        });
    }else {
        frame = ({
            CGRect rect;
            rect.size = self.tabBarView.size;
            rect.origin.x = 0;
            rect.origin.y = UIDEVICE_SCREEN_HEIGHT - CGRectGetHeight(rect);
            rect;
        });
    }
    
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self.tabBarView.frame = frame;
        } completion:^(BOOL finished) {
            
        }];
    }else {
        self.tabBarView.frame = frame;
    }
}

#pragma mark - overwrite
- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers{
    [super setViewControllers:viewControllers];
    
    [self.tabBar removeFromSuperview];
    [self.tabBarView removeFromSuperview];
    
    self.tabBarView.viewControllers = viewControllers;
    [self.view addSubview:self.tabBarView];    
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    [super setSelectedIndex:selectedIndex];
}

- (void)setShouldShowCenterAddView:(BOOL)shouldShowCenterAddView {
    self.tabBarView.shouldShowCenterAddView = shouldShowCenterAddView;
}

- (void)setCenterView:(UIView *)centerView {
    self.tabBarView.centerView = centerView;
}

- (void)setShouldShowTopSeparation:(BOOL)shouldShowTopSeparation {
    self.tabBarView.shouldShowTopSeparation = shouldShowTopSeparation;
}

#pragma mark - getter
- (FYTabBar *)tabBarView {
    if (!_tabBarView) {
        _tabBarView = [[FYTabBar alloc] init];
        _tabBarView.delegate = self;
    }
    return _tabBarView;
}

- (BOOL)shouldShowCenterAddView {
    return self.tabBarView.shouldShowCenterAddView;
}

- (UIView *)centerView {
    return self.tabBarView.centerView;
}

- (BOOL)shouldShowTopSeparation {
    return self.tabBarView.shouldShowTopSeparation;
}

@end
