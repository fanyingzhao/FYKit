//
//  FYDownloaderOperation.m
//  FFKit
//
//  Created by fan on 17/2/8.
//  Copyright © 2017年 fan. All rights reserved.
//

#import "FYDownloaderOperation.h"

#define CountOfExpectedReceive  @"CountOfExpectedReceive"
#define IsFinished              @"IsFinished"

@interface FYDownloaderOperation ()
@property (nonatomic, copy) NSString* url;

@property (nonatomic, strong) NSURLSession* session;
@property (nonatomic, strong) NSURLSession* ownerSession;
@property (strong, nonatomic, readwrite) NSURLSessionTask *dataTask;

@property (assign, nonatomic, getter = isExecuting) BOOL executing;
@property (assign, nonatomic, getter = isFinished) BOOL finished;
@property (assign, nonatomic, getter = isCancelled) BOOL cancelled;

@property (nonatomic, copy) NSString* configPath;
@property (nonatomic, strong) NSMutableDictionary* configDict;
@end

@implementation FYDownloaderOperation

@synthesize executing = _executing;
@synthesize finished = _finished;
@synthesize cancelled = _cancelled;

- (instancetype)initWithRequest:(NSURLRequest *)request inSession:(NSURLSession *)session options:(FYDownloaderOptions)options progress:(FYDownloaderOperationProgressBlock)progressedBlock completed:(FYDownloaderCompletedBlock)completedBlock cancelled:(FYDownloaderCancelledBlock)canceldBlock {
    if (self = [super init]) {
        _request = request;
        _url = [[request URL] absoluteString];
        _progressedBlock = progressedBlock;
        _completedBlock = completedBlock;
        _cancelledBlock = canceldBlock;
        _filePath = [NSString stringWithFormat:@"%@/videos", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]];
        
        NSString* director =  [NSString stringWithFormat:@"%@/%@", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject], @"com.fyz.downloader"];
        [NSFileManager createDirectoryWithPath:director error:nil];
        _configPath = [director stringByAppendingPathComponent:[@"fyz-downloader.plist" md5EncoderFilename]];
        _configDict = [NSMutableDictionary dictionaryWithContentsOfFile:_configPath];
        
        if (!_configDict) {
            NSMutableDictionary* dic = [NSMutableDictionary dictionary];
            _configDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:dic, [self.url md5With16Encoder], nil];
        }
        
        if (!session) {
            _ownerSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
        }
    }
    return self;
}

#pragma mark - overwrite
- (void)start {
    if (!self.isReady) {
        FYLog(@"有依赖项没有完成，任务暂不开启");
        return ;
    }
    
    if (self.isFinished || self.isCancelled) {
        self.executing = NO;
        self.finished = YES;
        [self reset];
        return ;
    }
    
    self.executing = YES;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    
    NSInteger size = FYDownloadLength([self getDownloadTaskPath:self.url]);
    NSString *range = [NSString stringWithFormat:@"bytes=%zd-", size];
    [request setValue:range forHTTPHeaderField:@"Range"];

    self.dataTask = [self.ownerSession dataTaskWithRequest:request];
    [self.dataTask resume];
}

- (void)cancel {
    if (self.isFinished) return;
    
    self.cancelled = YES;
    self.executing = NO;
    self.finished = YES;
    
    [self.dataTask cancel];
}

- (void)deleteTask {
    [[NSFileManager defaultManager] removeItemAtPath:[self getDownloadTaskPath:self.url] error:nil];
    // 删除配置文件
    [self.configDict setValue:nil forKey:[self.url md5With16Encoder]];
    [self.configDict writeToFile:self.configPath atomically:YES];
    
    FYLog(@"删除成功");
}

#pragma mark - tools
- (void)reset {
    self.progressedBlock = nil;
    self.completedBlock = nil;
    self.cancelledBlock = nil;
    
    [self.ownerSession invalidateAndCancel];
    self.ownerSession = nil;
}

- (void)done {
    
}

