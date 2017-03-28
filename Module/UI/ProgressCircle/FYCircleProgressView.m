//
//  FYCircleProgressView.m
//  TaskManager
//
//  Created by fan on 16/8/29.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "FYCircleProgressView.h"
#import "FYMacro.h"

@interface FYCircleProgressView () {
    
}
@property (nonatomic, strong) CAShapeLayer* circleBackLayer;
@property (nonatomic, strong) CAShapeLayer* circleLayer;

@end

@implementation FYCircleProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

#pragma mark - init
- (void)setUp {
    self.circleWidth = 5.f;
    self.circleBackColor = UICOLOR_RGB_ALPHA(255, 255, 255, 0.2);
    self.circleColor = [UIColor whiteColor];
    
    [self.layer addSublayer:self.circleBackLayer];
    [self.layer addSublayer:self.circleLayer];
    [self addSubview:self.textLabel];
}

#pragma mark - tools
- (CGPathRef)getCirclePath:(CGFloat)progress {
    return [UIBezierPath bezierPathWithArcCenter:({
        CGPoint point;
        point.x = CGRectGetWidth(self.bounds) / 2;
        point.y = CGRectGetHeight(self.bounds) / 2;
        point;
    }) radius:CGRectGetWidth(self.bounds) / 2 startAngle:-M_PI_2 endAngle:2 * M_PI * progress - M_PI_2 clockwise:YES].CGPath;
}

#pragma mark - funcs
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    _progress = progress;
    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(0);
    animation.toValue = @(progress);
    animation.removedOnCompletion = NO;
    animation.duration = 0.3;
    animation.fillMode = kCAFillModeForwards;
    [self.circleLayer addAnimation:animation forKey:@"animation"];
}

#pragma mark - getter
- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:({
            CGRect rect;
            rect.origin.x = 10;
            rect.size.height = 20;
            rect.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(rect)) / 2;
            rect.size.width = CGRectGetWidth(self.bounds) - CGRectGetMinX(rect) * 2;
            rect;
        })];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont boldSystemFontOfSize:17];
    }
    return _textLabel;
}

- (CAShapeLayer *)circleBackLayer {
    if (!_circleBackLayer) {
        _circleBackLayer = [CAShapeLayer layer];
        _circleBackLayer.frame = self.bounds;
        _circleBackLayer.path = [self getCirclePath:1];
        _circleBackLayer.lineWidth = self.circleWidth;
        _circleBackLayer.strokeColor = self.circleBackColor.CGColor;
        _circleBackLayer.fillColor = nil;
    }
    return _circleBackLayer;
}

- (CAShapeLayer *)circleLayer {
    if (!_circleLayer) {
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.frame = self.circleBackLayer.frame;
        _circleLayer.path = [self getCirclePath:1];
        _circleLayer.strokeEnd = 0;
        _circleLayer.lineWidth = self.circleBackLayer.lineWidth;
        _circleLayer.strokeColor = self.circleColor.CGColor;
        _circleLayer.fillColor = nil;
        _circleLayer.lineCap = kCALineCapRound;
    }
    return _circleLayer;
}

@end
