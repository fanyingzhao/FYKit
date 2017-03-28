//
//  FYUtility.m
//  FFKit
//
//  Created by fan on 16/12/1.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "FYUtility.h"

#define FIRST_USE       @"first_use"

void runOnMainQueue(void (^block)(void)) {
    if ([NSThread isMainThread]) {
        block();
    }
    else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

float getRunCosttime(void (^block)(void), bool isPrint) {
    CFAbsoluteTime elapsedTime, startTime = CFAbsoluteTimeGetCurrent();
    if (block) {
        block();
    }
    elapsedTime = CFAbsoluteTimeGetCurrent() - startTime;
    return elapsedTime * 1000.0;
}

@implementation FYUtility

+ (BOOL)checkIsFirstUse {
    BOOL res = [[NSUserDefaults standardUserDefaults] boolForKey:FIRST_USE];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:FIRST_USE];
    
    return !res;
}

@end
