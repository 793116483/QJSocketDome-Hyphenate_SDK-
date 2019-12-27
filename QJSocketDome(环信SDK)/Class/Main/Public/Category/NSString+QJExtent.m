//
//  NSString+QJExtent.m
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/10.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "NSString+QJExtent.h"

@implementation NSString (QJExtent)

/** 返回文字真实的Size */
- (CGSize) sizeWithMaxSize:(CGSize)size font:(UIFont *)font{
    NSDictionary * attrib = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrib context:nil].size;
}
@end
