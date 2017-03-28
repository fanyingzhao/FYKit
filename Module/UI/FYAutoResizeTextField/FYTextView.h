//
//  FYAutoResizeTextField.h
//  TaskManager
//
//  Created by fan on 16/8/30.
//  Copyright © 2016年 fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FYTextView;
@protocol FYTextViewDelegate <NSObject>
@optional
- (void)textViewTextChanged:(FYTextView*)textView;

@end

@interface FYTextView : UITextView {
    
}
@property (nonatomic, weak) id<FYTextViewDelegate> textDelegate;
@property (nonatomic, strong) UILabel* placeholderLabel;
/**
 *  长度限制，默认没有限制
 */
@property (nonatomic) NSUInteger lengthLimit;

/**
 *  是否自动调整最大高度，默认为YES
 */
@property (nonatomic) BOOL autoAdjust;

@property (nonatomic) CGFloat minHeight;
@property (nonatomic) CGFloat maxHeight;

@end
