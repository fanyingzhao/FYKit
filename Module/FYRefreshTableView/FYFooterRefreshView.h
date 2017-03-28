//
//  FYFooterRefreshView.h
//  FYTableView
//
//  Created by fan on 16/8/1.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "FYRefreshView.h"

@interface FYFooterRefreshView : FYRefreshView


/**
 *  是否没有更多数据
 */
@property (nonatomic, getter=isNoMore) BOOL noMore;

- (void)updateFrame;

@end


@interface FYTextFooterRefreshView : FYFooterRefreshView
/**
 *  没有更多数据时的提示信息，默认为 “没有更多数据”
 */
@property (nonatomic, copy) NSString* noMoreMsg;
/**
 *  拖拽时显示的问题，默认是“向上拖拽加载更多”
 */
@property (nonatomic, copy) NSString* pullMsg;
/**
 *  松开手可以刷新时显示的数据，默认是“松手加载更多”
 */
@property (nonatomic, copy) NSString* refreshMsg;
@property (nonatomic, strong) UILabel* titleLabel;
@end

@interface FYGifFooterRefreshView : FYFooterRefreshView

@end