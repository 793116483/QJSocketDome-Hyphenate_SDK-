//
//  QJUserDefaults.m
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/7.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "QJUserDefaults.h"

@implementation QJUserDefaults

+(void)setBool:(BOOL)value forKey:(NSString *)defaultName {
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void)setURL:(NSURL *)url forKey:(NSString *)defaultName {
    if (url == nil) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:defaultName];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return ;
    }
    [[NSUserDefaults standardUserDefaults] setURL:url forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void)setFloat:(float)value forKey:(NSString *)defaultName {
    [[NSUserDefaults standardUserDefaults] setFloat:value forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)setDouble:(double)value forKey:(NSString *)defaultName {
    [[NSUserDefaults standardUserDefaults] setDouble:value forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void)setObject:(id)value forKey:(NSString *)defaultName {
    if (value == nil) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:defaultName];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return ;
    }
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void)setInteger:(NSInteger)value forKey:(NSString *)defaultName {
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void)setNilValueForKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setNilValueForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+(BOOL)boolForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] boolForKey:defaultName];
}
+(NSURL *)URLForKey:(NSString *)defaultName {
    
    return [[NSUserDefaults standardUserDefaults] URLForKey:defaultName];
}
+(float)floatForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] floatForKey:defaultName];
}

+(double)doubleForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] doubleForKey:defaultName];
}
+(id)objectForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
}
+(NSInteger)integerForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] integerForKey:defaultName];
}


@end
