//
//  FYDownloadManager.h
//  FFKit
//
//  Created by fan on 17/2/8.
//  Copyright © 2017年 fan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FYDownloader.h"
#import "FYDownloadCache.h"

@interface FYDownloadManager : NSObject

@property (nonatomic, strong, readonly) FYDownloader* downloader;

@property (nonatomic, strong, readonly) FYDownloadCache* cache;

+ (instancetype)sharedManager;

- (instancetype)initWithCache:(FYDownloadCache*)cache downloader:(FYDownloader*)downloader;

- (FYDownloaderOperation* )downloadTaskWithURL:(NSURL *)url
                                       options:(FYDownloaderOptions)options
                                      progress:(FYDownloaderOperationProgressBlock)progressedBlock
                                      complete:(FYDownloaderCompletedBlock)completedBlock
                                        cancel:(FYDownloaderCancelledBlock)cancelledBlock;

@end
