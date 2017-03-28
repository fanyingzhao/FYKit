//
//  FYEjecteView.h
//  BeautyPupil
//
//  Created by fan on 16/9/22.
//  Copyright © 2016年 fan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYAnimationShowView.h"

@interface FYEjecteView : FYAnimationShowView<UITableViewDelegate, UITableViewDataSource> {
    
}
/**
 *  背景alpha
 */
@property (nonatomic) CGFloat backAlpha;
/**
 *  圆角半径
 */
@property (nonatomic) CGFloat cornerRadius;
/**
 *  小箭头的大小，默认 (15 , 10),距离右边距 25
 */
@property (nonatomic) CGRect triangleRect;

@property (nonatomic, strong) UITableView* tableView;


@end
