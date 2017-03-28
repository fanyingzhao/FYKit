//
//  WeChatManager.m
//  FFKit
//
//  Created by fan on 16/7/28.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "WeChatManager.h"
#import <AFNetworking.h>
#import "WeChatShareView.h"

@implementation OAuthEntity
@end

static NSString *kWechatAccessTokenApi = @"https://api.weixin.qq.com/sns/oauth2/access_token";
static NSString *kWechatUserInfoApi = @"https://api.weixin.qq.com/sns/userinfo";

NSString * const kWechatManagerErrorDomain = @"kWechatManagerErrorDomain";

@interface WeChatManager ()
@property (nonatomic, strong) OAuthEntity *oauthEntity;
@end

@implementation WeChatManager
static WeChatManager* weChatManager = nil;
+ (instancetype)sharedWechatManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        weChatManager = [WeChatManager new];
    });
    return weChatManager;
}

#pragma mark - funcs
+ (BOOL)registerApp:(NSString *)appid {
    return [WXApi registerApp:appid];
}

+ (BOOL)handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:weChatManager];
}

- (void)sendAutoRequest {
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo,snsapi_message,snsapi_firend,snsapi_contact";
    req.state = [[NSBundle mainBundle] bundleIdentifier]?[[NSBundle mainBundle] bundleIdentifier]:@"xxx";
    [WXApi sendReq:req];
}

- (void)showShareView {
    [self.attachView addSubview:self.shareView];
}

- (void)hiddenShareView {
    [self.shareView removeFromSuperview];
}

- (void)shareToWX:(WeChatShareData *)data type:(ShareType)type {
    NSError* error = nil;
#ifdef DEBUG
    [WXApi sendReq:[self translateFormWechatShareData:data type:type error:&error paramCheck:YES]];
#else
    [WXApi sendReq:[self translateFormWechatShareData:data type:type error:&error paramCheck:NO]];
#endif
}

#pragma mark - tools
- (void)oauthFailure:(NSString*)errorMsg {
    if ([self.delegate respondsToSelector:@selector(weChatOauthFailed:)]) {
        [self.delegate weChatOauthFailed:errorMsg];
    }
}

- (SendMessageToWXReq*)translateFormWechatShareData:(WeChatShareData*)data type:(ShareType)type error:(NSError**)error paramCheck:(BOOL)paramCheck {
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    WXMediaMessage* message = [WXMediaMessage message];

    if (type == ShareTypeSession) {
        req.scene = WXSceneSession;
    }else if (type == ShareTypeTimeline) {
        req.scene = WXSceneTimeline;
    }else if (type == ShareTypeFavorite) {
        req.scene = WXSceneFavorite;
    }

    if ([data isKindOfClass:[WeChatShareDataText class]]) {
        NSString* text = ((WeChatShareDataText*)data).text;
        if (paramCheck) {
            if (!text && [text isEqualToString:@""]) {
                *error = [NSError errorWithDomain:kWechatManagerErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey:@"文字分享内容不能为空"}];
                return nil;
            }
        }
        req.text = ((WeChatShareDataText*)data).text;
        req.bText = YES;
        return req;
    }else if ([data isKindOfClass:[WeChatShareDataImage class]]){
#warning 图片是否压缩
        [message setThumbImage:((WeChatShareDataImage*)data).thumbImage];
        WXImageObject* imageObject = [WXImageObject object];
        imageObject.imageData = nil;
        message.mediaObject = imageObject;
    }else if ([data isKindOfClass:[WeChatShareDataMusic class]]){
        WeChatShareDataMusic* tempData = (WeChatShareDataMusic*)data;
        message.title = tempData.title;
        message.description = tempData.desc;
        [message setThumbImage:tempData.thubmImage];
        WXMusicObject* ext = [WXMusicObject object];
        ext.musicUrl = tempData.url;
        ext.musicLowBandUrl = tempData.lowBandUrl;
        ext.musicDataUrl = tempData.dataUrl;
        ext.musicLowBandDataUrl = tempData.dataLowBandUrl;
        message.mediaObject = ext;
    }else if ([data isKindOfClass:[WeChatShareDataVideo class]]){
        WeChatShareDataVideo* tempData = (WeChatShareDataVideo*)data;
        message.title = tempData.title;
        message.description = tempData.desc;
        [message setThumbImage:tempData.thubmImage];
        WXVideoObject* videoObject = [WXVideoObject object];
        videoObject.videoUrl = tempData.url;
        videoObject.videoLowBandUrl = tempData.lowBandUrl;
    }else if ([data isKindOfClass:[WeChatShareDataWeb class]]){
        WeChatShareDataWeb* tempData = (WeChatShareDataWeb*)data;
        message.title = tempData.title;
        message.description = tempData.desc;
        [message setThumbImage:tempData.thubmImage];
        WXWebpageObject* webpageObject = [WXWebpageObject object];
        webpageObject.webpageUrl = tempData.url;
        message.mediaObject = webpageObject;
    }
    
    req.bText = NO;
    req.message = message;
    return req;
}


