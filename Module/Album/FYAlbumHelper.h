//
//  FYAlbumHelper.h
//  Prisma
//
//  Created by fan on 16/11/2.
//  Copyright © 2016年 fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FYAlbumHelper : NSObject

+ (instancetype)sharedInstance;


/**
 得到所有系统图片

 @return 包含所有图片的列表
 */
- (NSArray*)getAllAlbumPhotos;

@end
