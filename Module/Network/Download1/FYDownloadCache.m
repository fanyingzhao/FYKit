//
//  FYDownloadCache.m
//  FFKit
//
//  Created by fan on 17/2/8.
//  Copyright © 2017年 fan. All rights reserved.
//

#import "FYDownloadCache.h"

static const NSInteger kDefaultCacheMaxCacheAge = 60 * 60 * 24 * 7; // 1 week

@interface FYDownloadCache ()

@property (nonatomic, copy) NSString* configPath;
@property (nonatomic, strong) NSMutableDictionary* configDict;
@property (strong, nonatomic) NSString *diskCachePath;

@property (nonatomic, strong) NSFileManager* fileManager;
@property (nonatomic, strong) dispatch_queue_t ioQueue;

@end

@implementation FYDownloadCache

#pragma mark - init
- (instancetype)init {
    if (self = [super init]) {
        _ioQueue = dispatch_queue_create("com.fyz.FYDownloader", DISPATCH_QUEUE_SERIAL);
        _maxCacheAge = kDefaultCacheMaxCacheAge;
        
        _diskCachePath = [NSString stringWithFormat:@"%@/videos", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]];
        
        NSString* director =  [NSString stringWithFormat:@"%@/%@", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject], @"com.fyz.downloader"];
        [NSFileManager createDirectoryWithPath:director error:nil];
        _configPath = [director stringByAppendingPathComponent:[@"fyz-downloader.plist" md5EncoderFilename]];
        _configDict = [NSMutableDictionary dictionaryWithContentsOfFile:_configPath];
    }
    return self;
}

#pragma mark - tools
- (NSString*)getDownloadTaskName:(NSString*)url {
    return [url md5EncoderFilename];
}

- (NSString*)getDownloadTaskPath:(NSString*)url {
    return [self.diskCachePath stringByAppendingPathComponent:[self getDownloadTaskName:url]];
}

- (void)removeConfig:(NSString*)key {
    [self.configDict setValue:nil forKey:[key md5With16Encoder]];
    [self.configDict writeToFile:self.configPath atomically:YES];
}

#pragma mark - funcs
+ (instancetype)sharedCache {
    static FYDownloadCache* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FYDownloadCache alloc] init];
    });
    return instance;
}

- (BOOL)queryDiskCacheForKey:(NSString *)key {
    return [[NSFileManager defaultManager] fileExistsAtPath:[self getDownloadTaskPath:key]];
}

- (void)removeForKey:(NSString *)key {
    BOOL res = [[NSFileManager defaultManager] removeItemAtPath:[self getDownloadTaskPath:key] error:nil];
    if (res) {
        [self removeConfig:key];
    }
}

- (void)clearDisk {
    [self clearDiskOnCompletion:nil];
}

- (void)clearDiskOnCompletion:(FYDownloaderNoParamsBlock)completion {
    dispatch_async(self.ioQueue, ^{
        BOOL res = [_fileManager removeItemAtPath:self.diskCachePath error:nil];
        if (res) {
            [_fileManager removeItemAtPath:self.configPath error:nil];
        }
        [_fileManager createDirectoryAtPath:self.diskCachePath
                withIntermediateDirectories:YES
                                 attributes:nil
                                      error:NULL];
        
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion();
            });
        }
    });
}

- (void)cleanDisk {
    [self cleanDiskWithCompletionBlock:nil];
}

