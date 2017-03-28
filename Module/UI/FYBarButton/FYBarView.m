//
//  FYBarView.m
//  TaskManager
//
//  Created by fan on 16/8/29.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "FYBarView.h"
#import "FYMacro.h"

#define FontName @"Heiti SC"
#define FontSize 10

#define FontNormalColor 0x5c5c5c//正常状态
#define FontLightColor 0x09bdee//高亮状态

@interface FYBarView () {
    UIImageView* _imageView;
    UILabel* _titleLabel;
}

@end

@implementation FYBarView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage {
    if (self = [super initWithFrame:frame]) {
        _title = title;
        _image = image;
        _selectedImage = selectedImage;
        [self setUp];
    }
    return self;
}

#pragma mark - init
- (void)setUp {
    if (_image) {
        self.imageView.image = _image;
        [self.imageView sizeToFit];
        [self addSubview:self.imageView];
    }
    
    if (_title) {
        self.titleLabel.text = _title;
        [self.titleLabel sizeToFit];
        [self addSubview:self.titleLabel];
    }
}

#pragma mark - layout
- (void)layoutSubviews {
    if (_image) {
        self.imageView.frame =  ({
            CGRect rect;
            rect.size = self.imageView.bounds.size;
            rect.origin.x = (CGRectGetWidth(self.bounds) - CGRectGetWidth(rect)) / 2;
            rect.origin.y = 5;
            rect;
        });
    }
    
    self.titleLabel.frame = ({
        CGRect rect;
        rect.size.width = MIN(CGRectGetWidth(self.bounds), CGRectGetWidth(self.titleLabel.bounds));
        rect.size.height = CGRectGetHeight(self.titleLabel.bounds);
        rect.origin.x = (CGRectGetWidth(self.bounds) - CGRectGetWidth(rect)) / 2;
        rect.origin.y = MAX(CGRectGetMaxY(self.imageView.frame) + 5, (CGRectGetHeight(self.bounds) - CGRectGetHeight(rect)) / 2);
        rect;
    });
}

#pragma mark - event
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.delegate respondsToSelector:@selector(barViewDidTouched:)]) {
        [self.delegate barViewDidTouched:self];
    }
}

#pragma mark - setter
- (void)setTitle:(NSString *)title {
    if ([title isEqualToString:_title] || [title isEqualToString:@""] || !title) {
        return ;
    }
    
    _title = title;
    self.titleLabel.text = title;
}

- (void)setImage:(UIImage *)image {
    
}

- (void)setSelectedImage:(UIImage *)selectedImage {
    
}

#pragma mark - getter
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:FontName size:FontSize];
        _titleLabel.textColor = UICOLOR_HEX(FontNormalColor);
    }
    return _titleLabel;
}

@end
