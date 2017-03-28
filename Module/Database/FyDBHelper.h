//
//  FyDBHelper.h
//  MyPlane
//
//  Created by fan on 16/8/17.
//  Copyright © 2016年 fan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FyUtils.h"

@interface FyDBHelper : NSObject {
    
}
@property (nonatomic) BOOL debug;                               // 是否显示错误信息
@property (nonatomic, copy, readonly) NSString* path;

- (instancetype)initWithPath:(NSString*)path;

- (void)setDatabasePath:(NSString*)path;

- (BOOL)openDB;
- (BOOL)closeDB;

/**
 *  创建
 */
- (BOOL)createTable:(Class)objClass;

/**
 *  查询列表
 */
- (NSArray*)getTotoal:(Class)objClass where:(NSString*)where;
- (NSArray*)getAll:(NSString*)col where:(NSString*)where sort:(NSString*)sort page:(NSInteger)page limit:(NSInteger)limit;

/**
 *  单条记录
 */
- (NSObject*)getRow:(NSString*)where;
- (NSObject*)getRowByKey:(NSString*)key;

/**
 *  保存
 */
- (void)save:(NSObject*)model;

/**
 *  更新
 */
- (void)update:(NSString*)where data:(NSObject*)obj;
- (void)updateByKey:(NSString*)key data:(NSObject*)obj;
- (void)updateNum:(NSString*)where col:(NSString*)col num:(NSInteger)num;
- (void)updateNumByKey:(NSString*)key col:(NSString*)col num:(NSInteger)num;

/**
 *  删除
 */
- (void)deleteToDB;

@end