- (void)cleanDiskWithCompletionBlock:(FYDownloaderNoParamsBlock)completionBlock {
    dispatch_async(self.ioQueue, ^{
        NSURL *diskCacheURL = [NSURL fileURLWithPath:self.diskCachePath isDirectory:YES];
        NSArray *resourceKeys = @[NSURLIsDirectoryKey, NSURLContentModificationDateKey, NSURLTotalFileAllocatedSizeKey];
        
        // This enumerator prefetches useful properties for our cache files.
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtURL:diskCacheURL
                                                   includingPropertiesForKeys:resourceKeys
                                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                 errorHandler:NULL];
        
        NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:-self.maxCacheAge];
        NSMutableDictionary *cacheFiles = [NSMutableDictionary dictionary];
        NSUInteger currentCacheSize = 0;
        
        // Enumerate all of the files in the cache directory.  This loop has two purposes:
        //
        //  1. Removing files that are older than the expiration date.
        //  2. Storing file attributes for the size-based cleanup pass.
        NSMutableArray *urlsToDelete = [[NSMutableArray alloc] init];
        for (NSURL *fileURL in fileEnumerator) {
            NSDictionary *resourceValues = [fileURL resourceValuesForKeys:resourceKeys error:NULL];
            
            // Skip directories.
            if ([resourceValues[NSURLIsDirectoryKey] boolValue]) {
                continue;
            }
            
            // Remove files that are older than the expiration date;
            NSDate *modificationDate = resourceValues[NSURLContentModificationDateKey];
            if ([[modificationDate laterDate:expirationDate] isEqualToDate:expirationDate]) {
                [urlsToDelete addObject:fileURL];
                continue;
            }
            
            // Store a reference to this file and account for its total size.
            NSNumber *totalAllocatedSize = resourceValues[NSURLTotalFileAllocatedSizeKey];
            currentCacheSize += [totalAllocatedSize unsignedIntegerValue];
            [cacheFiles setObject:resourceValues forKey:fileURL];
        }
        
        for (NSURL *fileURL in urlsToDelete) {
            [self.configDict setValue:nil forKey:[fileURL absoluteString]];
            [_fileManager removeItemAtURL:fileURL error:nil];
        }
        
        [self.configDict writeToFile:self.configPath atomically:YES];
        
        // If our remaining disk cache exceeds a configured maximum size, perform a second
        // size-based cleanup pass.  We delete the oldest files first.
        if (self.maxCacheSize > 0 && currentCacheSize > self.maxCacheSize) {
            // Target half of our maximum cache size for this cleanup pass.
            const NSUInteger desiredCacheSize = self.maxCacheSize / 2;
            
            // Sort the remaining cache files by their last modification time (oldest first).
            NSArray *sortedFiles = [cacheFiles keysSortedByValueWithOptions:NSSortConcurrent
                                                            usingComparator:^NSComparisonResult(id obj1, id obj2) {
                                                                return [obj1[NSURLContentModificationDateKey] compare:obj2[NSURLContentModificationDateKey]];
                                                            }];
            
            // Delete files until we fall below our desired cache size.
            for (NSURL *fileURL in sortedFiles) {
                if ([_fileManager removeItemAtURL:fileURL error:nil]) {
                    NSDictionary *resourceValues = cacheFiles[fileURL];
                    NSNumber *totalAllocatedSize = resourceValues[NSURLTotalFileAllocatedSizeKey];
                    currentCacheSize -= [totalAllocatedSize unsignedIntegerValue];
                    
                    if (currentCacheSize < desiredCacheSize) {
                        break;
                    }
                }
            }
        }
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock();
            });
        }
    });
}

- (NSUInteger)getSize {
    __block NSUInteger size = 0;
    dispatch_sync(self.ioQueue, ^{
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtPath:self.diskCachePath];
        for (NSString *fileName in fileEnumerator) {
            NSString *filePath = [self.diskCachePath stringByAppendingPathComponent:fileName];
            NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
            size += [attrs fileSize];
        }
    });
    return size;
}

- (NSUInteger)getDiskCount {
    __block NSUInteger count = 0;
    dispatch_sync(self.ioQueue, ^{
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtPath:self.diskCachePath];
        count = [[fileEnumerator allObjects] count];
    });
    return count;
}

- (void)calculateSizeWithCompletionBlock:(FYDownloaderCalculateSizeBlock)completionBlock {
    NSURL *diskCacheURL = [NSURL fileURLWithPath:self.diskCachePath isDirectory:YES];
    
    dispatch_async(self.ioQueue, ^{
        NSUInteger fileCount = 0;
        NSUInteger totalSize = 0;
        
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtURL:diskCacheURL
                                                   includingPropertiesForKeys:@[NSFileSize]
                                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                 errorHandler:NULL];
        
        for (NSURL *fileURL in fileEnumerator) {
            NSNumber *fileSize;
            [fileURL getResourceValue:&fileSize forKey:NSURLFileSizeKey error:NULL];
            totalSize += [fileSize unsignedIntegerValue];
            fileCount += 1;
        }
        
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(fileCount, totalSize);
            });
        }
    });
}

@end