- (BOOL)checkUrlIsLegitimate:(NSString*)url {
    NSData* data = [url dataUsingEncoding:NSUTF8StringEncoding];
    if (data.length > 1024 * 10) {
        return NO;
    }
    return YES;
}

- (BOOL)checkImageIsLegitimate:(UIImage*)image {
    return NO;
}

- (void)compressImageWithTargetSize:(NSUInteger)targetSize image:(UIImage*)image complete:(void (^)(NSData* data, CGFloat compression))complete {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGFloat compression = 1.f;
        CGFloat changeRate = 0.02;
        NSData *imageDat = UIImageJPEGRepresentation(image, compression);
        
        while ([imageDat length] < targetSize && compression > 0) {
            compression -= changeRate;
            imageDat = UIImageJPEGRepresentation(image, compression);
        }
        
        if (complete) {
            complete(imageDat, compression);
        }
    });
}

#pragma mark - private
- (void)requestWXAccessToken:(SendAuthResp*)resp {
    if(WXSuccess == resp.errCode){
        NSString *getTokenUrl = [NSString stringWithFormat:@"%@?appid=%@&secret=%@&code=%@&grant_type=authorization_code", kWechatAccessTokenApi, @"wx3f08c8badca0c389", @"a67ef60bf798cc9f0c182255831d4ac2", resp.code];
        AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/plain",nil];
        [manager GET:getTokenUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if(responseObject[@"errcode"]){
                [self oauthFailure:responseObject[@"errmsg"]];
            }else {
                self.oauthEntity.openID = responseObject[@"openid"];
                self.oauthEntity.accessToken = responseObject[@"access_token"];
                self.oauthEntity.expiresIn = responseObject[@"expires_in"];
                self.oauthEntity.refreshToken = responseObject[@"refresh_token"];
                self.oauthEntity.scope = responseObject[@"scope"];
                
                // 请求用户信息
                [self requestWXUserInfo];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self oauthFailure:@"网络错误"];
        }];

    }else if(WXErrCodeAuthDeny == resp.errCode){
        // 授权失败(用户拒绝授权)
        [self oauthFailure:@"授权失败"];
    }
    else if(WXErrCodeUserCancel == resp.errCode){
        // 用户取消
        [self oauthFailure:@"授权失败"];
    }
}

- (void)requestWXUserInfo {
    NSString *getUserInfoUrl = [NSString stringWithFormat:@"%@?access_token=%@&openid=%@", kWechatUserInfoApi, self.oauthEntity.accessToken, self.oauthEntity.openID];
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/plain",nil];
    [manager GET:getUserInfoUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(responseObject[@"errcode"]){
            [self oauthFailure:responseObject[@"errmsg"]];
        }else {
            self.oauthEntity.sex = responseObject[@"sex"];
            self.oauthEntity.nickname = responseObject[@"nickname"];
            self.oauthEntity.headImgUrl = responseObject[@"headimgurl"];
            self.oauthEntity.province = responseObject[@"province"];
            self.oauthEntity.country = responseObject[@"country"];
            self.oauthEntity.unionid = responseObject[@"unionid"];
            self.oauthEntity.city = responseObject[@"city"];
            
            if ([self.delegate respondsToSelector:@selector(weChatOauthSuccess)]) {
                [self.delegate weChatOauthSuccess];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self oauthFailure:@"网络错误"];
    }];
}

#pragma mark - WXApiDelegate
/**
 *  onReq是微信终端向第三方程序发起请求，
 *  要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。
 *  在调用sendRsp返回时，会切回到微信终端程序界面。
 *
 */
- (void)onReq:(BaseReq *)req {
    
}

/**
 *  如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面。
 *
 */
- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[SendAuthResp class]]){
        
        [self requestWXAccessToken:(SendAuthResp *)resp];
    }
    else if([resp isKindOfClass:[SendMessageToWXResp class]]){
        if (resp.errCode == 0) {
            if(self.delegate && [self.delegate respondsToSelector:@selector(weChatShareSuccess)]){
                [self.delegate weChatShareSuccess];
            }
        }
        else {
            if(self.delegate && [self.delegate respondsToSelector:@selector(weChatShareFailed:)]){
                [self.delegate weChatShareFailed:resp.errStr];
            }
        }
    }
}

#pragma mark - setter
- (void)setBtnClick:(void (^)(ShareType))btnClick {
    ((WeChatShareView*)self.shareView).btnClick = btnClick;
}

#pragma mark - getter
- (OAuthEntity *)oauthEntity {
    if (!_oauthEntity) {
        _oauthEntity = [OAuthEntity new];
    }
    return _oauthEntity;
}

- (UIView *)attachView {
    if (!_attachView) {
        _attachView = [[UIApplication sharedApplication] keyWindow];
    }
    return _attachView;
}

- (UIView *)shareView {
    if (!_shareView) {
        _shareView = [[WeChatShareView alloc] initWithFrame:self.attachView.bounds];
    }
    return _shareView;
}

- (void (^)(ShareType))btnClick {
    return ((WeChatShareView*)self.attachView).btnClick;
}
@end
