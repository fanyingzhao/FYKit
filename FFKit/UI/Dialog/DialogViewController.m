//
//  DialogViewController.m
//  FFKit
//
//  Created by fan on 17/3/14.
//  Copyright © 2017年 fan. All rights reserved.
//

#import "DialogViewController.h"
#import "FYPopView.h"

@interface DialogViewController ()

@end

@implementation DialogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    FYPopView* view = [[FYPopView alloc] initWithFrame:({
        CGRect rect;
        rect.origin.x = 100;
        rect.origin.y = 100;
        rect.size.width = 100;
        rect.size.height = 100;
        rect;
    })];
    view.backgroundColor = [UIColor orangeColor];
    view.attacView = self.view;
    view.options = FYPopAnimationOptionsDrop;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [view show];
    });
    
    UILabel* label = [[UILabel alloc] initWithFrame:({
        CGRect rect;
        rect.origin.x = 100;
        rect.origin.y = 300;
        rect.size.width = 100;
        rect.size.height = 30;
        rect;
    })];
    label.text = @"吃测试吃测试吃测试吃测试";
    label.backgroundColor = [UIColor redColor];
    [self.view addSubview:label];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        FYPopView* view = [[FYPopView alloc] initWithFrame:({
            CGRect rect;
            rect.origin.x = 100;
            rect.origin.y = 100;
            rect.size.width = 100;
            rect.size.height = 100;
            rect;
        })];
        view.backgroundColor = [UIColor orangeColor];
        view.attacView = self.view;
        view.options = FYPopAnimationOptionsDrop;
        [view show];
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
