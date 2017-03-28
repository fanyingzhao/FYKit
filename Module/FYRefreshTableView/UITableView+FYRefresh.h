//
//  UITableView+FYRefresh.h
//  FYTableView
//
//  Created by fan on 16/8/1.
//  Copyright © 2016年 fan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYRefreshView.h"

typedef void (^RefreshStateChange)(FYRefreshView* refreshView, UITableViewRefreshState state);
@interface UITableView (FYRefresh)

@property (nonatomic, strong) FYRefreshView* headerRefreshView;
@property (nonatomic, strong) FYRefreshView* footerRefreshView;
/**
 *  即将结束回调
 */
@property (nonatomic, copy) RefreshStateChange refreshWillEndCallback;


/**
 *  主动刷新
 */
- (void)pullToRefresh;

/**
 *  主动结束
 *
 *  @param complete 完成回调
 */
- (void)stopLoading:(void (^)())complete;

@end
