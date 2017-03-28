//
//  CameraViewController.m
//  FFKit
//
//  Created by fan on 16/7/15.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "CameraViewController.h"
//#import "FYCameraView.h"

@interface CameraViewController () {
//    FYCameraView* _cameraView;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    _cameraView = [[FYCameraView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:_cameraView];
//    [self.view insertSubview:_cameraView atIndex:0];
//    [_cameraView startSession];
}

#pragma mark - events
- (IBAction)takePhotoBtnClick:(id)sender {
//    [_cameraView takePhotoWithHandle:^(UIImage *image, NSError *error) {
//        self.imageView.image = image;
//    }];
}

- (IBAction)toggleCameraBtnClick:(id)sender {
//    [_cameraView toggleCamera:!_cameraView.isBackCamer];
}

@end
