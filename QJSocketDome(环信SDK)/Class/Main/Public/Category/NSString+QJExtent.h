//
//  NSString+QJExtent.h
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/10.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (QJExtent)

/** 返回文字真实的Size */
- (CGSize)sizeWithMaxSize:(CGSize)size font:(UIFont *)font ;

@end

NS_ASSUME_NONNULL_END
