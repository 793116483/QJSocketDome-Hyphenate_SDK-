//
//  UIImage+QJImage.h
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/8.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (QJImage)

/// 根据图片中间一个点，平铺拉伸放大
/// @param imageName 图片名
+(UIImage *)resizableImageWithName:(NSString *)imageName ;
+(UIImage *)resizableImageWithImage:(UIImage *)image ;

/// 根据指定的图片位置，平铺拉伸放大
/// @param imageName 图片名
/// @param capInsets 指定的位置
+(UIImage *)resizableImageWithName:(NSString *)imageName capInsets:(UIEdgeInsets)capInsets;
+(UIImage *)resizableImageWithImage:(UIImage *)image capInsets:(UIEdgeInsets)capInsets;

@end

NS_ASSUME_NONNULL_END
