//
//  FYCache.m
//  FFKit
//
//  Created by fan on 16/7/9.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "FYCache.h"
#import <UIKit/UIKit.h>

@implementation FYCache

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllObjects) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clean) name:UIApplicationWillTerminateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clean) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

@end
