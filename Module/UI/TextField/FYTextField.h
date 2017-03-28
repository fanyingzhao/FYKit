//
//  FYTextField.h
//  FFKit
//
//  Created by fan on 16/8/22.
//  Copyright © 2016年 fan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, FYTextFieldOptions) {
    FYTextFieldOptionsFuncNone                       = 1 << 8,
    FYTextFieldOptionsFuncNoneVerify                 = 1 << 9,
    FYTextFieldOptionsFuncNoneSearch                 = 1 << 10,
    FYTextFieldOptionsFuncNoneInputFormat            = 1 << 11,
    
    FYTextFieldOptionsPlaceholderCommon              = 0 << 16,
    FYTextFieldOptionsPlaceholder3D                  = 1 << 16,
    FYTextFieldOptionsPlaceholderMoveUp              = 2 << 16,
};

typedef NS_ENUM(NSInteger, FYTextFieldErrorPromptStyle) {
    FYTextFieldErrorPromptStyleNone,
    FYTextFieldErrorPromptStyleShake,
    FYTextFieldErrorPromptStyleErrorImage,
    FYTextFieldErrorPromptStyleErrorBorder,
};

@interface FYTextField : UITextField {

}

- (instancetype)initWithFrame:(CGRect)frame options:(FYTextFieldOptions)options;

/**
 *  是否在编辑结束时才验证，默认为NO，实时验证
 */
@property (nonatomic, getter=isVerifyWhileEndEdit) BOOL verifyWhileEndEdit;
/**
 *  正则验证是否成功
 */
@property (nonatomic, getter=isVerifySuccess) BOOL verifySuccess;
/**
 *  正则验证, FYTextFieldOptionsFuncNoneVerify 时有效
 */
@property (nonatomic, copy) NSString* verifyString;
/**
 *  验证失败时的提示，默认是 FYTextFieldErrorPromptStyleErrorImage
 */
@property (nonatomic) FYTextFieldErrorPromptStyle promptStyle;

@property (nonatomic, strong) UIFont* placeholderFont;
@property (nonatomic, strong) UIColor* placeholderColor;


- (void)showPrompt;
- (void)showPromptWithPromptStyle:(FYTextFieldErrorPromptStyle)promptStyel;

@end
