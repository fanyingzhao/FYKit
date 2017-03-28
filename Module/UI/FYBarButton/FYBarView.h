//
//  FYBarView.h
//  TaskManager
//
//  Created by fan on 16/8/29.
//  Copyright © 2016年 fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FYBarView;
@protocol FYBarViewDelegate <NSObject>
@optional
- (void)barViewDidTouched:(FYBarView*)barView;

@end

@interface FYBarView : UIControl {
    
}
@property (nonatomic, strong, readonly) UIImageView* imageView;
@property (nonatomic, strong, readonly) UILabel* titleLabel;

@property (nonatomic, copy) NSString* title;
@property (nonatomic, strong) UIImage* image;
@property (nonatomic, strong) UIImage* selectedImage;
@property (nonatomic) id<FYBarViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString*)title
                        image:(UIImage*)image
                selectedImage:(UIImage*)selectedImage;


@end
