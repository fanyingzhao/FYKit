//
//  FYTextField.m
//  FFKit
//
//  Created by fan on 16/8/22.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "FYTextField.h"

static const CGFloat errorImageWith     = 24;
static const CGFloat errorImageMargin   = 0;

static void* FYTextFieldText     = &FYTextFieldText;
#define VAIFY_SUCCESS_IMAGE      @"ic_input_validation_ok"
#define VAIFY_FAILURE_IMAGE      @"ic_input_validation_fail"

@interface FYTextField () {
    CGRect _textFieldRect;
}
@property (nonatomic, strong) UIImageView* errorImage;
@end

@implementation FYTextField

- (instancetype)initWithFrame:(CGRect)frame options:(FYTextFieldOptions)options {
        if (options & FYTextFieldOptionsFuncNone) {
            
        }else if (options & FYTextFieldOptionsFuncNoneVerify) {
            [self addVerify];
        }else if (options & FYTextFieldOptionsFuncNoneSearch) {
            
        }else if (options & FYTextFieldOptionsFuncNoneInputFormat) {
            
        }else if ((options & FYTextFieldOptionsPlaceholderCommon) == FYTextFieldOptionsPlaceholderCommon) {
            
        }else if ((options & FYTextFieldOptionsPlaceholder3D) == FYTextFieldOptionsPlaceholder3D) {
            
        }else if ((options & FYTextFieldOptionsPlaceholderMoveUp) == FYTextFieldOptionsPlaceholderMoveUp) {
            
        }
    
    if (self = [super initWithFrame:frame]) {
        _textFieldRect = frame;
        [self setUp];
    }
    return self;
}

#pragma mark - init
- (void)setUp {
    self.promptStyle = FYTextFieldErrorPromptStyleErrorImage;
    
    [self addErrorImage];
}

- (void)addVerify {
    [self addTarget:self action:@selector(verfiyInput) forControlEvents:UIControlEventEditingChanged];
}

- (void)addErrorImage {
    self.errorImage = [[UIImageView alloc] initWithFrame: ({
        CGRect rect;
        rect.size.width = rect.size.height = errorImageWith;
        rect.origin.x = CGRectGetWidth(self.bounds) - errorImageWith - errorImageMargin;
        rect.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(rect)) / 2;
        rect;
    })];
    [self addSubview:self.errorImage];
}

#pragma mark - overwrite
- (void)setFrame:(CGRect)frame {
    
    [super setFrame:frame];
}

- (BOOL)becomeFirstResponder {
    [self editBegin];
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    [self editEnd];
    return [super resignFirstResponder];
}

#pragma mark - tools
- (void)editBegin {
    if (self.verifyWhileEndEdit) {
        self.errorImage.hidden = YES;
    }
}

- (void)editEnd {
    if (self.verifyWhileEndEdit) {
        self.errorImage.hidden = NO;
        [self verfiyInput];
    }
}

- (void)verfiyInput {
    // 验证正则表达式
    NSError* error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:self.verifyString options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:self.text options:0 range:NSMakeRange(0, [self.text length])];
    if (result) {
        self.verifySuccess = YES;
    }else {
        self.verifySuccess = NO;
    }
    [self showPrompt];
}

#pragma mark - prompt
- (void)showWithShake {
    
}

- (void)showWithErrorImage {
    if (self.text && ![self.text isEqualToString:@""])
        self.errorImage.hidden = NO;
    else
        self.errorImage.hidden = YES;
    
    if (self.verifySuccess)
        self.errorImage.image = [UIImage imageNamed:VAIFY_SUCCESS_IMAGE];
    else
        self.errorImage.image = [UIImage imageNamed:VAIFY_FAILURE_IMAGE];
}

- (void)showWithBorder {
    
}

#pragma mark - funcs
- (void)showPrompt {
    [self showPromptWithPromptStyle:self.promptStyle];
}

- (void)showPromptWithPromptStyle:(FYTextFieldErrorPromptStyle)promptStyel {
    switch (promptStyel) {
        case FYTextFieldErrorPromptStyleShake: {
            [self showWithShake];
        }
            break;
        case FYTextFieldErrorPromptStyleErrorImage: {
            [self showWithErrorImage];
        }
            break;
        case FYTextFieldErrorPromptStyleErrorBorder: {
            [self showWithBorder];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - setter
- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    _placeholderFont = placeholderFont;
    [self setValue:placeholderFont forKey:@"_placeholderLabel.font"];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    [self setValue:placeholderColor forKey:@"_placeholderLabel.textColor"];
}

- (void)setVerifyWhileEndEdit:(BOOL)verifyWhileEndEdit {
    _verifyWhileEndEdit = verifyWhileEndEdit;
    
    if (verifyWhileEndEdit) {
        self.errorImage.hidden = NO;
        [self removeTarget:self action:@selector(verfiyInput) forControlEvents:UIControlEventEditingChanged];
    }
}

#pragma mark - getter

@end
