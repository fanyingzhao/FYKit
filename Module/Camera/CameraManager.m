//
//  CameraManager.m
//  FaceU
//
//  Created by fan on 16/11/4.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "CameraManager.h"
#import "FYMacro.h"
#import "AVCaptureDevice+FYAdd.h"

@interface CameraManager () {
    
}

@end

@implementation CameraManager

- (instancetype)init {
    return [self initWithSession:nil];
}

- (instancetype)initWithSession:(AVCaptureSession *)session {
    if (self = [super init]) {
        _session = session;
        if (!_session) {
            _session = [[AVCaptureSession alloc] init];
            _session.sessionPreset = AVCaptureSessionPresetiFrame1280x720;

            _type = AVCaptureDevicePositionFront;
            self.autoPreview = YES;
            
            [self addInput];
        }
    }
    return self;
}

#pragma mark - tools
- (void)addInput {
    self.device = [AVCaptureDevice getDevice:_type mediaType:AVMediaTypeVideo];
    self.input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:nil];
    
    if ([self.session canAddInput:self.input]) {
        [self.session beginConfiguration];
        [self.session addInput:self.input];
        [self.session commitConfiguration];
    }else {
        FYLog(@"无法添加输入源:%@",self.input.description);
    }
}

- (AVCaptureVideoOrientation)videoOrientationFromDeviceOrientation:(UIDeviceOrientation)deviceOrientation {
    AVCaptureVideoOrientation orientation;
    switch (deviceOrientation) {
        case UIDeviceOrientationUnknown:
            orientation = AVCaptureVideoOrientationPortrait;
            break;
        case UIDeviceOrientationPortrait:
            orientation = AVCaptureVideoOrientationPortrait;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            orientation = AVCaptureVideoOrientationPortraitUpsideDown;
            break;
        case UIDeviceOrientationLandscapeLeft:
            orientation = AVCaptureVideoOrientationLandscapeRight;
            break;
        case UIDeviceOrientationLandscapeRight:
            orientation = AVCaptureVideoOrientationLandscapeLeft;
            break;
        case UIDeviceOrientationFaceUp:
            orientation = AVCaptureVideoOrientationPortrait;
            break;
        case UIDeviceOrientationFaceDown:
            orientation = AVCaptureVideoOrientationPortrait;
            break;
    }
    return orientation;
}


- (void)addOutput {
    if (self.autoPreview) {
        self.output = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary* outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
        [((AVCaptureStillImageOutput*)self.output) setOutputSettings:outputSettings];
    }else {
        self.output = [[AVCaptureVideoDataOutput alloc] init];
        ((AVCaptureVideoDataOutput*)self.output).alwaysDiscardsLateVideoFrames = true;
        ((AVCaptureVideoDataOutput*)self.output).videoSettings = @{(id)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_32BGRA)};
        dispatch_queue_t metadataQueue = dispatch_queue_create("com.fyz.cameraManager", DISPATCH_QUEUE_SERIAL);
        [((AVCaptureVideoDataOutput*)self.output) setSampleBufferDelegate:self.delegate queue:metadataQueue];
    }
    
    if ([self.session canAddOutput:self.output]) {
        [self.session beginConfiguration];
        [self.session addOutput:self.output];
        [self.session commitConfiguration];
    }else {
        FYLog(@"无法添加输入源:%@",self.output.description);
    }
}

#pragma mark - funcs
- (void)toggleCamera {
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    if (cameraCount > 1) {
        NSError *error;
        AVCaptureDeviceInput *newVideoInput;
        AVCaptureDevicePosition position = [[self.input device] position];
        
        if (position == AVCaptureDevicePositionBack)
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[AVCaptureDevice getFrontCamera] error:&error];
        else if (position == AVCaptureDevicePositionFront)
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[AVCaptureDevice getBackCamera] error:&error];
        else
            return;
        
        if (newVideoInput != nil) {
            [self.session beginConfiguration];
            [self.session removeInput:self.input];
            if ([self.session canAddInput:newVideoInput]) {
                [self.session addInput:newVideoInput];
                self.input = newVideoInput;
            } else {
                [self.session addInput:self.input];
            }
            [self.session commitConfiguration];
        } else if (error) {
            FYLog(@"toggle carema failed, error = %@", error);
        }
    }
}

- (void)start {
    if (self.session && self.session.isRunning == NO) {
        [self.session startRunning];
        
        if (self.autoPreview) {
            self.previewLayer.frame = self.attachPreview.bounds;
            [self.attachPreview.layer addSublayer:self.previewLayer];
        }else {
            [self.previewLayer removeFromSuperlayer];
            self.previewLayer = nil;
        }
    }
}

- (void)stop {
    if (self.session && self.session.isRunning == YES) {
        [self.session stopRunning];
    }
}

- (void)shutterCameraWithImageHandle:(ImageHandleBlock)handle {
    AVCaptureConnection * videoConnection = [self.output connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        FYLog(@"take photo failed!");
        return;
    }
    
    [(AVCaptureStillImageOutput*)self.output captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage * image = [UIImage imageWithData:imageData];
        
        if (image) {
            handle(image);
        } else {
            FYLog(@"Error:Fail to handle image with shutter!");
        }
    }];
}

- (void)updateVideoDirection {
    [self.session beginConfiguration];
    self.connection = [self.output connectionWithMediaType:AVMediaTypeVideo];
    self.connection.videoOrientation = [self videoOrientationFromDeviceOrientation:[UIDevice currentDevice].orientation];
    self.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
    [self.session commitConfiguration];
}

#pragma mark - setter
- (void)setAutoPreview:(BOOL)autoPreview {
    if (_autoPreview == autoPreview) {
        return;
    }
    
    _autoPreview = autoPreview;
    
    if (self.output) {
        [self.session beginConfiguration];
        [self.session removeOutput:self.output];
        [self.session commitConfiguration];
    }
    
    [self addOutput];
}

#pragma mark - getter
- (AVCaptureVideoPreviewLayer *)previewLayer {
    if (!_previewLayer) {
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return _previewLayer;
}


@end
