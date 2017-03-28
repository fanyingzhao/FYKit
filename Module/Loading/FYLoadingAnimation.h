//
//  FYLoadingView.h
//  FFKit
//
//  Created by fan on 17/3/7.
//  Copyright © 2017年 fan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYLoadingManager.h"

@protocol FYLoadingAnimationDelegate <NSObject>
@required
- (void)show;
- (void)hideWithCompletion:(FYLoadingCompletionBlock)completionBlock;

@end

@interface FYLoadingAnimation : UIView <FYLoadingAnimationDelegate>

@property (nonatomic, strong) FYLoadingManager* manager;

@property (nonatomic, strong) UIView* backView;

@end
