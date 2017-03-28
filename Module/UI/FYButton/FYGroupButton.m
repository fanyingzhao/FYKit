//
//  FYGroupButton1.m
//  BeautyPupil
//
//  Created by fan on 16/10/14.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "FYGroupButton.h"

static const void* BtnIndexKey = &BtnIndexKey;

@interface FYGroupButton () {
    
}

@end

@implementation FYGroupButton

- (instancetype)initWithGroupId:(NSString *)groupId {
    if (self = [super init]) {
        _groupId = groupId;
    }
    return self;
}

#pragma mark - tools
- (void)updateBtnState:(UIButton*)btn isSelected:(BOOL)isSelected {
    if (self.selectUpdate) {
        self.selectUpdate(btn, isSelected);
    }
}

#pragma mark - events
- (void)btnClick:(UIButton*)sender {
    if (self.selectedBtn == sender) {
        return ;
    }
    
    [self updateBtnState:self.selectedBtn isSelected:NO];
    [self updateBtnState:sender isSelected:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(groupBtn:didBtnClick:)]) {
        [self.delegate groupBtn:self didBtnClick:[[sender getAssociatedValueForKey:BtnIndexKey] integerValue]];
    }
    
    self.selectedBtn = sender;
}

#pragma mark - funcs
- (UIButton *)createGroupBtnWithIndex:(NSInteger)index {
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setAssociateValue:@(index) key:BtnIndexKey];
    [self.btnList addObject:btn];

    return btn;
}

#pragma mark - setter
- (void)setSelectedBtn:(UIButton *)selectedBtn {
    _selectedBtn = selectedBtn;
    
    [self updateBtnState:selectedBtn isSelected:YES];
}

#pragma mark - getter
- (NSMutableArray *)btnList {
    if (!_btnList) {
        _btnList = [NSMutableArray array];
    }
    return _btnList;
}

@end
