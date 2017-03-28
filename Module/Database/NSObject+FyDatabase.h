//
//  NSObject+FyDatabase.h
//  MyPlane
//
//  Created by fan on 16/8/17.
//  Copyright © 2016年 fan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FyDBHelper.h"
#import "FyUtils.h"

@interface NSObject (FyDatabase)

/**********************************
 *  配置扩展
 **********************************/

/**
*  默认主键，没有设置主键时生效
*/
@property (nonatomic) NSUInteger keyId;

/**
 *  表名
 */
+ (NSString*)getTableName;

/**
 *  主键名
 */
+ (NSString*)getKey;

+ (FyModelInfo*)getModelInfo;

/**
 *  配置每个属性（可选)
 */
+ (void)setColumnAttributeWithProporty:(FyModelProperty*)property;


/**********************************
 *  数据库操作
 **********************************/
- (void)save;



@end
