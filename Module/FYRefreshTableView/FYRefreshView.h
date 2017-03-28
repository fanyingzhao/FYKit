//
//  FYBaseRefreshView.h
//  FYTableView
//
//  Created by fan on 16/8/1.
//  Copyright © 2016年 fan. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXTERN const CGFloat kAnimationDuration;

typedef NS_ENUM(NSInteger, UITableViewRefreshState) {
    UITableViewRefreshStatePulling,
    UITableViewRefreshStateRefreshing,
    UITableViewRefreshStateStop,
};

typedef NS_ENUM(NSInteger, UITableViewRefreshType) {
    UITableViewRefreshTypeNormal,
    UITableViewRefreshTypeGif,
    UITableViewRefreshTypeCustom,
};


@interface FYRefreshView : UIView

/**
 *  当前刷新过程状态
 */
@property (nonatomic) UITableViewRefreshState refreshState;
/**
 *  当前刷新视图的类型,默认是 UITableViewRefreshTypeNormal
 */
@property (nonatomic) UITableViewRefreshType refreshType;
/**
 *  开始出现刷新视图时的下拉高度
 */
@property (nonatomic) CGFloat pullLimit;
/**
 *  刷新视图
 */
@property (nonatomic, strong) UIView* refreshView;
@property (nonatomic, readonly) UIEdgeInsets originEdge;
@property (nonatomic, weak) UITableView* tableView;

- (instancetype)initWithFrame:(CGRect)frame tableView:(UITableView*)tableView;

- (void)startLoading:(void(^)())complete;
- (void)stopLoading:(void(^)())complete;


@end
