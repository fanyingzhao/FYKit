//
//  FYCacheManager.h
//  FFKit
//
//  Created by fan on 16/7/9.
//  Copyright © 2016年 fan. All rights reserved.
//
//  缓存管理类
//
//

#import "FYCache.h"

@class FYMemoryCache,FYDiskCache;
@interface FYCacheManager : FYCache

/**
 *  内存缓存对象
 */
@property (nonatomic, strong) FYMemoryCache* memoryCache;
/**
 *  磁盘缓存对象
 */
@property (nonatomic, strong) FYDiskCache* diskCache;


- (void)setObject:(NSObject*)object forKey:(NSString*)key toDisk:(BOOL)toDisk;

@end
