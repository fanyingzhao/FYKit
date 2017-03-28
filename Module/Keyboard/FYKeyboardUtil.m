//
//  FYKeyboardUtil.m
//  FFKit
//
//  Created by fan on 16/7/13.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "FYKeyboardUtil.h"
#import "UIViewController+FYAdd.h"
#import "FYMacro.h"
#import "NSMutableArray+FYAdd.h"
#import "NSObject+FYAdd.h"

@implementation KeyboardInfo

- (instancetype)initWithAnimationDuration:(CGFloat)duration originFrame:(CGRect)originFrame endFrame:(CGRect)endFrame {
    if (self = [super init]) {
        _animationDuration = duration;
        _originFrame = originFrame;
        _endFrame = endFrame;
    }
    return self;
}

@end

@interface FYKeyboardUtil () {
    CGRect _originRect;
    KeyboardInfo* _keyboardInfo;
    BOOL _isOffsetd;                        // 是否已经发生了偏移
    
    __weak UIView* _firstResponseView;
    __weak UIView* _activityView;
}
@property (nonatomic, copy) FYKeyboardAppear keyboardAppearBlock;
@property (nonatomic, copy) FYKeyboardDisappear keyboardDisappearBlock;
@end

@implementation FYKeyboardUtil

#pragma mark - lifecircle
+ (void)load {
    [[FYKeyboardUtil sharedKeyboardUtil] addNotification];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - init
+ (instancetype)sharedKeyboardUtil {
    static FYKeyboardUtil* keyboardUtilInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        keyboardUtilInstance = [[FYKeyboardUtil alloc] init];
        keyboardUtilInstance->_shouldAutoManager = YES;
        keyboardUtilInstance->_shouldHiddenKeyboardWhildClick = YES;
        keyboardUtilInstance->_shouldChangeWhileEditing = YES;
        keyboardUtilInstance->_offset = 5;
    });
    return keyboardUtilInstance;
}

#pragma mark - noitfication
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification*)noti {
    _keyboardInfo = [self getKeyboardInfoByKeyboardNotification:noti];
    
    // 两个输入源切换
    if (_isOffsetd) {
        [self animationWhileKeyboardShow];
        return;
    }
    
    if (!self.shouldAutoManager || _keyboardAppearBlock) {
        if (self.keyboardAppearBlock) {
            self.keyboardAppearBlock(nil,_keyboardInfo,NO);
        }
        
        return ;
    }
    
    if (self.shouldHiddenKeyboardWhildClick) {
        [[UIViewController getActivityViewController].view addSubview:self.backgroundView];
    }
    
    _firstResponseView = [self getFirstResponse:nil];
    if (!_firstResponseView) {
        FYLog(@"第一响应者查找失败");
        return ;
    }
    
    // 添加键盘事件
    if (self.shouldChangeWhileEditing) {
        [self addTextChangedListener];
    }
    
    _activityView = [UIViewController getActivityViewController].view;
    _originRect = _activityView.frame;
    
    [self animationWhileKeyboardShow];
}

- (void)keyboardDidShow:(NSNotification*)noti {
    _isOffsetd = YES;

    KeyboardInfo* keyboardInfo = [self getKeyboardInfoByKeyboardNotification:noti];
}

- (void)keyboardWillHide:(NSNotification*)noti {
    KeyboardInfo* keyboardInfo = [self getKeyboardInfoByKeyboardNotification:noti];
    if (!self.shouldAutoManager || _keyboardDisappearBlock) {
        if (self.keyboardDisappearBlock) {
            self.keyboardDisappearBlock(keyboardInfo,NO);
        }
        
        return ;
    }
    
    if (self.shouldChangeWhileEditing) {
        [self removeTextChangedListener];
    }
    
    if (self.shouldHiddenKeyboardWhildClick) {
        [self.backgroundView removeFromSuperview];
    }
    
    [UIView animateWithDuration:keyboardInfo.animationDuration animations:^{
        _activityView.frame = _originRect;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)keyboardDidHide:(NSNotification*)noti {
    _isOffsetd = NO;

    KeyboardInfo* keyboardInfo = [self getKeyboardInfoByKeyboardNotification:noti];

    _firstResponseView = nil;
}

#pragma mark - text
- (void)addTextChangedListener {
    if ([_firstResponseView isKindOfClass:[UITextView class]]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextViewTextDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textBeginEdit:) name:UITextViewTextDidBeginEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textEndEdit:) name:UITextViewTextDidEndEditingNotification object:nil];
    }else if ([_firstResponseView isKindOfClass:[UITextField class]]) {
        [((UITextField*)_firstResponseView) addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
        [((UITextField*)_firstResponseView) addTarget:self action:@selector(textBeginEdit:) forControlEvents:UIControlEventEditingDidBegin];
        [((UITextField*)_firstResponseView) addTarget:self action:@selector(textEndEdit:) forControlEvents:UIControlEventEditingDidEnd];
    }
}

- (void)removeTextChangedListener {
    if ([_firstResponseView isKindOfClass:[UITextView class]]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidBeginEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidEndEditingNotification object:nil];
    }
}

