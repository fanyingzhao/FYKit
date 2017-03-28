//
//  FYFooterRefreshView.m
//  FYTableView
//
//  Created by fan on 16/8/1.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "FYFooterRefreshView.h"
#import "FYMacro.h"

@implementation FYFooterRefreshView

- (instancetype)initWithFrame:(CGRect)frame tableView:(UITableView *)tableView {
    if (self = [super initWithFrame:frame tableView:tableView]) {
        self.pullLimit = 40.f;
    }
    return self;
}

#pragma mark - init


#pragma mark - funcs
- (void)updateFrame {
    self.frame = ({
        CGRect rect;
        rect.size.width = CGRectGetWidth(self.tableView.bounds);
        rect.size.height = CGRectGetHeight(self.bounds);
        rect.origin.x = 0;
        rect.origin.y = self.tableView.contentSize.height;
        rect;
    });
}

#pragma mark - setter
- (void)setPullLimit:(CGFloat)pullLimit {
    pullLimit = pullLimit < 0 || pullLimit > 200 ? 40 : pullLimit;
    [super setPullLimit:pullLimit];
}


@end



@implementation FYTextFooterRefreshView
- (instancetype)initWithFrame:(CGRect)frame tableView:(UITableView *)tableView {
    if (self = [super initWithFrame:frame tableView:tableView]) {
        [self setUp];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.frame = ({
        CGRect rect;
        rect.size.width = CGRectGetWidth(self.tableView.bounds);
        rect.size.height = CGRectGetHeight(self.bounds);
        rect.origin.x = 0;
        rect.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(rect)) / 2;
        rect;
    });
}

#pragma mark - init
- (void)setUp {
    [self addSubview:self.titleLabel];
}

#pragma mark - setter
- (void)setNoMore:(BOOL)noMore {
    self.noMore = noMore;
    if (noMore) self.titleLabel.text = self.noMoreMsg;
    else [self setRefreshState:UITableViewRefreshStatePulling];
}

- (void)setRefreshState:(UITableViewRefreshState)refreshState {
    [super setRefreshState:refreshState];
    
    switch (refreshState) {
        case UITableViewRefreshStatePulling: {
            [self updateTitleLabelState:self.pullMsg];
        }
            break;
        case UITableViewRefreshStateRefreshing: {
            [self updateTitleLabelState:self.refreshMsg];
        }
            break;
        case UITableViewRefreshStateStop: {
            [self updateTitleLabelState:self.pullMsg];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - tools
- (void)updateTitleLabelState:(NSString*)msg {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.titleLabel.text = msg;
    });
}

#pragma mark - getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.text = @"松开手加载更多数据";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (NSString *)noMoreMsg {
    if (!_noMoreMsg) {
        _noMoreMsg = @"没有更多数据";
    }
    return _noMoreMsg;
}

- (NSString *)pullMsg {
    if (!_pullMsg) {
        _pullMsg = @"向上拖拽加载更多";
    }
    return _pullMsg;
}

- (NSString *)refreshMsg {
    if (!_refreshMsg) {
        _refreshMsg = @"松手加载更多";
    }
    return _refreshMsg;
}
@end


@implementation FYGifFooterRefreshView


@end