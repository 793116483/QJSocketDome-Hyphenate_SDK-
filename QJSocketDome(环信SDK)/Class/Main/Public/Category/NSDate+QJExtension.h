//
//  NSDate+QJExtension.h
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/14.
//  Copyright © 2019 yiniu. All rights reserved.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (QJExtension)

+(NSString *)dateStringWithTimeInterval:(NSTimeInterval)timeInterval dateFormat:(NSString *)dateFormat;

-(NSString *)customString ;

@end

NS_ASSUME_NONNULL_END
