//
//  FYDownloader.h
//  FFKit
//
//  Created by fan on 17/2/8.
//  Copyright © 2017年 fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FYDownloaderOperation;
typedef NS_OPTIONS(NSInteger, FYDownloaderOptions) {
    FYDownloaderOptionsa
};

typedef void (^FYDownloaderOperationProgressBlock)(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite);
typedef void (^FYDownloaderCompletedBlock)(NSError* error);
typedef void (^FYDownloaderCancelledBlock)();
typedef void (^FYDownloaderFinishedBlock)();
typedef void (^FYDownloaderProgressedBlock)();


@interface FYDownloader : NSObject

/**
 同时下载的最大并发数
 */
@property (nonatomic) NSInteger maxConcurrentDownloads;

/**
 当前正在下载的任务个数
 */
@property (nonatomic, readonly) NSInteger currentDownloadCount;

/**
 下载超时时间
 */
@property (nonatomic) NSTimeInterval downloadTimeout;

/**
 是否允许蜂窝网络
 */
@property (nonatomic) BOOL allowsCellularAccess;

/**
 全部完成下载回调
 */
@property (nonatomic, copy) FYDownloaderFinishedBlock finishedBlock;

/**
 每次任务完成回调
 */
@property (nonatomic, copy) FYDownloaderProgressedBlock progressBlock;

+ (instancetype)sharedDownloader;

- (FYDownloaderOperation* )downloadTaskWithURL:(NSURL *)url
                    options:(FYDownloaderOptions)options
                   progress:(FYDownloaderOperationProgressBlock)progressedBlock
                   complete:(FYDownloaderCompletedBlock)completedBlock
                     cancel:(FYDownloaderCancelledBlock)cancelledBlock;

- (void)setSuspended:(BOOL)suspended;

- (void)cancelAllDownloads;

@end
