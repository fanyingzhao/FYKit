//
//  FYCircleProgressView.h
//  TaskManager
//
//  Created by fan on 16/8/29.
//  Copyright © 2016年 fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYCircleProgressView : UIView {
    
}
@property (nonatomic, strong) UILabel* textLabel;
@property (nonatomic) CGFloat progress;
@property (nonatomic, strong) UIColor* circleColor;
@property (nonatomic, strong) UIColor* circleBackColor;
@property (nonatomic) CGFloat circleWidth;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end
