//
//  FYLoadingViewController.m
//  FFKit
//
//  Created by fan on 17/3/7.
//  Copyright © 2017年 fan. All rights reserved.
//

#import "FYLoadingViewController.h"
#import "FYLoadingManager.h"

@interface FYLoadingViewController ()

@end

@implementation FYLoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    FYLoadingManager* manager = [[FYLoadingManager alloc] initWithView:self.view];
//    [manager showLoading];
//    
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        manager.orient = UIDeviceOrientationLandscapeLeft;
//    });
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(100 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [manager hideLoading];
//    });
    
    FYLoadingManager* manager = [FYLoadingManager showLoadingForView:self.view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        manager.orient = UIDeviceOrientationLandscapeLeft;
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [FYLoadingManager hideLoadingForView:self.view];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
