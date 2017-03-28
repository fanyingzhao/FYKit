//
//  NSObject+FyDatabase.m
//  MyPlane
//
//  Created by fan on 16/8/17.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "NSObject+FyDatabase.h"
#import "NSObject+FYAdd.h"

static void* Database_Key                   = &Database_Key;
static void* Database_ModelInfo             = &Database_ModelInfo;

@implementation NSObject (FyDatabase)

+ (NSString *)getTableName {
    return NSStringFromClass(self);
}

+ (NSString *)getKey {
    return @"keyId";
}

+ (void)setColumnAttributeWithProporty:(FyModelProperty*)property {
    
}

- (void)setKeyId:(NSUInteger)keyId {
    [self setAssociateValue:@(keyId) key:Database_Key];
}

- (NSUInteger)keyId {
    return [[self getAssociatedValueForKey:Database_Key] unsignedIntegerValue];
}


+ (FyModelInfo *)getModelInfo {
    return [[FyModelInfo alloc] initWithModel:self];
}

- (void)save {
    
}

@end