- (void)textBeginEdit:(NSNotification*)noti {
    
}

- (void)textChange:(NSNotification*)noti {
    CGRect convertRect = [self.attachView.superview convertRect:self.attachView.frame toView:[[UIApplication sharedApplication] keyWindow]];
    
    if (CGRectGetMinY(_keyboardInfo.endFrame) - self.offset < CGRectGetMaxY(convertRect)) {
        [UIView animateWithDuration:_keyboardInfo.animationDuration animations:^{
            _activityView.frame = ({
                CGRect rect;
                rect.size = _activityView.frame.size;
                rect.origin.x = CGRectGetMinX(_activityView.frame);
                rect.origin.y = CGRectGetMinY(_activityView.frame) - (CGRectGetMaxY(convertRect) - CGRectGetMinY(_keyboardInfo.endFrame) + self.offset);
                rect;
            });
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)textEndEdit:(NSNotification*)noti {
    
}

#pragma mark - events
- (void)tapClick:(UITapGestureRecognizer*)tap {
    [_firstResponseView resignFirstResponder];
}

#pragma mark - tools
- (KeyboardInfo*)getKeyboardInfoByKeyboardNotification:(NSNotification*)noti {
    NSDictionary* keyboardInfo = [noti userInfo];
    CGRect originFrame = [[keyboardInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endFrame = [[keyboardInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[keyboardInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    return [[KeyboardInfo alloc] initWithAnimationDuration:duration originFrame:originFrame endFrame:endFrame];
}

- (void)animationWhileKeyboardShow {
    // 如果已经产生了偏移，重新计算偏移
    if (_isOffsetd) {
        CGRect convertRect = [self.attachView.superview convertRect:self.attachView.frame toView:[[UIApplication sharedApplication] keyWindow]];
        
        if (CGRectGetMinY(_keyboardInfo.endFrame) - self.offset < CGRectGetMaxY(convertRect)) {
            [UIView animateWithDuration:_keyboardInfo.animationDuration animations:^{
                _activityView.frame = ({
                    CGRect rect;
                    rect.size = _activityView.frame.size;
                    rect.origin.x = CGRectGetMinX(_activityView.frame);
                    rect.origin.y = CGRectGetMinY(_activityView.frame) - (CGRectGetMaxY(convertRect) - CGRectGetMinY(_keyboardInfo.endFrame) + self.offset);
                    rect;
                });
            } completion:^(BOOL finished) {
                
            }];
        }else if (CGRectGetMinY(_keyboardInfo.endFrame) - self.offset > CGRectGetMaxY(convertRect) + CGRectGetMinY(_activityView.frame)) {
            // 将第一次的偏移还原
            if (CGRectGetMinY(_keyboardInfo.endFrame) - self.offset + ABS(CGRectGetMinY(_activityView.frame)) > CGRectGetMaxY(convertRect)) {
                [UIView animateWithDuration:_keyboardInfo.animationDuration animations:^{
                    _activityView.frame = ({
                        CGRect rect;
                        rect.size = _activityView.frame.size;
                        rect.origin.x = CGRectGetMinX(_originRect);
                        rect.origin.y = CGRectGetMinY(_originRect);
                        rect;
                    });
                } completion:^(BOOL finished) {
                    
                }];
            }
        }
    }else {
        CGRect convertRect = [self.attachView.superview convertRect:self.attachView.frame toView:[[UIApplication sharedApplication] keyWindow]];
        
        if (CGRectGetMinY(_keyboardInfo.endFrame) - self.offset < CGRectGetMaxY(convertRect)) {
            [UIView animateWithDuration:_keyboardInfo.animationDuration animations:^{
                _activityView.frame = ({
                    CGRect rect;
                    rect.size = _activityView.frame.size;
                    rect.origin.x = CGRectGetMinX(_activityView.frame);
                    rect.origin.y = CGRectGetMinY(_activityView.frame) - (CGRectGetMaxY(convertRect) - CGRectGetMinY(_keyboardInfo.endFrame) + self.offset);
                    rect;
                });
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}

- (UIView*)getFirstResponse:(UIView*)view {
    if (!view) {
        view = [UIViewController getActivityViewController].view;
    }
    
    if ([view isFirstResponder]) {
        return view;
    }
    
    for (UIView* obj in view.subviews) {
        UIView* temp = [self getFirstResponse:obj];
        if (temp) return temp;
    }
    
    return nil;
}

#pragma mark - gesture

#pragma mark - funcs
- (void)setAppearBlockWhenKeyboardAppear:(FYKeyboardAppear)keyboardAppearBlock {
    _keyboardAppearBlock = keyboardAppearBlock;
}

- (void)setDisappearBlockWhenKeyboardDisappear:(FYKeyboardDisappear)keyboardDisappearBlock {
    _keyboardDisappearBlock = keyboardDisappearBlock;
}

#pragma mark - getter
- (UIView *)attachView {
    if (!_attachView) {
        return _firstResponseView;
    }
    
    return _attachView;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [_backgroundView addGestureRecognizer:tap];
    }
    return _backgroundView;
}

@end
