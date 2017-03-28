//
//  FYTabBarController.h
//  TaskManager
//
//  Created by fan on 16/8/29.
//  Copyright © 2016年 fan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYTabBar.h"

@class FYTabBarController;
@protocol FYTabBarControllerDelegate <NSObject>
@optional
- (void)tabBarCenterViewDidTouched:(FYTabBarController*)tabBarController;

@end

@interface FYTabBarController : UITabBarController {
    
}
@property (nonatomic, strong, readonly) FYTabBar* tabBarView;
/**
 *  是否显示中心视图
 */
@property (nonatomic) BOOL shouldShowCenterAddView;
@property (nonatomic) BOOL shouldShowTopSeparation;

@property (nonatomic) id<FYTabBarControllerDelegate> tabBarDelegate;
@property (nonatomic, strong) UIView* centerView;

- (void)setTabbarHidden:(BOOL)hidden animated:(BOOL)animated;
@end
