//
//  FyUtils.m
//  MyPlane
//
//  Created by fan on 16/8/17.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "FyUtils.h"
#import "NSObject+FyDatabase.h"

@implementation FyUtils

+ (void)getPropertyType:(const char *)attribute type:(NSString**)type mapType:(NSString**)mapType {
    NSString* propertyType = [NSString stringWithFormat:@"%s",attribute];
    
    NSString* propertyClassName = nil;
    if ([propertyType hasPrefix:@"T@"]) {
        NSRange range = [propertyType rangeOfString:@","];
        if(range.location > 4 && range.location <= propertyType.length) {
            range = NSMakeRange(3,range.location - 4);
            propertyClassName = [propertyType substringWithRange:range];
            if([propertyClassName hasSuffix:@">"]) {
                NSRange categoryRange = [propertyClassName rangeOfString:@"<"];
                if (categoryRange.length>0) {
                    propertyClassName = [propertyClassName substringToIndex:categoryRange.location];
                }
            }
        }
        if ([propertyClassName isEqualToString:@"NSString"])
            *mapType = MODEL_STRING;
        else
            *mapType = MODEL_MODEL;
    }
    else if([propertyType hasPrefix:@"T{"]) {
        NSRange range = [propertyType rangeOfString:@"="];
        if(range.location > 2 && range.location <= propertyType.length)
        {
            range = NSMakeRange(2, range.location-2);
            propertyClassName = [propertyType substringWithRange:range];
        }
        *mapType = MODEL_STRUCE;
    }
    else {
        propertyType = [propertyType lowercaseString];
        if ([propertyType hasPrefix:@"ti"] || [propertyType hasPrefix:@"tb"]) {
            propertyClassName = @"int";
        }
        else if ([propertyType hasPrefix:@"tf"]) {
            propertyClassName = @"float";
        }
        else if([propertyType hasPrefix:@"td"]) {
            propertyClassName = @"double";
        }
        else if([propertyType hasPrefix:@"tl"] || [propertyType hasPrefix:@"tq"]) {
            propertyClassName = @"long";
        }
        else if ([propertyType hasPrefix:@"tc"]) {
            propertyClassName = @"char";
        }
        else if([propertyType hasPrefix:@"ts"]) {
            propertyClassName = @"short";
        }
        *mapType = MODEL_BASE;
    }
    
    *type = propertyClassName;
}

// 数据类型映射到数据库字段
+ (NSString *)getDbPropertyTyep:(NSString *)type {
    NSString* dbType = nil;
    if ([type isEqualToString:@"float"]) {
        dbType = DB_FLOAT;
    }else if ([type isEqualToString:@"int"]) {
        dbType = DB_INT;
    }else if ([type isEqualToString:@"double"]) {
        dbType = DB_DOUBLE;
    }else {
        dbType = DB_TEXT;
    }
    
    return dbType;
}

+ (NSString *)transModelToString:(NSObject *)obj {
    return nil;
}

+ (NSObject *)transStringToModel:(NSString *)str {
    return nil;
}

@end

@interface FyModelProperty () {

}
@property (nonatomic, copy) NSString* type;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* dbType;
@property (nonatomic, copy) NSString* dbName;
@property (nonatomic, copy) NSString* mapTyep;

@end

@implementation FyModelProperty

+ (instancetype)propertyWithObjcProperty:(objc_property_t)property {
    FyModelProperty* pro = [[FyModelProperty alloc] init];
    pro.dbName = pro.name = [NSString stringWithFormat:@"%s",property_getName(property)];
    NSString* type, *mapType;
    [FyUtils getPropertyType:property_getAttributes(property) type:&type mapType:&mapType];
    pro.type = type;
    pro.mapTyep = mapType;
    pro.dbType = [FyUtils getDbPropertyTyep:pro.type];

    return pro;
}

- (void)setAttributeWithModel:(NSObject *)model res:(FMResultSet *)res {
    if ([self.mapTyep isEqualToString:MODEL_BASE]) {
        if ([self.dbType isEqualToString:DB_INT]) {
            [model setValue:@([res intForColumn:self.dbName]) forKey:self.name];
        }else if ([self.dbType isEqualToString:DB_FLOAT] ||
                  [self.dbType isEqualToString:DB_DOUBLE]) {
            [model setValue:@([res doubleForColumn:self.dbName]) forKey:self.name];
        }
    }else if ([self.mapTyep isEqualToString:MODEL_STRUCE]) {
        
    }else if ([self.mapTyep isEqualToString:MODEL_STRING]) {
        [model setValue:[res stringForColumn:self.dbName] forKey:self.name];
    }else if ([self.mapTyep isEqualToString:MODEL_MODEL]) {
        
    }
}

@end

@interface FyModelInfo () {
    
}
@property (nonatomic, strong) NSArray<FyModelProperty*>* propertyList;
@end

@implementation FyModelInfo

- (instancetype)initWithModel:(Class )modelClass {
    if (self = [super init]) {
        _modelClass = modelClass;
        NSMutableArray* array = [NSMutableArray array];
        
        unsigned int count;
        objc_property_t *properties = class_copyPropertyList(modelClass, &count);
        for(int i = 0; i < count; i++) {
            objc_property_t property = properties[i];
            FyModelProperty* pro = [FyModelProperty propertyWithObjcProperty:property];
            [modelClass setColumnAttributeWithProporty:pro];
            [array addObject:pro];
        }
        
        self.propertyList = array.copy;
        [self setUpKey];
        free(properties);
    }
    return self;
}

- (FyModelProperty *)getProperty:(NSString *)name {
    __block FyModelProperty* property = nil;
    [self.propertyList enumerateObjectsUsingBlock:^(FyModelProperty * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name isEqualToString:name]) {
            property = obj;
            *stop = YES;
        }
    }];
    
    return property;
}

- (void)setUpKey {
    FyModelProperty* property = [self getProperty:[self.modelClass getKey]];
    if (property) {
        if ([property.dbType isEqualToString:@"text"]) {
            // 主键长度必须确定，不能为空，如果不是number类型，不能自增长
            property.dbType = @"varchar(30)";
            property.notNull = YES;
            property.autoIncrement = NO;
        }
        return;
    }
    
    property = [[FyModelProperty alloc] init];
    property.type = @"NSInteger";
    property.name = @"keyId";
    property.dbType = DB_INT;
    property.mapTyep = MODEL_BASE;
    property.dbName = @"keyId";
    property.notNull = YES;
    property.unique = YES;
    property.autoIncrement = YES;
    
    NSMutableArray* array = [NSMutableArray arrayWithArray:self.propertyList];
    [array insertObject:property atIndex:0];
    self.propertyList = array.copy;
}

@end