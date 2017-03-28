//
//  AVCaptureDevice+FYAdd.h
//  FaceU
//
//  Created by fan on 16/11/4.
//  Copyright © 2016年 fan. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AVCaptureDevice (FYAdd)

+ (AVCaptureDevice*)getFrontCamera;
+ (AVCaptureDevice*)getBackCamera;
+ (AVCaptureDevice*)getDevice:(AVCaptureDevicePosition)position mediaType:(NSString*)mediaType;

- (void)setFlashMode:(AVCaptureFlashMode)mode;

- (void)setNightModel:(AVCaptureDevice*)device;

@end
