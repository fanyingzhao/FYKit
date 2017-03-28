//
//  FYAutoResizeTextField.m
//  TaskManager
//
//  Created by fan on 16/8/30.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "FYTextView.h"

@interface FYTextView () {
    BOOL _isFixed;                   // 是否已经修正过
    BOOL _isMaxHeight;               // 是否到达了最大高度
}
@property (nonatomic) BOOL scrollFlag;
@property (nonatomic) CGFloat autuaHeight;

@end

@implementation FYTextView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _setUp];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self _setUp];
    }
    return self;
}

- (void)dealloc {
    [self removeNotification];
}

#pragma mark - init
- (void)_setUp {
    [self addNotification];
    
    self.autoAdjust = YES;

    self.placeholderLabel = [[UILabel alloc] initWithFrame:({
        CGRect rect;
        rect.origin.x = 5;
        rect.size.width = CGRectGetWidth(self.bounds) - CGRectGetMinX(rect) * 2;
        rect.size.height = 20;
        rect.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(rect)) / 2;
        rect;
    })];
    self.placeholderLabel.font = [UIFont systemFontOfSize:14];
    self.placeholderLabel.textColor = [UIColor lightGrayColor];
    self.placeholderLabel.text = @"我是默认提示";
    [self addSubview:self.placeholderLabel];
    
    self.lengthLimit = NSUIntegerMax;
    self.minHeight = CGRectGetHeight(self.bounds);
    self.maxHeight = 50;
    self.autuaHeight = self.maxHeight;
}

- (void)setContentOffset:(CGPoint)contentOffset {
    if (self.scrollFlag) {
        [super setContentOffset:contentOffset];
    }
}

#pragma mark - noti
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextViewTextDidChangeNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textBeginEdit:) name:UITextViewTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textEndEdit:) name:UITextViewTextDidEndEditingNotification object:self];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - funcs
- (void)textBeginEdit:(NSNotification*)noti {
    self.placeholderLabel.hidden = YES;
}

- (void)textChange:(NSNotification*)noti {
    if (noti.object == self) {
        // 长度限制
        if (self.text.length > self.lengthLimit) {
            self.text = [self.text substringToIndex:self.lengthLimit];
            return ;
        }
        
        if (_isMaxHeight) {
            self.scrollFlag = YES;
        }else {
            self.scrollFlag = NO;
        }
        
        CGSize size  =[self sizeThatFits:CGSizeMake(CGRectGetWidth(self.bounds), MAXFLOAT)];
        if (MAX(size.height, self.minHeight) > self.maxHeight) {
            if (!_isFixed && self.autoAdjust) {
                self.autuaHeight = size.height;
                _isFixed = YES;
            }else if (!self.autoAdjust) {
                self.autuaHeight = self.maxHeight;
            }
            _isMaxHeight = YES;
        }else {
            _isMaxHeight = NO;
        }
        
        [UIView animateWithDuration:0.1 animations:^{
            self.frame = ({
                CGRect rect;
                rect.origin = self.frame.origin;
                rect.size.width = CGRectGetWidth(self.bounds);
                rect.size.height = MAX(size.height, self.minHeight) > self.autuaHeight ? self.autuaHeight : MAX(size.height, self.minHeight);
                rect;
            });
            if ([self.textDelegate respondsToSelector:@selector(textViewTextChanged:)]) {
                [self.textDelegate textViewTextChanged:self];
            }
        } completion:^(BOOL finished) {

        }];
    }
}

- (void)textEndEdit:(NSNotification*)noti {
    if ([self.text isEqualToString:@""] || !self.text) {
        self.placeholderLabel.hidden = NO;
        self.placeholderLabel.frame = ({
            CGRect rect;
            rect.origin.x = 5;
            rect.size.width = CGRectGetWidth(self.bounds) - CGRectGetMinX(rect) * 2;
            rect.size.height = 20;
            rect.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(rect)) / 2;
            rect;
        });
    }
}

#pragma mark - setter
- (void)setText:(NSString *)text {
    if (text.length) {
        self.placeholderLabel.hidden = YES;
    }
    
    [super setText:text];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self];
}

@end
