//
//  QJContactModel.m
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/9.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "QJContactModel.h"

@implementation QJContactModel

-(instancetype)init {
    if (self = [super init]) {
        self.iconUrlStr = @"xhr";
    }
    return self ;
}

-(void)setAccount:(NSString *)account {
    _account = account ;
    
    self.noteName = account ;
}

+(instancetype)contactModelWithAccount:(NSString *)account reason:(NSString *)reason {
    QJContactModel * model = [[self alloc] init];
    model.account = account ;
    model.reason = reason ;
    return model ;
}

@end
