//
//  FYDownloader.m
//  FFKit
//
//  Created by fan on 17/2/8.
//  Copyright © 2017年 fan. All rights reserved.
//

#import "FYDownloader.h"
#import "FYDownloaderOperation.h"

@interface FYDownloader () <NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property (nonatomic) FYDownloaderOptions options;
@property (nonatomic, strong) NSOperationQueue* downloadQueue;
@property (strong, nonatomic) NSURLSession *session;

@end

@implementation FYDownloader

- (instancetype)init {
    if (self = [super init]) {
        _downloadQueue = [[NSOperationQueue alloc] init];
        _downloadQueue.maxConcurrentOperationCount = 6;
        _downloadQueue.name = @"com.fyz.FYDownloader";
        _downloadTimeout = 15.0;
        
        NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfig.timeoutIntervalForRequest = _downloadTimeout;
        
        self.session = [NSURLSession sessionWithConfiguration:sessionConfig
                                                     delegate:self
                                                delegateQueue:nil];
    }
    return self;
}

#pragma mark - tools
- (FYDownloaderOperation *)operationWithTask:(NSURLSessionTask *)task {
    FYDownloaderOperation *returnOperation = nil;
    for (FYDownloaderOperation *operation in self.downloadQueue.operations) {
        if (operation.dataTask.taskIdentifier == task.taskIdentifier) {
            returnOperation = operation;
            break;
        }
    }
    return returnOperation;
}

#pragma mark - funcs
+ (instancetype)sharedDownloader {
    static FYDownloader* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FYDownloader alloc] init];
    });
    return instance;
}

- (FYDownloaderOperation* )downloadTaskWithURL:(NSURL *)url options:(FYDownloaderOptions)options progress:(FYDownloaderOperationProgressBlock)progressedBlock complete:(FYDownloaderCompletedBlock)completedBlock cancel:(FYDownloaderCancelledBlock)cancelledBlock {
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:0 timeoutInterval:self.downloadTimeout];
    // 设置所有的http请求头
    
    
    FYDownloaderOperation* operation = [[FYDownloaderOperation alloc] initWithRequest:request inSession:self.session options:options progress:progressedBlock completed:completedBlock cancelled:cancelledBlock];
    [self.downloadQueue addOperation:operation];
    
    return operation;
}

- (void)setSuspended:(BOOL)suspended {
    [self.downloadQueue setSuspended:suspended];
}

- (void)cancelAllDownloads {
    [self.downloadQueue cancelAllOperations];
}

#pragma mark NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    FYDownloaderOperation* operation = [self operationWithTask:dataTask];
    [operation URLSession:session dataTask:dataTask didReceiveResponse:response completionHandler:completionHandler];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    FYDownloaderOperation* operation = [self operationWithTask:dataTask];
    [operation URLSession:session dataTask:dataTask didReceiveData:data];
}

#pragma mark NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    FYDownloaderOperation* operation = [self operationWithTask:task];
    [operation URLSession:session task:task didCompleteWithError:error];
}

#pragma mark - setter
- (void)setMaxConcurrentDownloads:(NSInteger)maxConcurrentDownloads {
    self.downloadQueue.maxConcurrentOperationCount = maxConcurrentDownloads;
}

#pragma mark - getter
- (NSInteger)currentDownloadCount {
    return self.downloadQueue.operationCount;
}

- (NSInteger)maxConcurrentDownloads {
    return self.downloadQueue.maxConcurrentOperationCount;
}

- (NSTimeInterval)downloadTimeout {
    if (!_downloadTimeout) {
        _downloadTimeout = 15.0;
    }
    return _downloadTimeout;
}

@end
