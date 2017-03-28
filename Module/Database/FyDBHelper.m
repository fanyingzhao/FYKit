//
//  FyDBHelper.m
//  MyPlane
//
//  Created by fan on 16/8/17.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "FyDBHelper.h"
#import <FMDB/FMDB.h>
#import "NSObject+FyDatabase.h"
#import "FYMacro.h"
#import "NSFileManager+FYAdd.h"

@interface FyDBHelper () {

}
@property (nonatomic, strong) FMDatabase* db;
@property (nonatomic, copy) NSString* path;

@end

@implementation FyDBHelper
- (instancetype)init {
    return [self initWithPath:nil];
}

- (instancetype)initWithPath:(NSString *)path {
    if (self = [super init]) {
        _path = path;
        [NSFileManager createDirectoryWithPath:self.path error:nil];
        self.debug = YES;
        self.db = [FMDatabase databaseWithPath:self.path];
        [self openDB];
    }
    return self;
}

- (void)dealloc {
    [self closeDB];
}

- (BOOL)createTable:(Class)objClass {
    FyModelInfo* info = [objClass getModelInfo];
    
    __block NSString* sql = [NSString stringWithFormat:@"create table if not exists %@ (",[objClass getTableName]];
    [info.propertyList enumerateObjectsUsingBlock:^(FyModelProperty * _Nonnull property, NSUInteger idx, BOOL * _Nonnull stop) {
        sql = [sql stringByAppendingString:[NSString stringWithFormat:@"%@ %@",property.dbName, property.dbType]];
        if ([property.dbName isEqualToString:[objClass getKey]]) {
            sql = [sql stringByAppendingString:@" PRIMARY KEY"];
            if (property.autoIncrement) {
                sql = [sql stringByAppendingString:@" AUTOINCREMENT"];
            }
        }
        if (property.notNull) {
            sql = [sql stringByAppendingString:@" NOT NULL"];
        }
        if (property.unique) {
            sql = [sql stringByAppendingString:@" UNIQUE"];
        }
        if (property.defaultValue) {
            if ([property.dbType isEqualToString:@"text"])
                sql = [sql stringByAppendingString:[NSString stringWithFormat:@"\'%@\'",property.defaultValue]];
            else
                sql = [sql stringByAppendingString:[NSString stringWithFormat:@" %@",property.defaultValue]];
        }
        sql = [sql stringByAppendingString:@","];
    }];
    sql = [[sql substringToIndex:sql.length - 1] stringByAppendingString:@")"];
    [self dbLog:sql];

    if (![self.db executeUpdate:sql]) {
        [self dbLog:[NSString stringWithFormat:@"创建%@表失败",[objClass getTableName]]];
        return NO;
    }
    
    return YES;
}

- (NSArray *)getTotoal:(Class)objClass where:(NSString *)where {
    FyModelInfo* info = [objClass getModelInfo];

    NSString* sql = [NSString stringWithFormat:@"select * from %@",[objClass getTableName]];
    if (where) {
        sql = [sql stringByAppendingString:[NSString stringWithFormat:@" %@",where]];
    }
    
    NSMutableArray* list = [NSMutableArray array];
    
    FMResultSet* rs = [self.db executeQuery:sql];
    while ([rs next]) {
        NSObject* model = [[objClass alloc] init];
        [info.propertyList enumerateObjectsUsingBlock:^(FyModelProperty * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.name isEqualToString:@"keyId"]) {
                [model setKeyId:[rs longForColumn:obj.name]];
            }else
                [obj setAttributeWithModel:model res:rs];
        }];
        [list addObject:model];
    }
    
    return list.copy;
}

- (void)save:(NSObject *)model {
    FyModelInfo* info = [[model class] getModelInfo];
    
    __block NSString* sql = [NSString stringWithFormat:@"insert into %@(",[[model class] getTableName]];
    
    NSMutableArray* propertyList = [NSMutableArray array];
    NSMutableArray* valueList = [NSMutableArray array];
    [info.propertyList enumerateObjectsUsingBlock:^(FyModelProperty * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.autoIncrement) {
            [propertyList addObject:obj.name];
            if ([obj.dbType isEqualToString:DB_TEXT])
                if ([obj.mapTyep isEqualToString:MODEL_MODEL]) {
                    [valueList addObject:[NSString stringWithFormat:@"\'%@\'",[FyUtils transModelToString:model]]];
                }else {
                    [valueList addObject:[NSString stringWithFormat:@"\'%@\'",[model valueForKey:obj.name]]];
                }
            else {
                if ([model valueForKey:obj.name]) {
                    [valueList addObject:[model valueForKey:obj.name]];
                }else
                    [valueList addObject:@"\'\'"];
            }
        }
    }];
    
    [propertyList enumerateObjectsUsingBlock:^(NSString*  _Nonnull str, NSUInteger idx, BOOL * _Nonnull stop) {
        sql = [sql stringByAppendingString:[NSString stringWithFormat:@"%@,",str]];
    }];
    sql = [sql substringToIndex:sql.length - 1];
    sql = [sql stringByAppendingString:@") values("];
    
    [valueList enumerateObjectsUsingBlock:^(NSString*  _Nonnull str, NSUInteger idx, BOOL * _Nonnull stop) {
        sql = [sql stringByAppendingString:[NSString stringWithFormat:@"%@,",str]];
    }];
    sql = [sql substringToIndex:sql.length - 1];
    sql = [sql stringByAppendingString:@")"];
    
    if (![self.db executeUpdate:sql]) {
        [self dbLog:@"添加数据失败"];
    }
}

#pragma mark - tools
- (BOOL)openDB {
    BOOL res = [self.db open];
    if (!res)
        [self dbLog:@"打开数据库失败"];
    
    return res;
}

- (BOOL)closeDB {
    BOOL res = [self.db close];
    if (!res)
        [self dbLog:@"关闭数据库失败"];
    
    return res;
}

- (void)dbLog:(NSString*)msg {
    if (self.debug)
        FYLog(@"%@",msg);
}

#pragma mark - setter
- (void)setDebug:(BOOL)debug {
    _debug = debug;
}

#pragma mark - getter
- (NSString *)path {
    if (!_path) {
        _path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        _path = [_path stringByAppendingPathComponent:@"db/db.sqlite"];
    }
    return _path;
}

@end
