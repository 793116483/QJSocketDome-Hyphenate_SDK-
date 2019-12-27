//
//  QJContactManager.h
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/8.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QJContactModel.h"

NS_ASSUME_NONNULL_BEGIN

@class QJContactManager ;
@protocol QJContactManagerDelegate <NSObject>

@optional

/// 添加了 好友
/// @param manager 管理联系人对象
/// @param contact 已经 添加了 好友
-(void)contactManager:(QJContactManager *)manager contactsDidAdd:(QJContactModel *)contact ;

/// 改变了 好友信息
/// @param manager 管理联系人对象
/// @param contacts 联系人已经被 改变了
//-(void)contactManager:(QJContactManager *)manager contactsChanged:(NSArray<QJContactModel *> *)contacts ;

/// 其他人 请求添加 你为好友
/// @param manager 管理联系人对象
/// @param askContact 请求添加为好友的 联系人
-(void)contactManager:(QJContactManager *)manager otherAskAddFriendBy:(QJContactModel *)askContact ;

/// 移除 好友 回调
/// @param manager 管理联系人对象
/// @param contact 被移除的 好友
-(void)contactManager:(QJContactManager *)manager didRemoveContact:(QJContactModel *)contact ;

/// 请求添加好友 被拒绝
/// @param manager 管理联系人对象
/// @param contact 拒绝你请求的联系人
-(void)contactManager:(QJContactManager *)manager askDidDeclineBy:(QJContactModel *)contact;

@end


@interface QJContactManager : NSObject

/// 好友列表
@property (nonatomic , strong) NSMutableArray<QJContactModel *> * contacts ;
/// 请求加我为好友的联系人信息
@property (nonatomic , strong) NSMutableArray<QJContactModel *> * askContacts ;
/// 黑名单列表
@property (nonatomic , strong) NSMutableArray<QJContactModel *> * blackContacts ;

/// 单例
+(instancetype)manager ;
/// 初始化 ，获取数据
-(void)initContactManager  ;

/// 添加 和 移除 代理 配合使用
/// @param delegate 代理
-(void)addDelegate:(nonnull __weak id<QJContactManagerDelegate>)delegate ;
-(void)removeDelegate:(nonnull id<QJContactManagerDelegate>)delegate ;


/// 获取联系人信息
/// @param account 账号ID
-(QJContactModel *)getContactModelWithAccount:(NSString *)account ;

@end


@interface QJContactManager (Request)

/// 请求添加好友
/// @param account 好友账号
/// @param reason 描述信息
+(void)addContactWithAccount:(NSString *)account reason:(NSString *)reason ;
/// 同意请求添加好友
/// @param contact 要添加当前用户 的联系人信息
+(void)consentAskAddFriendForContact:(QJContactModel *)contact finish:(void(^)(BOOL seccess))finish;
/// 拒绝请求添加好友
/// @param contact 要添加当前用户 的联系人信息
+(void)declineAskAddFriendForContact:(QJContactModel *)contact finish:(void(^)(BOOL seccess))finish;


/// 删除好友
/// @param contact 联系人
/// @param finish 结束回调
+(void)deleteContact:(QJContactModel *)contact finish:(void(^)(BOOL seccess))finish ;


/// 添加联系人到 黑名单
/// @param contact 被添加到黑名单的 联系人
/// @param finish 完成回调
+(void)addContactToBlackList:(QJContactModel *)contact finish:(void(^)(BOOL seccess))finish ;
/// 从黑名单 移除联系人
/// @param contact 从黑名单被移除的 联系人
/// @param finish 完成回调
+(void)removeContactFromBlackList:(QJContactModel *)contact finish:(void(^)(BOOL seccess))finish ;

@end

NS_ASSUME_NONNULL_END
