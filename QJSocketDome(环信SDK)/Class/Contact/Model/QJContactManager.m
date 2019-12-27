//
//  QJContactManager.m
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/8.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "QJContactManager.h"

@interface QJContactManager ()<EMContactManagerDelegate>

@property (nonatomic , strong) QJWeakRefMutableArray< id<QJContactManagerDelegate> > * delegates ;

@end


@implementation QJContactManager

+(instancetype)manager {
    static dispatch_once_t onceToken;
    static QJContactManager * manager = nil ;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager ;
}

-(void)dealloc {
    [[EMClient sharedClient].contactManager removeDelegate:self];
}
-(instancetype)init {
    if (self = [super init]) {
        
    }
    return self ;
}

-(void)initContactManager {
    
    [[EMClient sharedClient].contactManager getContactsFromServerWithCompletion:^(NSArray *aList, EMError *aError) {
        
        [[EMClient sharedClient].contactManager getBlackListFromServerWithCompletion:^(NSArray *blackContactArr, EMError *aError2) {
            if (!aError2) {
                [self.blackContacts removeAllObjects];
                for (NSString * blackAccount in blackContactArr) {
                    QJContactModel * contactModel = [[QJContactModel alloc] init];
                    contactModel.account = blackAccount ;
                    contactModel.blackUser = YES ;
                    [self.blackContacts addObject:contactModel];
                }
            }
            
            if (!aError) {
                NSLog(@"获取成功 -- %@",aList);
                
                [self.contacts removeAllObjects];
                [self addContacts:aList] ;
            }
        }];
        
        // 只能放在这里监听，不然 [EMClient sharedClient].contactManager === nil
        [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    }];
    
}


#pragma mark - conteact manager delegate
-(void)addDelegate:(__weak id<QJContactManagerDelegate>)delegate {
    if (!delegate || [self.delegates containsObject:delegate]) return ;
    [self.delegates addObject:delegate];
}
-(void)removeDelegate:(id<QJContactManagerDelegate>)delegate {
    if (delegate && [self.delegates containsObject:delegate]) {
        [self.delegates removeObject:delegate];
    }
}

/// 获取联系人信息
/// @param account 账号ID
-(QJContactModel *)getContactModelWithAccount:(NSString *)account {
    if ([account isEqualToString:[QJUserManager manager].currentUser.account]) {
        QJContactModel * contact = [QJContactModel contactModelWithAccount:account reason:nil];
        contact.iconUrlStr = [QJUserManager manager].currentUser.iconUrlStr ;
        return contact;
    }
    for (QJContactModel * contact  in self.contacts) {
        if ([contact.account isEqualToString:account]) {
            return contact ;
        }
    }
    // 不是好友
    return nil ;
}

#pragma mark - 工具方法
-(void)dealContactWhenBlockContact:(QJContactModel *)contact{
    for (QJContactModel * blackContact  in self.blackContacts) {
        if ([blackContact.account isEqualToString:contact.account]) {
            contact.blackUser = YES ;
            blackContact.blackUser = YES ;
            return ;
        }
    }
}
/// 添加 好友联系人信息
-(void)addContacts:(NSArray<NSString *> *)contacts {
    for (NSString * objc in contacts) {
        QJContactModel * contactModel = [[QJContactModel alloc] init];
        contactModel.account = objc ;
        [self.contacts addObject:contactModel];
        
        [self dealContactWhenBlockContact:contactModel];
    }
}
-(void)addContactWithModel:(QJContactModel *)model {
    if (model == nil) return ;
    
    [self.contacts addObject:model];
    
    [self dealContactWhenBlockContact:model];
    
    for (QJContactModel * askContact in self.askContacts) {
        if ([askContact.account isEqualToString: model.account]) {
            [self.askContacts removeObject:askContact];
            break ;
        }
    }
    
    for (id<QJContactManagerDelegate> delegate in self.delegates.allObjects) {
        if ([delegate respondsToSelector:@selector(contactManager:contactsDidAdd:)]) {
            [delegate contactManager:self contactsDidAdd:model];
        }
    }
}
-(void)addContactWithAccount:(NSString *)account reason:(NSString *)reason {
    if (account.length == 0) return ;
    QJContactModel * contactModel = [QJContactModel contactModelWithAccount:account reason:reason];
    [self addContactWithModel:contactModel];
}
-(void)removeContactWithAccount:(NSString *)account {
    if (account == nil) return ;
    
    QJContactModel * model = nil ;
    for (model in self.contacts) {
        if ([model.account isEqualToString:account]) {
            [self.contacts removeObject:model];

            NSArray<id<QJContactManagerDelegate>> * delegates = self.delegates.allObjects ;
            for (id<QJContactManagerDelegate> delegate in delegates) {
                if ([delegate respondsToSelector:@selector(contactManager:didRemoveContact:)]) {
                    [delegate contactManager:self didRemoveContact:model];
                }
            }

            return ;
        }
    }
}

/// 添加 请求添加我为好友的联系人信息
-(void)addAskContactWithModel:(QJContactModel *)model {
    if (model) {
        for (QJContactModel * askContact in self.askContacts) {
            if ([askContact.account isEqualToString:model.account]) {
                return ;
            }
        }
        
        [self.askContacts addObject:model];
        
        [self dealContactWhenBlockContact:model];
        
        for (id<QJContactManagerDelegate> delegate in self.delegates.allObjects) {
            if ([delegate respondsToSelector:@selector(contactManager:otherAskAddFriendBy:)]) {
                [delegate contactManager:self otherAskAddFriendBy:model];
            }
        }
    }
}
-(void)addAskContactWithAccount:(NSString *)account reason:(NSString *)reason {
    if (account.length == 0) return ;
    QJContactModel * contactModel = [QJContactModel contactModelWithAccount:account reason:reason];
    [self addAskContactWithModel:contactModel];
}
@end

@implementation QJContactManager (lazy)

-(NSMutableArray<QJContactModel *> *)contacts {
    if (!_contacts) {
        NSArray * contactArr = [[EMClient sharedClient].contactManager getContacts] ;
        _contacts = [NSMutableArray array];
        if (contactArr.count) {
            [self addContacts:contactArr];
        }
    }
    return _contacts ;
}

-(NSMutableArray<QJContactModel *> *)askContacts {
    if (!_askContacts) {
        _askContacts = [NSMutableArray array];
    }
    return _askContacts ;
}

-(NSMutableArray<QJContactModel *> *)blackContacts {
    if (!_blackContacts) {
        NSArray * blackContactArr = [[EMClient sharedClient].contactManager getBlackList] ;
        _blackContacts = [NSMutableArray array];
        for (NSString * blackAccount in blackContactArr) {
            QJContactModel * contactModel = [[QJContactModel alloc] init];
            contactModel.account = blackAccount ;
            contactModel.blackUser = YES ;
            [_blackContacts addObject:contactModel];
        }
    }
    return _blackContacts ;
}

-(QJWeakRefMutableArray<id<QJContactManagerDelegate>> *)delegates {
    if (!_delegates) {
        _delegates = [QJWeakRefMutableArray array];
    }
    return _delegates ;
}
@end

@implementation QJContactManager (EMContactManagerDelegate)

/*!
 *  用户B拒绝 当前用户 的加好友请求后，当前用户 会收到这个回调
 *
 *  @param aUsername   用户B
 */
- (void)friendRequestDidDeclineByUser:(NSString *)aUsername{
    QJLog(@"添加好友 %@ 被拒绝",aUsername);
    QJContactModel * contactModel = [QJContactModel contactModelWithAccount:aUsername reason:nil];
    for (id<QJContactManagerDelegate> delegate in self.delegates.allObjects) {
        if ([delegate respondsToSelector:@selector(contactManager:askDidDeclineBy:)]) {
            [delegate contactManager:self askDidDeclineBy:contactModel];
        }
    }
}

/*!
 *  用户B删除 与 当前用户 的好友关系后，当前用户，用户B 会收到这个回调
 *
 *  @param aUsername   对方的账号
 */
- (void)friendshipDidRemoveByUser:(NSString *)aUsername{
    // 移除好友 成功
    [self removeContactWithAccount:aUsername];
}

/*!
 *  \~chinese
 *  用户B同意 当前用户 的好友申请后，当前用户 和 用户B 都会收到这个回调
 *
 *  @param aUsername   用户好友关系的另一方
 */
- (void)friendshipDidAddByUser:(NSString *)aUsername{
    if (aUsername.length == 0) return ;
    [self addContactWithAccount:aUsername reason:nil];
}

/*!
 *  \~chinese
 *  用户B申请加A为好友后，当前用户 会收到这个回调
 *
 *  @param aUsername   用户B
 *  @param aMessage    好友邀请信息
 */
- (void)friendRequestDidReceiveFromUser:(NSString *)aUsername
                                message:(NSString *)aMessage{
    QJLog(@"好友: %@ 想添加你，描述为: %@",aUsername , aMessage);
    
    [self addAskContactWithAccount:aUsername reason:aMessage];
}

@end

@implementation QJContactManager (Request)

#pragma mark - 添加好友
+(void)addContactWithAccount:(NSString *)account reason:(NSString *)reason {
    
    // 发送添加好友请求
    [SVProgressHUD showWithStatus:@"请稍等" maskType:SVProgressHUDMaskTypeBlack];
    [[EMClient sharedClient].contactManager addContact:account message:reason completion:^(NSString *aUsername, EMError *aError) {
        if (!aError) {
            [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        } else {
            [SVProgressHUD showErrorWithStatus:@"发送失败"];
        }
    }];
}

/// 同意请求添加好友
/// @param contact 要添加当前用户 的联系人信息
+(void)consentAskAddFriendForContact:(QJContactModel *)contact finish:(nonnull void (^)(BOOL))finish{
    [SVProgressHUD showWithStatus:@"请稍等" maskType:SVProgressHUDMaskTypeBlack];

    [[EMClient sharedClient].contactManager asyncAcceptInvitationForUsername:contact.account success:^{
        [SVProgressHUD showSuccessWithStatus:@"成功"];
        // 同意后环信会自动调用SDK的代理的 添加用户方法 friendshipDidAddByUser
        if(finish) finish(YES);
    } failure:^(EMError *aError) {
        [SVProgressHUD showErrorWithStatus:@"失败"];

        if(finish) finish(NO);
    }];
}
/// 拒绝请求添加好友
/// @param contact 要添加当前用户 的联系人信息
+(void)declineAskAddFriendForContact:(QJContactModel *)contact finish:(nonnull void (^)(BOOL))finish{
    [SVProgressHUD showWithStatus:@"请稍等" maskType:SVProgressHUDMaskTypeBlack];

    [[EMClient sharedClient].contactManager declineFriendRequestFromUser:contact.account completion:^(NSString *aUsername, EMError *aError) {
        !aError ? [SVProgressHUD showSuccessWithStatus:@"成功"] : [SVProgressHUD showErrorWithStatus:@"失败"];
        
        if (!aError) {
            [[QJContactManager manager].askContacts removeObject:contact] ;
            
            // 主动调用一下 拒绝好友添加
            [[QJContactManager manager] friendRequestDidDeclineByUser:[QJUserManager manager].currentUser.account];
        }
        
        if (finish) finish(!aError) ;
    }];
}


/// 删除好友
/// @param contact 联系人
/// @param finish 结束回调
+(void)deleteContact:(QJContactModel *)contact finish:(void(^)(BOOL seccess))finish {
    [SVProgressHUD showWithStatus:@"请稍等" maskType:SVProgressHUDMaskTypeBlack];

    [[EMClient sharedClient].contactManager deleteContact:contact.account isDeleteConversation:YES completion:^(NSString *aUsername, EMError *aError) {
        !aError ? [SVProgressHUD showSuccessWithStatus:@"删除成功"] : [SVProgressHUD showErrorWithStatus:@"删除失败"];
        
        if (finish) finish(!aError) ;
    }];
    
}

/// 添加联系人到 黑名单
/// @param contact 被添加到黑名单的 联系人
/// @param finish 完成回调
+(void)addContactToBlackList:(QJContactModel *)contact finish:(void(^)(BOOL seccess))finish {
    [SVProgressHUD showWithStatus:@"请稍等" maskType:SVProgressHUDMaskTypeBlack];

    [[EMClient sharedClient].contactManager addUserToBlackList:contact.account completion:^(NSString *aUsername, EMError *aError) {
        [SVProgressHUD dismiss];

        if (!aError) {
            contact.blackUser = YES ;
            [[QJContactManager manager].blackContacts addObject:contact];
        }
        if (finish) finish(!aError);
    }];
}
/// 从黑名单 移除联系人
/// @param contact 从黑名单被移除的 联系人
/// @param finish 完成回调
+(void)removeContactFromBlackList:(QJContactModel *)contact finish:(void(^)(BOOL seccess))finish {
    [SVProgressHUD showWithStatus:@"请稍等" maskType:SVProgressHUDMaskTypeBlack];

    [[EMClient sharedClient].contactManager removeUserFromBlackList:contact.account completion:^(NSString *aUsername, EMError *aError) {
        [SVProgressHUD dismiss];

        if (!aError) {
            contact.blackUser = NO ;
            for (QJContactModel * blackContact in [QJContactManager manager].blackContacts) {
                if ([blackContact.account isEqualToString:contact.account]) {
                    [[QJContactManager manager].blackContacts removeObject:blackContact];
                    break ;
                }
            }
        }
        if (finish) finish(!aError);
    }];
}

@end
