//
//  WeChatManager.h
//  FFKit
//
//  Created by fan on 16/7/28.
//  Copyright © 2016年 fan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WeChatShareData.h"

/**
 *  OAuthEntity
 */
@interface OAuthEntity : NSObject

// 接口调用凭证
@property (nonatomic, strong) NSString *accessToken;
// 授权用户唯一标识（对当前开发者帐号唯一）
@property (nonatomic, strong) NSString *openID;
// access_token接口调用凭证超时时间，单位（秒）
@property (nonatomic, strong) NSString *expiresIn;
// 用户刷新access_token
@property (nonatomic, strong) NSString *refreshToken;
// 用户授权的作用域，使用逗号（,）分隔
@property (nonatomic, strong) NSString *scope;
// 当且仅当该移动应用已获得该用户的userinfo授权时，才会出现该字段
// 用户统一标识。针对一个微信开放平台帐号下的应用，同一用户的unionid是唯一的。
@property (nonatomic, strong) NSString *unionid;
// 普通用户性别，1为男性，2为女性
@property (nonatomic, strong) NSString *sex;
// 昵称
@property (nonatomic, strong) NSString *nickname;
// 用户头像，最后一个数值代表正方形头像大小（有0、46、64、96、132数值可选，0代表640*640正方形头像），用户没有头像时该项为空
@property (nonatomic, strong) NSString *headImgUrl;
// 普通用户个人资料填写的省份
@property (nonatomic, strong) NSString *province;
// 普通用户个人资料填写的城市
@property (nonatomic, strong) NSString *city;
// 国家，如中国为CN
@property (nonatomic, strong) NSString *country;

@end

typedef NS_ENUM(NSInteger, ShareType) {
    ShareTypeSession,                   // 聊天界面
    ShareTypeTimeline,                  // 朋友圈
    ShareTypeFavorite,                  // 收藏
};

@protocol WeChatManagerDelegate <NSObject>
@optional
- (void)weChatOauthSuccess;
- (void)weChatOauthFailed:(NSString*)errorMsg;

- (void)weChatShareSuccess;
- (void)weChatShareFailed:(NSString*)errorMsg;
@end

@interface WeChatManager : NSObject<WXApiDelegate>
@property (nonatomic, strong, readonly) OAuthEntity *oauthEntity;
@property (nonatomic, weak) id<WeChatManagerDelegate> delegate;
/**
 *  分享界面
 */
@property (nonatomic, strong) UIView* shareView;
/**
 *  要显示在的view上，默认是keywindow
 */
@property (nonatomic, weak) UIView* attachView;
/**
 *  分享按钮点击响应
 */
@property (nonatomic, copy) void(^btnClick)(ShareType type);

+ (instancetype)sharedWechatManager;

+ (BOOL)registerApp:(NSString*)appid;

+ (BOOL)handleOpenURL:(NSURL*)url;

/**
 *  分享到微信
 *
 *  @param data 数据
 *  @param type 类型（微信/朋友圈/收藏）
 */
- (void)shareToWX:(WeChatShareData*)data type:(ShareType)type;

/**
 *  授权登录
 */
- (void)sendAutoRequest;

/**
 *  显示分享界面
 */
- (void)showShareView;

/**
 *  隐藏分享界面
 */
- (void)hiddenShareView;

@end
