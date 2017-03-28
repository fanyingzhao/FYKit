//
//  FYCache.h
//  FFKit
//
//  Created by fan on 16/7/9.
//  Copyright © 2016年 fan. All rights reserved.
//
//  缓存类
//  缓存对象：图片，视频，字符串
//
//  方便的对缓存到磁盘的文件进行了过期管理
//
//

#import <Foundation/Foundation.h>

typedef void(^FYCacheQueryCompleteBlcok) ();
typedef void(^FYCacheCleanProgressBlock) ();

@interface FYCache : NSObject

/**
 *  最大缓存数量限制，默认是0，没有限制
 */
@property (nonatomic, assign) NSUInteger countLimt;
/**
 *  当前缓存的数量
 */
@property (nonatomic, assign) NSUInteger totalCount;
/**
 *  当前花费的开销
 */
@property (nonatomic, assign) NSUInteger costCount;
/**
 *  缓存的最大开销
 */
@property (nonatomic, assign) NSUInteger totalCostLimit;
/**
 *  过期时间,默认为7天（60 * 60 * 24 * 7）
 */
@property (nonatomic, assign) NSTimeInterval expiredTime;

/**
 *  根据键值查询某个对象
 *
 *  @param key 键
 *
 *  @return 查询到的对象
 */
- (id)objectForKey:(NSString*)key;

/**
 *  查询某个对象，对象类型，图片，视频
 *
 *  @param key           键
 *  @param completeBlock 完成回调
 *
 *  @return 键值对象的对象
 */
- (id)objectForKey:(NSString *)key complete:(FYCacheQueryCompleteBlcok)completeBlock;

- (void)setObject:(NSObject*)object forKey:(NSString*)key;
- (void)setObject:(NSObject*)object forKey:(NSString*)key cost:(NSUInteger)cost;

- (void)removeObjectForKey:(NSString*)key;

- (void)removeAllObjects;

- (void)clean;

- (void)trimToCost;

- (NSString*)cachePathForKey:(NSString*)key;
@end
