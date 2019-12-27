//
//  UIImage+QJImage.m
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/8.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "UIImage+QJImage.h"
#import "objc/message.h"

@implementation UIImage (QJImage)
+(void)load
{
  [super load];

  // Class 的相关是用 objc 开头
  // 方法代码块 交换：只是一个方法功能，所以用 method 开头
  // Method 类或对象方法 是通过类的isa指针找，所以用 class_开头
  Method method1 = class_getClassMethod([self class], @selector(qj_imageNamed:));
  Method method2 = class_getClassMethod([self class], @selector(imageNamed:));
  // 只能交换一次，不然又会变成方法本身 ，所以放在 +load 方法实现交换(+load方法在app起动时只调一次)
  method_exchangeImplementations(method1, method2);
}

+(UIImage *)qj_imageNamed:(NSString *)name
{
  if (name) {// 这样可以防止添加空数据
      // 通过上面的方法交换后，在使用 [self qj_imageNamed:] 等于调用了 [self imageNamed:]
      // 反之如果调用 [self imageNamed:] 就等于调用了 [self qj_addObject:]
      // 所以在这里不能调用 [self imageNamed:]，否则会造成死循环
      return [[self qj_imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
  }
    return nil ;
}

#pragma mark - 图片拉伸
+(UIImage *)resizableImageWithName:(NSString *)imageName {
    return [self resizableImageWithImage:[UIImage imageNamed:imageName]];
}
+(UIImage *)resizableImageWithImage:(UIImage *)image {
    CGFloat width = image.size.width *0.5;
    CGFloat height = image.size.height *0.5;
    UIEdgeInsets capInsets = UIEdgeInsetsMake(height, width, height-1, width-1);
    return [self resizableImageWithImage:image capInsets:capInsets];
}
+(UIImage *)resizableImageWithName:(NSString *)imageName capInsets:(UIEdgeInsets)capInsets{
    return [self resizableImageWithImage:[UIImage imageNamed:imageName] capInsets:capInsets];
}
+(UIImage *)resizableImageWithImage:(UIImage *)image capInsets:(UIEdgeInsets)capInsets{
    image = [image resizableImageWithCapInsets:capInsets];
    return image ;
}

@end
