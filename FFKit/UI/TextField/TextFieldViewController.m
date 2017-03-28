//
//  TextFieldViewController.m
//  FFKit
//
//  Created by fan on 16/8/22.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "TextFieldViewController.h"
#import "FYTextField.h"

@interface TextFieldViewController () {
    FYTextField* _field;
}

@end

@implementation TextFieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
     _field = [[FYTextField alloc] initWithFrame: ({
        CGRect rect;
        rect.origin.x = 10;
        rect.origin.y = 80;
        rect.size.width = CGRectGetWidth(self.view.bounds) - CGRectGetMinX(rect) * 2;
        rect.size.height = 30;
        rect;
    }) options:FYTextFieldOptionsFuncNoneVerify];
    _field.backgroundColor = [UIColor orangeColor];
    _field.verifyWhileEndEdit = YES;
    _field.verifyString = @"^[0-9]*$";
    [self.view addSubview:_field];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_field resignFirstResponder];
}

@end
