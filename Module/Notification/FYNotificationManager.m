//
//  FYNotificationHelper.m
//  MyPlane
//
//  Created by fan on 16/8/10.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "FYNotificationManager.h"

@implementation Action


@end

@implementation FYNotificationManager

- (instancetype)init {
    if (self = [super init]) {

    }
    return self;
}


- (void)config {
    UIUserNotificationType type = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
    NSMutableSet* set = nil;
    
    if (self.notificationType & NotificationTypeFireDate) {
        
    }else if (self.notificationType & NotificationTypeRegion) {
        
    }
    
    [self.templateList enumerateObjectsUsingBlock:^(Action*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray* temp = [NSMutableArray array];
        UIMutableUserNotificationCategory* category = [[UIMutableUserNotificationCategory alloc] init];
        category.identifier = @"";
        [obj.actionList enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIMutableUserNotificationAction* action = [[UIMutableUserNotificationAction alloc] init];
            action.title = obj;
            action.activationMode = UIUserNotificationActivationModeBackground;
            action.authenticationRequired = NO;
            action.destructive = NO;
            action.behavior = UIUserNotificationActionBehaviorTextInput;
            [temp addObject:action];
        }];
        [category setActions:temp forContext:UIUserNotificationActionContextDefault];
        [set addObject:category];
    }];
    
    UIUserNotificationSettings* settings = [UIUserNotificationSettings settingsForTypes:type categories:[NSSet setWithObject:set]];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}

- (void)registerLocalNotification:(UILocalNotification *)notification {
    
}
@end
