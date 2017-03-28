//
//  UITableView+FYRefresh.m
//  FYTableView
//
//  Created by fan on 16/8/1.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "UITableView+FYRefresh.h"
#import "NSObject+FYAdd.h"

static void* UITableViewHeaderRefreshView        = "UITableViewHeaderRefreshView";
static void* UITableViewFooterRefreshView        = "UITableViewFooterRefreshView";
static void* UITableViewRefreshStateChange       = "UITableViewRefreshStateChange";

@implementation UITableView (FYRefresh)

#pragma mark - init

#pragma mark - fucns
- (void)stopLoading:(void (^)())complete {
    [self.headerRefreshView stopLoading:complete];
    [self.footerRefreshView stopLoading:complete];
}

- (void)pullToRefresh {
    [self.headerRefreshView startLoading:^{
        
    }];
}

#pragma mark - attribute
- (FYRefreshView *)headerRefreshView {
    return [self getAssociatedValueForKey:UITableViewHeaderRefreshView];
}

- (void)setHeaderRefreshView:(FYRefreshView *)headerRefreshView {
    if (self.headerRefreshView) [self.headerRefreshView removeFromSuperview];
    [self addSubview:headerRefreshView];
    [self setAssociateValue:headerRefreshView key:UITableViewHeaderRefreshView];
}

- (FYRefreshView *)footerRefreshView {
    return [self getAssociatedValueForKey:UITableViewFooterRefreshView];
}

- (void)setFooterRefreshView:(FYRefreshView *)footerRefreshView {
    if (self.footerRefreshView) [self.footerRefreshView removeFromSuperview];
    [self addSubview:footerRefreshView];
    [self setAssociateValue:footerRefreshView key:UITableViewFooterRefreshView];
}

- (RefreshStateChange)refreshWillEndCallback {
    return [self getAssociatedValueForKey:UITableViewRefreshStateChange];
}

- (void)setRefreshWillEndCallback:(RefreshStateChange)refreshWillEndCallback {
    if (refreshWillEndCallback) {
        [self setAssociateValue:refreshWillEndCallback key:UITableViewRefreshStateChange];
    }
}


@end
