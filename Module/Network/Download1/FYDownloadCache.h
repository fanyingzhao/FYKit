//
//  FYDownloadCache.h
//  FFKit
//
//  Created by fan on 17/2/8.
//  Copyright © 2017年 fan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^FYDownloaderNoParamsBlock)();
typedef void(^FYDownloaderCheckCacheCompletionBlock)(BOOL isInCache);
typedef void(^FYDownloaderCalculateSizeBlock)(NSUInteger fileCount, NSUInteger totalSize);

@interface FYDownloadCache : NSObject

@property (nonatomic) NSInteger maxCacheAge;

@property (assign, nonatomic) NSUInteger maxCacheSize;

+ (instancetype)sharedCache;

/**
 查询某个缓存是否存在

 @param key 缓存url
 */
- (BOOL)queryDiskCacheForKey:(NSString*)key;

/**
 移除某个缓存

 @param key 缓存url
 */
- (void)removeForKey:(NSString*)key;

/**
 * Clear all disk cached images
 * @see clearDiskOnCompletion:
 */
- (void)clearDisk;

/**
 * Clear all disk cached images. Non-blocking method - returns immediately.
 * @param completion    An block that should be executed after cache expiration completes (optional)
 */
- (void)clearDiskOnCompletion:(FYDownloaderNoParamsBlock)completion;

/**
 * Remove all expired cached image from disk. Non-blocking method - returns immediately.
 * @param completionBlock An block that should be executed after cache expiration completes (optional)
 */
- (void)cleanDiskWithCompletionBlock:(FYDownloaderNoParamsBlock)completionBlock;

/**
 * Remove all expired cached image from disk
 * @see cleanDiskWithCompletionBlock:
 */
- (void)cleanDisk;

/**
 * Get the size used by the disk cache
 */
- (NSUInteger)getSize;

/**
 * Get the number of images in the disk cache
 */
- (NSUInteger)getDiskCount;

/**
 * Asynchronously calculate the disk cache's size.
 */
- (void)calculateSizeWithCompletionBlock:(FYDownloaderCalculateSizeBlock)completionBlock;


@end
