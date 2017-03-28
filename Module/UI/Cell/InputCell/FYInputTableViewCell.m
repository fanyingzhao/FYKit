//
//  FYInputTableViewCell.m
//  TaskManager
//
//  Created by fan on 16/8/31.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "FYInputTableViewCell.h"
#import "FYMacro.h"

@interface FYInputTableViewCell () {
    
}

@end

@implementation FYInputTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self _setUp];
    }
    return self;
}

#pragma mark - init
- (void)_setUp {
    [self addSubview:self.textView];
}

#pragma mark - FYTextViewDelegate
- (void)textViewTextChanged:(FYTextView *)textView {
    if ([self.delegate respondsToSelector:@selector(inputCellDidTextChanged:indexPath:)]) {
        [self.delegate inputCellDidTextChanged:self indexPath:self.indexPath];
    }
}

#pragma mark - getter
- (FYTextView *)textView {
    if (!_textView) {
        _textView = [[FYTextView alloc] initWithFrame:({
            CGRect rect;
            rect.origin.x = 5;
            rect.origin.y = 5;
            rect.size.width = UIDEVICE_SCREEN_WIDTH - 2 * CGRectGetMinX(rect);
            rect.size.height = 30;
            rect;
        })];
        _textView.textDelegate = self;
    }
    return _textView;
}

@end
