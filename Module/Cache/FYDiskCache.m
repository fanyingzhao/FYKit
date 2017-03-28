//
//  FYDiskCache.m
//  FFKit
//
//  Created by fan on 16/7/9.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "FYDiskCache.h"
#import "NSString+FYAdd.h"
#import "FYKitMacro.h"

@interface FYDiskCache () {
    NSMutableArray* _cachePathList;
}
@end

@implementation FYDiskCache

- (instancetype)init {
    if (self = [super init]) {
        _cachePathList = nil;
    }
    return self;
}

- (void)setCachePath:(NSString *)path {
    if (!path || [_path isEqualToString:@""]) {
        path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    }
    _path = path;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:_path]) {
        if (![[NSFileManager defaultManager] createDirectoryAtPath:_path withIntermediateDirectories:YES attributes:nil error:nil]) {
            FYLog(@"创建缓存目录失败");
        }
    }
    
    [_cachePathList addObject:path];
}

#pragma mark - query
- (id)objectForKey:(NSString *)key {
    NSString* path = [self cachePathForKey:key];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        
    }
    return nil;
}

#pragma mark - remove
- (void)removeObjectForKey:(NSString *)key {
    if (![[NSFileManager defaultManager] removeItemAtPath:[self cachePathForKey:key] error:nil]) {
        FYLog(@"删除缓存失败: key -- %@",key);
    }
}

- (void)removeAllObjects {
    [_cachePathList enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [[NSFileManager defaultManager] removeItemAtPath:obj error:nil];
    }];
}

#pragma mark - store
- (void)setObject:(NSObject*)object forKey:(NSString *)key {
    [self setObject:object forKey:key cost:0];
}

- (void)setObject:(NSObject*)object forKey:(NSString *)key cost:(NSUInteger)cost {
    [self setObject:object forKey:key cost:cost complete:nil];
}

- (void)setObject:(NSObject*)object forKey:(NSString *)key complete:(FYCacheQueryCompleteBlcok)completeBlock {
    if ([object isKindOfClass:[UIImage class]]) {
        
    }else if ([object isKindOfClass:[NSData class]]) {
        
    }else if ([object isKindOfClass:[NSString class]]) {
        
    }
}

#pragma mark - tools
- (NSString*)cachePath {
    return _path;
}

- (NSArray*)allCachePath {
    return _cachePathList;
}

- (NSString*)cachePathForKey:(NSString*)key {
    return [_path stringByAppendingString:[self cacheNameForKey:key]];
}

- (NSString*)cacheNameForKey:(NSString*)key {
    return [key md5EncoderFilename];
}

#pragma mark - getter

@end
