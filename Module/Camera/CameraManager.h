//
//  CameraManager.h
//  FaceU
//
//  Created by fan on 16/11/4.
//  Copyright © 2016年 fan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^ImageHandleBlock)(UIImage *image);

@interface CameraManager : NSObject {
    
}
@property (nonatomic, strong) AVCaptureSession* session;
@property (nonatomic, strong) AVCaptureConnection* connection;
@property (nonatomic, strong) AVCaptureDevice* device;
@property (nonatomic, strong) AVCaptureDeviceInput* input;
@property (nonatomic, strong) AVCaptureOutput* output;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* previewLayer;
/**
 是否显示照相机视图，默认为YES
 */
@property (nonatomic) BOOL autoPreview;
/**
 浏览视图，如果 autoPreview 为YES，则必须提供
 */
@property (nonatomic, weak) UIView* attachPreview;

@property (nonatomic, readonly) AVCaptureDevicePosition type;

@property (nonatomic, weak) id<AVCaptureVideoDataOutputSampleBufferDelegate> delegate;


- (instancetype)initWithSession:(AVCaptureSession*)session;

/**
 切换前后摄像头
 */
- (void)toggleCamera;

- (void)updateVideoDirection;

/**
 拍照

 @param handle 完成回调
 */
- (void)shutterCameraWithImageHandle:(ImageHandleBlock)handle;

- (void)start;
- (void)stop;

@end
