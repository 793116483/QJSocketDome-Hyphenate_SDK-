//
//  QJUserManager.m
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/7.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "QJUserManager.h"

@interface QJUserManager()<EMClientDelegate>

@property (nonatomic , strong) QJWeakRefMutableArray < id<QJUserManagerDelegate> > * delegates ;

@end

@implementation QJUserManager

static const NSString * kIsLogin = @"kIsLogin";
static const NSString * kAccountName = @"kAccountName";
static const NSString * kPwdName = @"kPwdName";

+(instancetype)manager {
    static dispatch_once_t onceToken;
    static QJUserManager * manager = nil ;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager ;
}

-(instancetype)init {
    if (self = [super init]) {
        [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
        self.isLoging = [QJUserDefaults boolForKey:kIsLogin];
    }
    return self ;
}
-(void)dealloc {
    [[EMClient sharedClient] removeDelegate:self];
}

#pragma mark - user manager delegate
-(void)addDelegate:(__weak id<QJUserManagerDelegate>)delegate {
    if (delegate && ![self.delegates containsObject:delegate]) {
        [self.delegates addObject:delegate];
    }
}
-(void)removeDelegate:(id<QJUserManagerDelegate>)delegate {
    if (delegate && [self.delegates containsObject:delegate]) {
        [self.delegates removeObject:delegate];
    }
}

#pragma mark - 环信 EMClientDelegate
// 联接状态改变
-(void)connectionStateDidChange:(EMConnectionState)aConnectionState {
    for (id<QJUserManagerDelegate> delegate in self.delegates.allObjects) {
        if ([delegate respondsToSelector:@selector(userManager:connectionStateChanged:)]) {
            [delegate userManager:self connectionStateChanged: aConnectionState == EMConnectionConnected];
        }
    }
}
// 当前账号自动登录完成
-(void)autoLoginDidCompleteWithError:(EMError *)aError {
     self.isLoging = !aError ;
    if (self.isLoging) {
        QJUserModel * user = [[QJUserModel alloc] init];
        user.account = [QJUserDefaults objectForKey:kAccountName];
        user.pwd = [QJUserDefaults objectForKey:kPwdName];
        
        self.currentUser = user ;
    }
}
// 当前账号从服务器被移除
-(void)userAccountDidRemoveFromServer {
    self.isLoging = NO ;
}
// 当前账号在服务器上禁止用户
-(void)userDidForbidByServer {
    self.isLoging = NO ;
}
// 当前账号在其他设备上登录了
-(void)userAccountDidLoginFromOtherDevice{
    self.isLoging = NO ;
}
/**
 * 当前登录账号被强制退出时会收到该回调，有以下原因：
 *    1.密码被修改；
 *    2.登录设备数过多；
 */
-(void)userAccountDidForcedToLogout:(EMError *)aError {
    self.isLoging = NO ;
}

#pragma mark - 登录状态改变
-(void)setIsLoging:(BOOL)isLoging {
    
    _isLoging = isLoging ;
    [QJUserDefaults setBool:isLoging forKey:kIsLogin] ;
    
    for (id<QJUserManagerDelegate> delegate in self.delegates.allObjects) {
        if ([delegate respondsToSelector:@selector(userManager:loginStateChanged:)]) {
            [delegate userManager:self loginStateChanged:isLoging];
        }
    }
}

#pragma mark - 懒加载
-(QJWeakRefMutableArray<id<QJUserManagerDelegate>> *)delegates {
    if (!_delegates) {
        _delegates = [QJWeakRefMutableArray array];
    }
    return _delegates ;
}

-(BOOL)isConnected {
    return [EMClient sharedClient].isConnected ;
}

-(void)setCurrentUser:(QJUserModel *)currentUser {
    _currentUser = currentUser ;
    
    [QJUserDefaults setObject:currentUser.account forKey:kAccountName];
    [QJUserDefaults setObject:currentUser.pwd forKey:kPwdName];
}

@end
