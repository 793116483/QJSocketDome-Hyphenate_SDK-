//
//  QJUserDefaults.h
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/7.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QJUserDefaults : NSObject

+(void)setBool:(BOOL)value forKey:(NSString *)defaultName ;
+(void)setURL:(NSURL *)url forKey:(NSString *)defaultName ;
+(void)setFloat:(float)value forKey:(NSString *)defaultName ;
+(void)setDouble:(double)value forKey:(NSString *)defaultName ;
+(void)setObject:(id)value forKey:(NSString *)defaultName ;
+(void)setInteger:(NSInteger)value forKey:(NSString *)defaultName ;
+(void)setNilValueForKey:(NSString *)key ;


+(BOOL)boolForKey:(NSString *)defaultName ;
+(NSURL *)URLForKey:(NSString *)defaultName ;
+(float)floatForKey:(NSString *)defaultName ;
+(double)doubleForKey:(NSString *)defaultName ;
+(id)objectForKey:(NSString *)defaultName ;
+(NSInteger)integerForKey:(NSString *)defaultName ;

@end

NS_ASSUME_NONNULL_END
