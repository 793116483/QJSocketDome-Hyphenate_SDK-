//
//  QJUserModel.h
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/9.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QJUserModel : NSObject

/// 用户头像
@property (nonatomic , copy) NSString * iconUrlStr ;

/// 账号:手机号码
@property (nonatomic , copy) NSString * account ;
@property (nonatomic , copy) NSString * name ;
@property (nonatomic , copy) NSString * pwd ;

+(instancetype)userModelWithAccount:(NSString *)account pwd:(NSString *)pwd ;

@end

NS_ASSUME_NONNULL_END
