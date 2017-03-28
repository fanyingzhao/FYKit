//
//  FYBaseRefreshView.m
//  FYTableView
//
//  Created by fan on 16/8/1.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "FYRefreshView.h"
#import "FYKitMacro.h"
#import "UITableView+FYRefresh.h"
#import "FYFooterRefreshView.h"

@interface FYRefreshView () {
}

@end

static void* RefreshViewContentOffset  = "RefreshViewContentOffset";
static void* RefreshViewEndTracking    = "RefreshViewEndTracking";
const CGFloat kAnimationDuration = 0.3f;

@implementation FYRefreshView
- (instancetype)initWithFrame:(CGRect)frame tableView:(UITableView *)tableView {
    if (self = [super initWithFrame:frame]) {
        _tableView = tableView;
        _originEdge = tableView.contentInset;
        [self addObserver];
        _refreshState = UITableViewRefreshStateStop;
    }
    return self;
}

#pragma mark - init


#pragma mark - observer
- (void)addObserver {
    [self.tableView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionNew context:RefreshViewContentOffset];
    [self.tableView.panGestureRecognizer addObserver:self forKeyPath:NSStringFromSelector(@selector(state)) options:NSKeyValueObservingOptionNew context:RefreshViewEndTracking];
}

- (void)removeObserver {
    @try {
        [self.tableView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
        [self.tableView.panGestureRecognizer removeObserver:self forKeyPath:NSStringFromSelector(@selector(state))];
    } @catch (NSException *exception) {
        FYLog(@"remove scrollview  contentoffset observer failure");
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    CGFloat offsetY = self.tableView.contentOffset.y;
    if (context == RefreshViewContentOffset) {
        if ([self isKindOfClass:[FYFooterRefreshView class]]) {
            [((FYFooterRefreshView*)self) updateFrame];
            if (self.tableView.isDragging) {
                if (offsetY - (self.tableView.contentSize.height - CGRectGetHeight(self.tableView.bounds)) >= self.pullLimit) {
                    self.refreshState = UITableViewRefreshStateRefreshing;
                }
                else {
                    self.refreshState = UITableViewRefreshStatePulling;
                }
            }
        }else {
            if (self.tableView.isDragging) {
                if (ABS(offsetY) >= ABS(self.pullLimit))  self.refreshState = UITableViewRefreshStateRefreshing;
                else self.refreshState = UITableViewRefreshStatePulling;
            }
        }
    }else if (context == RefreshViewEndTracking) {
        UIGestureRecognizerState state = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        if (state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateCancelled || state == UIGestureRecognizerStateFailed) {
            self.refreshState = UITableViewRefreshStateRefreshing;

            self.refreshState = UITableViewRefreshStateRefreshing;
            if ([self isKindOfClass:[FYFooterRefreshView class]]) {
                if (offsetY >= self.pullLimit) {
                    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, offsetY, 0);
                    
                    [UIView animateWithDuration:kAnimationDuration animations:^{
                        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, self.pullLimit, 0);
                    } completion:^(BOOL finished) {
                        // 准备消失
                        [self refreshWillEnd];
                    }];
                }
            }else {
                if (offsetY <= -self.pullLimit) {
                    self.tableView.contentInset = UIEdgeInsetsMake(-offsetY, 0, 0, 0);
                    
                    [UIView animateWithDuration:kAnimationDuration animations:^{
                        self.tableView.contentInset = UIEdgeInsetsMake(self.pullLimit, 0, 0, 0);
                    } completion:^(BOOL finished) {
                        // 准备消失
                        [self refreshWillEnd];
                    }];
                }
            }
        }
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - tools
- (void)refreshWillEnd {
    if (self.tableView.refreshWillEndCallback) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tableView.refreshWillEndCallback(self, self.refreshState);
        });
    }
    else [self stopLoading:nil];
}

#pragma mark - funcs
- (void)startLoading:(void (^)())complete {
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(self.pullLimit, 0, 0, 0);
        self.tableView.contentOffset = CGPointMake(0, -self.pullLimit);
    } completion:^(BOOL finished) {
        [self refreshWillEnd];
    }];
}

- (void)stopLoading:(void (^)())complete {
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.tableView.contentInset = _originEdge;
    } completion:^(BOOL finished) {
        self.refreshState = UITableViewRefreshStateStop;
        if (complete) {
            complete();
        }
    }];
}

#pragma mark - setter
- (void)setRefreshState:(UITableViewRefreshState)refreshState {
    if (_refreshState == refreshState) {
        return ;
    }
    _refreshState = refreshState;
}

@end