#pragma mark NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    if (![response respondsToSelector:@selector(statusCode)] || ([((NSHTTPURLResponse *)response) statusCode] < 400 && [((NSHTTPURLResponse *)response) statusCode] != 304)) {
        NSError* error;
        [NSFileManager createDirectoryWithPath:self.filePath error:&error];
        if (error) {
            FYLog(@"存储路径错误");
            [self cancel];
        }else {
            if ([self queryTaskIsExist:self.url]) {
                // 已经存在，同一个文件
                if (self.completedBlock) {
                    self.completedBlock(nil);
                }
                
                [self.dataTask cancel];
                self.finished = YES;
                self.executing = NO;
                [self reset];
            }else {
                // 没有下载完毕，继续下载，如果下载完毕且与要下载的大小不同，则删除原来的，重新下载
                if ([self getTaskIsFinish:self.url]) {
                    BOOL sizeIsSame = [self getTaskCountOfExpectedToReceive:self.url] == FYDownloadLength(self.url) ? YES : NO;
                    if (!sizeIsSame) {
                        [[NSFileManager defaultManager] removeItemAtPath:[self getDownloadTaskPath:self.url] error:nil];
                    }
                }
                
                NSInteger size = FYDownloadLength([self getDownloadTaskPath:self.url]);
                if (size == 0) {
                    [self saveConfigCountOfExpectedToReceive:dataTask.countOfBytesExpectedToReceive];
                }
                
                if (self.progressedBlock) {
                    self.progressedBlock(0, 0, [self getTaskCountOfExpectedToReceive:self.url]);
                }
                
                self.stream = [NSOutputStream outputStreamToFileAtPath:[self getDownloadTaskPath:self.url] append:YES];
                [self.stream open];
            }
        }
    }else {
        NSUInteger code = [((NSHTTPURLResponse *)response) statusCode];
        
        if (code == 304) {
            if (self.progressedBlock) {
                self.progressedBlock(0, 1, 1);
            }
            
            if (self.completedBlock) {
                self.completedBlock(nil);
            }
        }else if (code == 416) {
            if (self.progressedBlock) {
                self.progressedBlock(0, 1, 1);
            }
            
            FYLog(@"断点下载range设置错误");
            if (FYDownloadLength([self getDownloadTaskPath:self.url]) >= dataTask.countOfBytesExpectedToReceive) {
                FYLog(@"已经下载完毕或者超出");
            }
            if (self.completedBlock) {
                self.completedBlock(nil);
            }
        }else {
            FYLog(@"服务器响应失败");
            if (self.completedBlock) {
                self.completedBlock([NSError errorWithDomain:NSURLErrorDomain code:[((NSHTTPURLResponse *)response) statusCode] userInfo:nil]);
            }
        }
        
        [self.dataTask cancel];
        self.finished = YES;
        self.executing = NO;
        [self reset];
    }
    
    if (completionHandler) {
        completionHandler(NSURLSessionResponseAllow);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    // 将数据写入
    if (self.stream.hasSpaceAvailable) {
        NSInteger resLength = [self.stream write:[data bytes] maxLength:data.length];
        if (resLength != data.length) {
            FYLog(@"写入时发生问题");
        }
        
        if (self.progressedBlock) {
            self.progressedBlock(data.length, [[[NSFileManager defaultManager] attributesOfItemAtPath:[self getDownloadTaskPath:self.url] error:nil][NSFileSize] integerValue], [self getTaskCountOfExpectedToReceive:self.url]);
        }
    }else {
        FYLog(@"磁盘空间不足");
        [self cancel];
    }
}

#pragma mark NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    // 关闭流
    [self.stream close];
    
    if (error) {
        [self saveConfigIsFinished:NO];
    }else {
        [self saveConfigIsFinished:YES];
    }
    
    
    if (self.completedBlock) {
        self.completedBlock(error);
    }
    
    self.finished = YES;
    self.executing = NO;
    [self reset];
}

#pragma mark - setter
- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)setCancelled:(BOOL)cancelled {
    [self willChangeValueForKey:@"isCancelled"];
    _cancelled = cancelled;
    [self didChangeValueForKey:@"isCancelled"];
}

@end

@implementation FYDownloaderOperation (Tools)

- (NSString*)getDownloadTaskName:(NSString*)url {
    return [url md5EncoderFilename];
}

- (NSString*)getDownloadTaskPath:(NSString*)url {
    return [self.filePath stringByAppendingPathComponent:[self getDownloadTaskName:url]];
}

- (BOOL)queryTaskIsExist:(NSString*)url {
    // 判断是否是同一个文件,根据大小判断？哈希值？
    // 考虑断点下载情况
    BOOL sizeIsSame = [self getTaskCountOfExpectedToReceive:self.url] == FYDownloadLength(self.url) ? YES : NO;
    
    // 如果下载完毕，比较两个文件的大小是否相同
    if ([self getTaskIsFinish:self.url] && sizeIsSame) {
        return YES;
    }else {
        return NO;
    }
}

- (BOOL)getTaskIsFinish:(NSString*)url {
    return [[[self.configDict objectForKey:[self.url md5With16Encoder]] objectForKey:IsFinished] boolValue];
}

- (unsigned long long)getTaskCountOfExpectedToReceive:(NSString*)url {
    return [[[self.configDict objectForKey:[self.url md5With16Encoder]] objectForKey:CountOfExpectedReceive] unsignedLongLongValue];
}

- (void)saveConfigCountOfExpectedToReceive:(unsigned long long)length {
    NSMutableDictionary* dic = [self.configDict objectForKey:[self.url md5With16Encoder]];
    if (!dic) dic = [NSMutableDictionary dictionary];
    [dic setValue:@(length) forKey:CountOfExpectedReceive];
    [self.configDict setValue:dic forKey:[self.url md5With16Encoder]];
    [self.configDict writeToFile:self.configPath atomically:YES];
}

- (void)saveConfigIsFinished:(BOOL)isFinished {
    NSMutableDictionary* dic = [self.configDict objectForKey:[self.url md5With16Encoder]];
    if (!dic) dic = [NSMutableDictionary dictionary];
    [dic setValue:@(isFinished) forKey:IsFinished];
    [self.configDict setValue:dic forKey:[self.url md5With16Encoder]];
    [self.configDict writeToFile:self.configPath atomically:YES];
}


@end
