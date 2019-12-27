//
//  QJUserModel.m
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/9.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "QJUserModel.h"

@implementation QJUserModel

-(instancetype)init {
    if (self = [super init]) {
        self.iconUrlStr = @"xhr";
    }
    return self ;
}
+(instancetype)userModelWithAccount:(NSString *)account pwd:(NSString *)pwd {
    QJUserModel * user = [[QJUserModel alloc] init];
    user.account = account ;
    user.pwd = pwd ;
    
    return user ;
}


-(void)setAccount:(NSString *)account {
    _account = account ;
    self.name = account ;
}

@end
