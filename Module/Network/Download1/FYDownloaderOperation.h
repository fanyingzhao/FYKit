//
//  FYDownloaderOperation.h
//  FFKit
//
//  Created by fan on 17/2/8.
//  Copyright © 2017年 fan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FYDownloader.h"

@interface FYDownloaderOperation : NSOperation <NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property (nonatomic, copy, readonly) NSURLRequest* request;

@property (nonatomic, strong, readonly) NSURLSessionTask* dataTask;

@property (nonatomic, strong) NSOutputStream* stream;

@property (nonatomic, copy) NSString* title;

@property (nonatomic, copy) NSString* filePath;

@property (nonatomic, copy) FYDownloaderOperationProgressBlock progressedBlock;
@property (nonatomic, copy) FYDownloaderCompletedBlock completedBlock;
@property (nonatomic, copy) FYDownloaderCancelledBlock cancelledBlock;


- (instancetype)initWithRequest:(NSURLRequest* )request
                      inSession:(NSURLSession*)session
                        options:(FYDownloaderOptions)options
                       progress:(FYDownloaderOperationProgressBlock)progressedBlock
                      completed:(FYDownloaderCompletedBlock)completedBlock
                      cancelled:(FYDownloaderCancelledBlock)canceldBlock;

- (void)deleteTask;

@end


@interface FYDownloaderOperation (Tools)

- (NSString*)getDownloadTaskName:(NSString*)url;
- (NSString*)getDownloadTaskPath:(NSString*)url;
- (BOOL)queryTaskIsExist:(NSString*)url;
- (BOOL)getTaskIsFinish:(NSString*)url;
- (unsigned long long)getTaskCountOfExpectedToReceive:(NSString*)url;
- (void)saveConfigCountOfExpectedToReceive:(unsigned long long)length;
- (void)saveConfigIsFinished:(BOOL)isFinished;

@end
