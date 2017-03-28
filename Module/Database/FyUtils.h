//
//  FyUtils.h
//  MyPlane
//
//  Created by fan on 16/8/17.
//  Copyright © 2016年 fan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <FMDB/FMDB.h>

/************************************
 *  DB 类型
 ************************************/
static NSString* const DB_TEXT      =   @"text";
static NSString* const DB_INT       =   @"integer";
static NSString* const DB_FLOAT     =   @"float";
static NSString* const DB_BLOB      =   @"blob";
static NSString* const DB_CHAR      =   @"char";
static NSString* const DB_DOUBLE    =   @"double";
static NSString* const DB_NVARCHAR  =   @"nvarchar";
static NSString* const DB_VARCHAR   =   @"varchar";

/************************************
 *  model-map 类型
 ************************************/
static NSString* const MODEL_STRING     =   @"string";
static NSString* const MODEL_STRUCE     =   @"struct";
static NSString* const MODEL_BASE       =   @"base";
static NSString* const MODEL_MODEL       =   @"model";

@interface FyUtils : NSObject {
    
}

+ (void)getPropertyType:(const char *)attribute type:(NSString**)type mapType:(NSString**)mapType;

/**
    默认转化：
    int                         ----- >    int
    float                       ----- >    float
    UIImage                     ----- >    图片路径
    NSData                      
    NSDate
    其余：                       ----- >    text
 */
+ (NSString*)getDbPropertyTyep:(NSString*)type;


+ (NSString*)transModelToString:(NSObject*)obj;
+ (NSObject*)transStringToModel:(NSString*)str;


@end

@interface FyModelProperty : NSObject
@property (nonatomic, copy, readonly) NSString* type;
@property (nonatomic, copy, readonly) NSString* name;
@property (nonatomic, copy, readonly) NSString* mapTyep;
@property (nonatomic, copy, readonly) NSString* dbType;
@property (nonatomic, copy, readonly) NSString* dbName;
@property (nonatomic) BOOL notNull;
@property (nonatomic) BOOL unique;
@property (nonatomic) BOOL autoIncrement;                   //主键为int, float基本类型时有效，有效时默认为YES
@property (nonatomic, copy) NSString* defaultValue;

+ (instancetype)propertyWithObjcProperty:(objc_property_t)property;

- (void)setAttributeWithModel:(NSObject*)model res:(FMResultSet*)res;

@end

@interface FyModelInfo : NSObject
@property (nonatomic, readonly) Class modelClass;
@property (nonatomic, strong, readonly) NSArray<FyModelProperty*>* propertyList;

- (instancetype)initWithModel:(Class)modelClass;

- (FyModelProperty*)getProperty:(NSString*)name;

@end
