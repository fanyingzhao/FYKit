//
//  FYDownloadManager.m
//  FFKit
//
//  Created by fan on 17/2/8.
//  Copyright © 2017年 fan. All rights reserved.
//

#import "FYDownloadManager.h"

@implementation FYDownloadManager

#pragma mark - init
- (instancetype)init {
    return [self initWithCache:nil downloader:[FYDownloader sharedDownloader]];
}

#pragma mark - funcs
+ (instancetype)sharedManager {
    static FYDownloadManager* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FYDownloadManager alloc] init];
    });
    return instance;
}

- (instancetype)initWithCache:(FYDownloadCache *)cache downloader:(FYDownloader *)downloader {
    if (self = [super init]) {
        _cache = cache;
        _downloader = downloader;
    }
    return self;
}

- (FYDownloaderOperation *)downloadTaskWithURL:(NSURL *)url options:(FYDownloaderOptions)options progress:(FYDownloaderOperationProgressBlock)progressedBlock complete:(FYDownloaderCompletedBlock)completedBlock cancel:(FYDownloaderCancelledBlock)cancelledBlock {
    FYDownloaderOperation* operation = [self.downloader downloadTaskWithURL:url options:options progress:progressedBlock complete:completedBlock cancel:cancelledBlock];
    return operation;
}


@end
