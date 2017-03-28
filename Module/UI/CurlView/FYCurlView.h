//
//  FYCurlView.h
//  BeautyPupil
//
//  Created by fan on 16/9/23.
//  Copyright © 2016年 fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYCurlView : UIView {
    
}
/**
 *  弯曲的程度， 0 - 90， 默认是 20
 */
@property (nonatomic) CGFloat curlDegree;

/**
 *  弯曲半径， 0 - height,默认是 0
 */
@property (nonatomic) CGFloat curlRadius;

/**
 *  当前可见的数量，默认是0，会根据元素个数设置
 */
@property (nonatomic) CGFloat visualCount;


@end

