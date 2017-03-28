//
//  FYDiskCache.h
//  FFKit
//
//  Created by fan on 16/7/9.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "FYCache.h"
#import <UIKit/UIKit.h>

@interface FYDiskCache : FYCache

@property (nonatomic, copy) NSString* path;

+ (instancetype)sharedDiskCache;

/**
 *  设置当前的缓存路径
 */
- (void)setCachePath:(NSString*)path;

- (void)setObject:(NSObject*)object forKey:(NSString *)key complete:(FYCacheQueryCompleteBlcok)completeBlock;
- (void)setObject:(NSObject*)object forKey:(NSString *)key cost:(NSUInteger)cost complete:(FYCacheQueryCompleteBlcok)completeBlock;



/**
 *  移除某个缓存
 *
 *  @param key           键
 *  @param completeBlock 完成回调
 */
- (void)removeObjectForKey:(NSString *)key complete:(FYCacheQueryCompleteBlcok)completeBlock;

/**
 *  移除所有缓存
 *
 *  @param progressBlock 过程回调
 *  @param completeBlock 完成回调
 */
- (void)removeAllObjectsWithProgress:(FYCacheCleanProgressBlock)progressBlock complete:(FYCacheQueryCompleteBlcok)completeBlock;

/**
 *  清楚过期缓存
 *
 *  @param progressBlock 过程回调
 *  @param completeBlock 完成回调
 */
- (void)cleanWithProgress:(FYCacheCleanProgressBlock)progressBlock complete:(FYCacheQueryCompleteBlcok)completeBlock;

@end
