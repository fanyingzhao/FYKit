//
//  AVCaptureDevice+FYAdd.m
//  FaceU
//
//  Created by fan on 16/11/4.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "AVCaptureDevice+FYAdd.h"

@implementation AVCaptureDevice (FYAdd)

+ (AVCaptureDevice *)getFrontCamera {
    return [self getDevice:AVCaptureDevicePositionFront mediaType:AVMediaTypeVideo];
}

+ (AVCaptureDevice *)getBackCamera {
    return [self getDevice:AVCaptureDevicePositionBack mediaType:AVMediaTypeVideo];
}

+ (AVCaptureDevice *)getDevice:(AVCaptureDevicePosition)position mediaType:(NSString *)mediaType {
    NSArray* devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    for (AVCaptureDevice* device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

- (void)setFlashMode:(AVCaptureFlashMode)mode {
    if ([self lockForConfiguration:nil]) {
        if ([self isFlashModeSupported:mode]) {
            [self setFlashMode:mode];
        }
        [self unlockForConfiguration];
    }
}

- (void)setNightModel:(AVCaptureDevice *)device {
    if ([device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
        [device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
    }
    
    if ([device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
        [device setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
    }
}

@end
