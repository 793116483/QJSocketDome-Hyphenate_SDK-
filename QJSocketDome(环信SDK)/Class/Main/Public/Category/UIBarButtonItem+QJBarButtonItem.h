//
//  UIBarButtonItem+QJBarButtonItem.h
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/8.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (QJBarButtonItem)

+ (instancetype)barButtonItemWithImage:(nullable UIImage *)image target:(nullable id)target action:(nullable SEL)action ;
+ (instancetype)barButtonItemWithImageName:(nullable NSString *)imageName target:(nullable id)target action:(nullable SEL)action;
+ (instancetype)barButtonItemWithTitle:(nullable NSString *)title target:(nullable id)target action:(nullable SEL)action;
+ (instancetype)barButtonItemWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem target:(nullable id)target action:(nullable SEL)action;
+ (instancetype)barButtonItemWithCustomView:(UIView *)customView;

@end

NS_ASSUME_NONNULL_END
