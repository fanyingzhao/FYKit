//
//  FYAlbumHelper.m
//  Prisma
//
//  Created by fan on 16/11/2.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "FYAlbumHelper.h"

@implementation FYAlbumHelper

+ (instancetype)sharedInstance {
    static FYAlbumHelper* albumHelperInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        albumHelperInstance = [[FYAlbumHelper alloc] init];
    });
    return albumHelperInstance;
}

- (NSArray *)getAllAlbumPhotos {
    NSMutableArray* lists = [NSMutableArray array];
    
    
    return lists;
}

@end
