//
//  WeChatShareData.h
//  FFKit
//
//  Created by fan on 16/7/29.
//  Copyright © 2016年 fan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WeChatShareData : NSObject
/**
 *  音乐标题
 */
@property (nonatomic, copy) NSString* title;
/**
 *  音乐描述
 */
@property (nonatomic, copy) NSString* desc;
/**
 *  缩略图，大小不能超过32K
 */
@property (nonatomic, strong) UIImage* thubmImage;
@end

@interface WeChatShareDataText : WeChatShareData
/**
 *  分享的内容
 */
@property (nonatomic, copy) NSString* text;
@end

@interface WeChatShareDataImage : WeChatShareData
/**
 *  大小不能超过10M
 */
@property (nonatomic, strong) UIImage* image;
/**
 *  缩略图
 */
@property (nonatomic, strong) UIImage* thumbImage;
@end

@interface WeChatShareDataMusic : WeChatShareData
/**
 *  音乐url，长度不能超过10K
 */
@property (nonatomic, copy) NSString* url;
/**
 *  低分辨率音乐url，长度不能超过10K
 */
@property (nonatomic, copy) NSString* lowBandUrl;
/**
 *  音乐数据url，长度不能超过10K
 */
@property (nonatomic, copy) NSString* dataUrl;
/**
 *  低分辨率音乐数据url，长度不能超过10K
 */
@property (nonatomic, copy) NSString* dataLowBandUrl;
@end

@interface WeChatShareDataVideo : WeChatShareData
/**
 *  视频url，长度不能超过10K
 */
@property (nonatomic, copy) NSString* url;
/**
 *  低分辨率视频url，长度不能超过10K
 */
@property (nonatomic, copy) NSString* lowBandUrl;
@end

@interface WeChatShareDataWeb : WeChatShareData
/**
 *  url，长度不能超过10K
 */
@property (nonatomic, copy) NSString* url;

@end