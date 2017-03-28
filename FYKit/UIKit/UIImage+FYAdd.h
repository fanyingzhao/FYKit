//
//  UIImage+FYAdd.h
//  FFKit
//
//  Created by fan on 16/7/12.
//  Copyright © 2016年 fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (FYAdd)

/**
 *  将图片变为指定大小
 *
 *  @param size 指定的尺寸
 *
 *  @return 改变了尺寸后的图片
 */
- (UIImage*)reSizeImageWithSize:(CGSize)size;

/**
 *  将图片变为圆角图片
 *
 *  @param radius 角度
 *
 *  @return 变为圆角图片的图片
 */
- (UIImage*)changeShapeWithCornerRadius:(CGFloat)radius;
- (UIImage*)changeShapeWithCornerRadius:(CGFloat)radius size:(CGSize)size;


- (UIImage*)changeImageContentWithSize:(CGRect)rect transform:(CGAffineTransform)transform;

/**
 将图片保存到本地

 @param fileName 图片的名称
 @param path 图片的路径,默认目录为:Document/images/XXX
 @param encryption  文件名是否用md5加密
 */
- (BOOL)saveToFile:(NSString*)fileName path:(NSString*)path md5:(BOOL)encryption;

/**
 将gif转换成图片数组

 @param gifPath gif路径
 @return 图片数组
 */
+ (NSArray*)getImageListByGif:(NSString*)gifPath;

/**
 通过颜色生成图片

 @param color 颜色值
 @param size 图片大小
 @return 生成的图片
 */
+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size;

@end
