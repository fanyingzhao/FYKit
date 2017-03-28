//
//  FYTabBar.h
//  TaskManager
//
//  Created by fan on 16/8/29.
//  Copyright © 2016年 fan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYBarView.h"

@interface FYTabBar : UIView {
    
}
@property (nonatomic) BOOL shouldShowCenterAddView;
@property (nonatomic) BOOL shouldShowTopSeparation;
@property (nonatomic, strong) NSArray* viewControllers;
@property (nonatomic, strong) UIView* centerView;
@property (nonatomic, weak) id<FYBarViewDelegate> delegate;

@end
