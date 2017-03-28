//
//  FYMemoryCache.m
//  FFKit
//
//  Created by fan on 16/7/9.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "FYMemoryCache.h"
#import "FYKit.h"

//static const float subStandard          = 0.000001;

static const NSString* Key              = @"key";
static const NSString* Value            = @"value";
static const NSString* Cost             = @"cost";
static const NSString* ExpiredTime      = @"expiredTime";
static const NSString* Frequency        = @"frequency";
static const NSString* AccessLastTime   = @"accessLastTime";

@interface FYMemoryCache () {
    
}
@property (nonatomic, strong) NSMutableDictionary* cacheDic;
@end

@implementation FYMemoryCache

- (instancetype)init {
    if (self = [super init]) {
        self.totalCostLimit = NSUIntegerMax;
        self.expiredTime = 60 * 60 * 24 * 7;
        self.countLimt = 2;
    }
    return self;
}

#pragma mark - get
- (id)objectForKey:(NSString *)key {
    NSMutableDictionary* dic = [self.cacheDic objectForKey:key];
    [dic setObject:[[dic objectForKey:Frequency] intIncreame] forKey:Frequency];
    [dic setObject:[NSDate date] forKey:AccessLastTime];
    
    return [self.cacheDic objectForKey:key];
}

#pragma mark - store
- (void)setObject:(NSObject*)object forKey:(NSString *)key {
    [self setObject:object forKey:key cost:0];
}
/**
 *  如果对象给nil，过期时间小于当前时间，将key 对应的缓存置空
 *  如果数量超过了限制，如果大小超出了限制,线程安全？
 */
- (void)setObject:(NSObject*)object forKey:(NSString *)key cost:(NSUInteger)cost {
    if (object) {
        if (self.totalCount + 1 > self.countLimt) {
            [self trimToCount];
        }
        if (self.costCount + cost > self.totalCostLimit) {
            [self trimToCost];
        }
        NSDate* expiredDate = [NSDate dateWithTimeIntervalSinceNow:self.expiredTime];
        if ([[NSDate date] laterDate:expiredDate] != expiredDate) {
            [self removeObjectForKey:key];
            return;
        }
        NSMutableDictionary* dic = [NSMutableDictionary dictionary];
        [dic setObject:key forKey:Key];
        [dic setObject:object forKey:Value];
        [dic setObject:expiredDate forKey:ExpiredTime];
        [dic setObject:@(0) forKey:Frequency];
        [dic setObject:[NSDate date] forKey:AccessLastTime];
        [dic setObject:@(cost) forKey:Cost];
        
        [self.cacheDic setObject:dic forKey:key];
        self.totalCount ++;
        self.costCount += cost;
    }else {
        [self removeObjectForKey:key];
    }
}

#pragma mark - remove
- (void)removeObjectForKey:(NSString *)key {
    [self.cacheDic removeObjectForKey:key];
}

- (void)removeAllObjects {
    [self.cacheDic removeAllObjects];
}

#pragma mark - clean
- (void)clean {
    NSMutableArray* deleteList = [NSMutableArray array];
    [self.cacheDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSDictionary*  _Nonnull obj, BOOL * _Nonnull stop) {
        NSDate* date = [NSDate date];
        if ([[date laterDate:[obj objectForKey:ExpiredTime]] isEqualToDate:date]) {
            [deleteList addObject:obj];
        }
    }];
    
    [deleteList enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.cacheDic removeObjectForKey:[obj objectForKey:Key]];
        self.costCount = self.costCount - [[obj objectForKey:Cost] unsignedIntegerValue];
        self.totalCount --;
    }];
}

#pragma mark - tools
- (void)trimToCost {
    // 释放出一半的内存
    NSUInteger desiredCacheSize = self.totalCostLimit / 2;
    [[self sort] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.cacheDic removeObjectForKey:[obj objectForKey:Key]];
        self.totalCount = self.totalCount - [[obj objectForKey:Cost] doubleValue];
        self.costCount -- ;
        if (self.totalCount < desiredCacheSize) {
            *stop = YES;
        }
    }];
}

- (void)trimToCount {
    NSUInteger desiredCacheCount = self.countLimt / 2;
    [[self sort] enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.cacheDic removeObjectForKey:[obj objectForKey:Key]];
        self.totalCount = self.totalCount - [[obj objectForKey:Cost] doubleValue];
        self.costCount -- ;
        if (self.costCount < desiredCacheCount) {
            *stop = YES;
        }
    }];
}

// 对已经缓存的资源按使用频率和最后使用日期进行排序
- (NSArray*)sort {
    NSMutableArray* sortList = [NSMutableArray array];
    [self.cacheDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSDictionary*  _Nonnull obj, BOOL * _Nonnull stop) {
        NSUInteger currentCount = [[obj objectForKey:Frequency] unsignedIntegerValue];
        
        __block NSUInteger index = 0;
        [sortList enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSUInteger accessCount = [[obj objectForKey:Frequency] unsignedIntegerValue];
            NSUInteger nextAccessCount = -1;
            if (idx < sortList.count - 1) {
                nextAccessCount = [[[sortList objectAtIndex:idx + 1] objectForKey:Frequency] unsignedIntegerValue];
            }
            if (nextAccessCount != -1) {
                if (currentCount > accessCount && currentCount < nextAccessCount) {
                    index = idx + 1;
                    *stop = YES;
                }
            }else {
                if (currentCount > accessCount) {
                    index = idx + 1;
                    *stop = YES;
                }
            }
        }];
        
        if (sortList.count) {
            NSDictionary* objDic = [sortList objectAtIndex:index];
            NSDate* objDate = [objDic objectForKey:AccessLastTime];
            if ([[objDate laterDate:[obj objectForKey:AccessLastTime]] isEqualToDate:objDate]) {
                index ++;
            }
            
            [sortList addObject:obj];
            [sortList exchangeObjectAtIndex:index withObjectAtIndex:sortList.count - 1];
        }else {
            [sortList addObject:obj];
        }
    }];
    
    return sortList.copy;
}

#pragma mark - getter
- (NSMutableDictionary *)cacheDic {
    if (!_cacheDic) {
        _cacheDic = [NSMutableDictionary dictionary];
    }
    return _cacheDic;
}

@end
