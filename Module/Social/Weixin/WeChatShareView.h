//
//  WeChatShareView.h
//  FFKit
//
//  Created by fan on 16/7/28.
//  Copyright © 2016年 fan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeChatManager.h"

@interface WeChatShareView : UIView
/**
 *  分享界面显示时动画
 */
@property (nonatomic, copy) void(^showAnimation)();
/**
 *  分享界面隐藏时动画
 */
@property (nonatomic, copy) void(^hiddenAnimation)();
/**
 *  底部的view
 */
@property (nonatomic, strong, readonly) UIView* containView;
/**
 *  分享按钮点击响应
 */
@property (nonatomic, copy) void(^btnClick)(ShareType type);


@end
