//
//  FYNotificationHelper.h
//  MyPlane
//
//  Created by fan on 16/8/10.
//  Copyright © 2016年 fan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSInteger, NotificationType) {
    NotificationTypeFireDate                  = 0,
    NotificationTypeRegion                    = 1,
};

@interface Action : NSObject
@property (nonatomic, copy) NSString* identifier;
@property (nonatomic, strong) NSMutableArray* actionList;
@end

@interface FYNotificationManager : NSObject {
    
}
@property (nonatomic) NotificationType notificationType;
/**
 *  触发类型为 NotificationTypeRegion 生效
 */
@property (nonatomic, strong) CLRegion* region;
/**
 *  触发类型为 NotificationTypeFireDate 生效
 */
@property (nonatomic, strong) NSDate* fireDate;
/**
 *  内部模型为 Action
 */
@property (nonatomic, strong) NSMutableArray* templateList;

+ (instancetype)manager;

- (void)config;

- (UILocalNotification*)notificationWithAlertBody:(NSString*)alertBody
                                     alertTitle:(NSString*)alertTitle
                               alertLaunchImage:(NSString*)alertLaunchImage;

/**
 *  配置完成之后通过这个方法注册到系统
 */
- (void)registerLocalNotification:(UILocalNotification*)notification immediately:(BOOL)immediately;

@end
