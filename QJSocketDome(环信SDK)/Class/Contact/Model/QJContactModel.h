//
//  QJContactModel.h
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/9.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QJContactModel : NSObject

/// 账号:手机号码
@property (nonatomic , copy) NSString * account ;

/// 备注名
@property (nonatomic , copy) NSString * noteName ;

/// 添加我的时候，备注理由
@property (nonatomic , copy) NSString * reason ;

/// 用户头像
@property (nonatomic , copy) NSString * iconUrlStr ;

/// 是否是加入了黑名单 用户
@property (nonatomic , getter=isBlackUser) BOOL blackUser ;

+(instancetype)contactModelWithAccount:(NSString *)account reason:(nullable NSString *)reason ;

@end

NS_ASSUME_NONNULL_END
