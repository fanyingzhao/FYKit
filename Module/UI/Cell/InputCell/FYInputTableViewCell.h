//
//  FYInputTableViewCell.h
//  TaskManager
//
//  Created by fan on 16/8/31.
//  Copyright © 2016年 fan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYTextView.h"

@class FYInputTableViewCell;
@protocol FYInputTableViewCellDelegate <NSObject>
@optional
- (void)inputCellDidTextChanged:(FYInputTableViewCell*)cell indexPath:(NSIndexPath*)indexPath;

@end

@interface FYInputTableViewCell : UITableViewCell<FYTextViewDelegate> {
    
}
@property (nonatomic, strong) FYTextView* textView;
@property (nonatomic, strong) NSIndexPath* indexPath;
@property (nonatomic, weak) id<FYInputTableViewCellDelegate> delegate;


@end
