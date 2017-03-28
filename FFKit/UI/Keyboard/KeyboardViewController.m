//
//  KeyboardViewController.m
//  FFKit
//
//  Created by fan on 16/7/14.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "KeyboardViewController.h"
//#import "UITextField+FYKeyboard.h"
//#import "FYTextView.h"

@interface KeyboardViewController ()<UITextViewDelegate>

@end

@implementation KeyboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITextField* field = [[UITextField alloc] initWithFrame:({
        CGRect rect;
        rect.size.width = 100;
        rect.size.height = 22;
        rect.origin.x = 30;
        rect.origin.y = 400;
        rect;
    })];
    field.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:field];
//    field.offset = 20;
    
//    UIView* backView = [[UIView alloc] initWithFrame:({
//        CGRect rect;
//        rect.size.width = 200;
//        rect.size.height = 200;
//        rect.origin.x = 140;
//        rect.origin.y = 400;
//        rect;
//    })];
//    backView.backgroundColor = [UIColor blueColor];
//    [self.view addSubview:backView];
//    UITextField* field2 = [[UITextField alloc] initWithFrame:({
//        CGRect rect;
//        rect.size.width = 100;
//        rect.size.height = 22;
//        rect.origin.x = 0;
//        rect.origin.y = 0;
//        rect;
//    })];
//    field2.backgroundColor = [UIColor whiteColor];
//    [backView addSubview:field2];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
//    
//    FYTextView* textView = [[FYTextView alloc] initWithFrame:({
//        CGRect rect;
//        rect.origin.x = 20;
//        rect.origin.y = 64;
//        rect.size.width = CGRectGetWidth(self.view.bounds) - 40;
//        rect.size.height = CGRectGetHeight(self.view.bounds) - CGRectGetMinY(rect);
//        rect;
//    })];
//    [self.view addSubview:textView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


@end
