//
//  UIBarButtonItem+QJBarButtonItem.m
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/8.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "UIBarButtonItem+QJBarButtonItem.h"

@implementation UIBarButtonItem (QJBarButtonItem)

+ (instancetype)barButtonItemWithImage:(nullable UIImage *)image target:(nullable id)target action:(nullable SEL)action {
    return [[self alloc] initWithImage:image style:UIBarButtonItemStylePlain target:target action:action];
}
+(instancetype)barButtonItemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action {
    return [self barButtonItemWithImage:[UIImage imageNamed:imageName] target:target action:action];
}
+ (instancetype)barButtonItemWithTitle:(nullable NSString *)title target:(nullable id)target action:(nullable SEL)action {
    return [[self alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
}
+ (instancetype)barButtonItemWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem target:(nullable id)target action:(nullable SEL)action {
    return [[self alloc] initWithBarButtonSystemItem:systemItem target:target action:action];
}
+ (instancetype)barButtonItemWithCustomView:(UIView *)customView {
    return [[self alloc] initWithCustomView:customView];
}

@end
