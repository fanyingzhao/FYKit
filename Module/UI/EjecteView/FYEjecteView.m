//
//  FYEjecteView.m
//  BeautyPupil
//
//  Created by fan on 16/9/22.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "FYEjecteView.h"
#import "QuartzHelper.h"

@interface FYEjecteView () {
    CGRect _originRect;
    CGRect _finishRect;
}

@end

@implementation FYEjecteView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _setUp];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    drawTriangle(context, self.triangleRect, 0);
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1);
    CGContextDrawPath(context, kCGPathFill);
    
    CGRect frame = ({
        CGRect rect;
        rect.origin.x = 0;
        rect.origin.y = CGRectGetMaxY(self.triangleRect);
        rect.size.width = self.width;
        rect.size.height = self.height - CGRectGetMinY(rect);
        rect;
    });
    drawRoundRectangle(context, frame, self.cornerRadius);
    
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1);
    CGContextDrawPath(context, kCGPathFill);
}

#pragma mark - init
- (void)_setUp {
    _originRect = self.frame;
    _triangleRect = ({
        CGRect rect;
        rect.size.width = 15;
        rect.size.height = 10;
        rect.origin.x = self.width - CGRectGetWidth(rect) - 25;
        rect.origin.y = 0;
        rect;
    });
    
    self.layer.masksToBounds = YES;
    self.cornerRadius = 20;
    self.duration = 0.2;
    self.backAlpha = 0.4;
    
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.tableView];
    
    _finishRect = ({
        CGRect rect;
        rect.origin = self.origin;
        rect.size.width = self.width;
        rect.size.height = 0;
        rect;
    });
    
    @weakify(self);
    self.showAnimation = ^(FYAnimationShowView* animationView, CGRect finishRect) {
        @strongify(self);
        self.frame = self->_finishRect;
        animationView.alpha = 0;
        [UIView animateWithDuration:animationView.duration animations:^{
            animationView.frame = self->_originRect;
            animationView.alpha = 1;
            animationView.coverView.alpha = self.backAlpha;
        }];
    };
    self.hiddenAnimation = ^(FYAnimationShowView* animationView, CGRect originRect) {
        @strongify(self);
        [UIView animateWithDuration:self.duration animations:^{
            animationView.frame = self->_finishRect;
            animationView.alpha = 0;
            animationView.coverView.alpha = 0.f;
        } completion:^(BOOL finished) {
            [animationView removeFromSuperview];
        }];
    };
}

#pragma mark - tableviewdelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.textLabel.text = @"发达";
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}

#pragma mark - setter
- (void)setTriangleRect:(CGRect)triangleRect {
    _triangleRect = triangleRect;
    
    [self setNeedsDisplay];
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:({
            CGRect rect;
            rect.origin.x = 0;
            rect.origin.y = CGRectGetMaxY(self.triangleRect);
            rect.size.width = self.width;
            rect.size.height = self.height - CGRectGetHeight(self.triangleRect);
            rect;
        }) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        CellRegister([UITableViewCell class]);
    }
    return _tableView;
}


@end
