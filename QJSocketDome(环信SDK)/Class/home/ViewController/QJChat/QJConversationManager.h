//
//  QJConversationManager.h
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/14.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol QJConversationManagerDelegate <NSObject>

@optional
#pragma mark - Conversation

/*!
 *  \~chinese
 *  会话列表发生变化
 *
 *  @param aConversationList  会话列表<EMConversation>
 */
- (void)conversationListDidUpdate:(NSArray<EMConversation *> *)aConversationList;

#pragma mark - Message

/*!
 *  \~chinese
 *  收到新消息
 *
 *  @param aMessages  消息列表<EMMessage>
 */
- (void)messagesDidReceive:(NSArray<EMMessage *> *)aMessages ;

/*!
 *  \~chinese
 *  收到Cmd新消息
 *
 *  @param aCmdMessages  Cmd消息列表<EMMessage>
 */
//- (void)cmdMessagesDidReceive:(NSArray<EMMessage *> *)aCmdMessages ;

/*!
 *  \~chinese
 *  收到已读回执
 *
 *  @param aMessages  已读消息列表<EMMessage>
 */
- (void)messagesDidRead:(NSArray<EMMessage *> *)aMessages ;

/*!
 *  \~chinese
 *  收到群消息已读回执
 *
 *  @param aGroupAcks  已读消息列表<EMGroupMessageAck>
 */
- (void)groupMessageDidRead:(EMMessage *)aMessage
                  groupAcks:(NSArray<EMGroupMessageAck *> *)aGroupAcks ;

/*!
 *  \~chinese
 *  所有群已读消息发生变化
 *
 */
- (void)groupMessageAckHasChanged ;

/*!
 *  \~chinese
 *  收到消息送达回执
 *
 *  @param aMessages  送达消息列表<EMMessage>
 */
- (void)messagesDidDeliver:(NSArray<EMMessage *> *)aMessages ;

/*!
 *  \~chinese
 *  收到消息撤回
 *
 *  @param aMessages  撤回消息列表<EMMessage>
 */
- (void)messagesDidRecall:(NSArray<EMMessage *> *)aMessages ;

/*!
 *  \~chinese
 *  消息状态发生变化
 *
 *  @param aMessage  状态发生变化的消息
 *  @param aError    出错信息
 */
- (void)messageStatusDidChange:(EMMessage *)aMessage
                         error:(EMError *)aError ;

/*!
 *  \~chinese
 *  消息附件状态发生改变
 *
 *  @param aMessage  附件状态发生变化的消息
 *  @param aError    错误信息
 */
- (void)messageAttachmentStatusDidChange:(EMMessage *)aMessage
                                   error:(EMError *)aError ;

@end



@interface QJConversationManager : NSObject

/// 会话列表
@property (nonatomic , readonly) NSArray<EMConversation *> * conversations ;

+(instancetype)manager ;

-(void)addDelegate:(__weak id<QJConversationManagerDelegate>)delegate ;
-(void)removeDelegate:( id<QJConversationManagerDelegate>)delegate ;

#pragma mark - 获取数据相关

/// 创建会话ID：用联系人的电话组合成一个会话ID
/// @param contacts 会话表内的所有联系人，至少为2人
-(NSString *)createConversationIDWithContacts:(NSArray<QJContactModel *> *)contacts ;
/// 获取 单个会话
/// @param conversationId 会话ID
/// @param type 会话类型
-(EMConversation *)getConversationWithID:(NSString *)conversationId type:(EMConversationType)type;

/// 获取会话的单个信息
/// @param aMessageId 会话的单个信息的ID
-(EMMessage *)getMessageWithMessageId:(NSString *)aMessageId ;

@end

#pragma mark - 会话操作相关
@interface QJConversationManager (Operations)

/// 发送消息
/// @param aMessage 一条消息
/// @param aProgressBlock 进度回调
/// @param aCompletionBlock 完成回调
-(void)sendMessage:(EMMessage *)aMessage progress:(nullable void (^)(int))aProgressBlock completion:(nullable void (^)(EMMessage *, EMError *))aCompletionBlock ;

@end

NS_ASSUME_NONNULL_END
