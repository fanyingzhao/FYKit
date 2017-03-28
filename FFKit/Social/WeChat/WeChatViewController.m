//
//  WeChatViewController.m
//  FFKit
//
//  Created by fan on 16/7/28.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "WeChatViewController.h"
#import "WeChatManager.h"

@interface WeChatViewController ()

@end

@implementation WeChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

#pragma mark - events
- (IBAction)autoLoginBtnClick:(id)sender {
    [[WeChatManager sharedWechatManager] sendAutoRequest];
}

- (IBAction)shareBtnClick:(id)sender {
    [[WeChatManager sharedWechatManager] showShareView];
    [WeChatManager sharedWechatManager].btnClick = ^(ShareType type) {
        WeChatShareDataText* data = [[WeChatShareDataText alloc] init];
        data.text = @"孩儿们，来巡山了";
        [[WeChatManager sharedWechatManager] shareToWX:data type:type];
    };
}

@end
