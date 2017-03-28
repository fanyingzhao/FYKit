//
//  FYGroupButton1.h
//  BeautyPupil
//
//  Created by fan on 16/10/14.
//  Copyright © 2016年 fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FYGroupButton;
@protocol FYGroupButtonDelegate <NSObject>
@optional
- (void)groupBtn:(FYGroupButton*)groupBtn didBtnClick:(NSInteger)index;

@end

typedef void(^GroupBtnSelectUpdate) (UIButton* btn, BOOL isSelected);

@interface FYGroupButton : NSObject {
    
}
@property (nonatomic, strong) NSMutableArray* btnList;

@property (nonatomic, strong) UIButton* selectedBtn;

@property (nonatomic, copy) NSString* groupId;

@property (nonatomic, copy) GroupBtnSelectUpdate selectUpdate;

@property (nonatomic, weak) id<FYGroupButtonDelegate> delegate;

- (instancetype)initWithGroupId:(NSString*)groupId;

- (UIButton*)createGroupBtnWithIndex:(NSInteger)index;;

@end
