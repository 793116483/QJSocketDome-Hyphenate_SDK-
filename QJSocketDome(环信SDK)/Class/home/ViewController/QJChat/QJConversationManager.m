//
//  QJConversationManager.m
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/14.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "QJConversationManager.h"

@interface QJConversationManager ()<EMChatManagerDelegate>

@property (nonatomic , strong) QJWeakRefMutableArray< id<QJConversationManagerDelegate> > * delegates ;

@end

@implementation QJConversationManager

+(instancetype)manager {
    static dispatch_once_t onceToken;
    static QJConversationManager * manager = nil ;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager ;
}
-(void)dealloc {
    [[EMClient sharedClient].chatManager removeDelegate:self];
}
-(instancetype)init {
    if (self = [super init]) {
        [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    }
    return self ;
}

-(void)addDelegate:(__weak id<QJConversationManagerDelegate>)delegate {
    if ([self.delegates containsObject:delegate]) return ;
    
    [self.delegates addObject:delegate];
}
-(void)removeDelegate:(id<QJConversationManagerDelegate>)delegate {
    [self.delegates removeObject:delegate];
}

#pragma mark - 获取数据相关
-(NSString *)createConversationIDWithContacts:(NSArray<QJContactModel *> *)contacts {
    // 用联系人的电话组合成一个会话ID
//    long long ID = 0 ;
//    for (QJContactModel * contact in contacts) {
//        ID += [contact.account longLongValue];
//    }
//    if (contacts.count == 1) { // 试过了，这个ID环信强制设置成 -[EMMessage to]
//        ID += [[QJUserManager manager].currentUser.account longLongValue];
//    }
    NSString * conversationID = contacts.firstObject.account;//[NSString stringWithFormat:@"%lld",ID];
    return conversationID ;
}
-(EMConversation *)getConversationWithID:(NSString *)conversationId type:(EMConversationType)type {
    EMConversation * conversation = [[EMClient sharedClient].chatManager getConversation:conversationId type:type createIfNotExist:YES];
    return conversation ;
}

-(EMMessage *)getMessageWithMessageId:(NSString *)aMessageId {
    return [[EMClient sharedClient].chatManager getMessageWithMessageId:aMessageId];
}

#pragma mark - 懒加载
@synthesize conversations = _conversations ;
-(NSArray<EMConversation *> *)conversations {
    if (!_conversations) {
        _conversations = [[EMClient sharedClient].chatManager getAllConversations];
    }
    return _conversations ;
}

-(QJWeakRefMutableArray<id<QJConversationManagerDelegate>> *)delegates {
    if (!_delegates) {
        _delegates = [QJWeakRefMutableArray array];
    }
    return _delegates ;
}

@end


#pragma mark - EMChatManagerDelegate
@implementation QJConversationManager (EMChatManagerDelegate)

#pragma mark - Conversation

/*!
 *  \~chinese
 *  会话列表发生变化
 *
 *  @param aConversationList  会话列表<EMConversation>
 */
- (void)conversationListDidUpdate:(NSArray *)aConversationList {
    _conversations = [NSMutableArray arrayWithArray:aConversationList] ;
    
    for (id<QJConversationManagerDelegate> delegate in self.delegates.allObjects) {
        if ([delegate respondsToSelector:@selector(conversationListDidUpdate:)]) {
            [delegate conversationListDidUpdate:aConversationList];
        }
    }
}

#pragma mark - Message

/*!
 *  \~chinese
 *  收到消息
 *
 *  @param aMessages  消息列表<EMMessage>
 */
- (void)messagesDidReceive:(NSArray<EMMessage *> *)aMessages {
    
    // 插入数据
    for (EMMessage * message in aMessages) {
        EMConversation * conversation = [self getConversationWithID:message.conversationId type:EMConversationTypeChat];
        [conversation insertMessage:message error:nil];
    }
    
    for (id<QJConversationManagerDelegate> delegate in self.delegates.allObjects) {
        if ([delegate respondsToSelector:@selector(messagesDidReceive:)]) {
            [delegate messagesDidReceive:aMessages];
        }
    }
}

/*!
 *  \~chinese
 *  收到已读回执
 *
 *  @param aMessages  已读消息列表<EMMessage>
 */
- (void)messagesDidRead:(NSArray *)aMessages {
    for (id<QJConversationManagerDelegate> delegate in self.delegates.allObjects) {
        if ([delegate respondsToSelector:@selector(messagesDidRead:)]) {
            [delegate messagesDidRead:aMessages];
        }
    }
}

/*!
 *  \~chinese
 *  收到群消息已读回执
 *
 *  @param aGroupAcks  已读消息列表<EMGroupMessageAck>
 */
- (void)groupMessageDidRead:(EMMessage *)aMessage
                  groupAcks:(NSArray *)aGroupAcks {
    for (id<QJConversationManagerDelegate> delegate in self.delegates.allObjects) {
        if ([delegate respondsToSelector:@selector(groupMessageDidRead:groupAcks:)]) {
            [delegate groupMessageDidRead:aMessage groupAcks:aGroupAcks];
        }
    }
}

/*!
 *  \~chinese
 *  所有群已读消息发生变化
 *
 */
- (void)groupMessageAckHasChanged {
    for (id<QJConversationManagerDelegate> delegate in self.delegates.allObjects) {
        if ([delegate respondsToSelector:@selector(groupMessageAckHasChanged)]) {
            [delegate groupMessageAckHasChanged];
        }
    }
}

/*!
 *  \~chinese
 *  收到消息送达回执
 *
 *  @param aMessages  送达消息列表<EMMessage>
 */
- (void)messagesDidDeliver:(NSArray *)aMessages {
    for (id<QJConversationManagerDelegate> delegate in self.delegates.allObjects) {
        if ([delegate respondsToSelector:@selector(messagesDidDeliver:)]) {
            [delegate messagesDidDeliver:aMessages];
        }
    }
}

/*!
 *  \~chinese
 *  收到消息撤回
 *
 *  @param aMessages  撤回消息列表<EMMessage>
 */
- (void)messagesDidRecall:(NSArray *)aMessages {
    for (id<QJConversationManagerDelegate> delegate in self.delegates.allObjects) {
        if ([delegate respondsToSelector:@selector(messagesDidRecall:)]) {
            [delegate messagesDidRecall:aMessages];
        }
    }
}

/*!
 *  \~chinese
 *  消息状态发生变化
 *
 *  @param aMessage  状态发生变化的消息
 *  @param aError    出错信息
 */
- (void)messageStatusDidChange:(EMMessage *)aMessage
                         error:(EMError *)aError {
    for (id<QJConversationManagerDelegate> delegate in self.delegates.allObjects) {
        if ([delegate respondsToSelector:@selector(messageStatusDidChange:error:)]) {
            [delegate messageStatusDidChange:aMessage error:aError];
        }
    }
}

/*!
 *  \~chinese
 *  消息附件状态发生改变
 *
 *  @param aMessage  附件状态发生变化的消息
 *  @param aError    错误信息
 */
- (void)messageAttachmentStatusDidChange:(EMMessage *)aMessage
                                   error:(EMError *)aError {
    for (id<QJConversationManagerDelegate> delegate in self.delegates.allObjects) {
        if ([delegate respondsToSelector:@selector(messageAttachmentStatusDidChange:error:)]) {
            [delegate messageAttachmentStatusDidChange:aMessage error:aError];
        }
    }
}

@end


#pragma mark - 会话操作相关
@implementation QJConversationManager (Operations)

-(void)sendMessage:(EMMessage *)aMessage progress:(void (^)(int))aProgressBlock completion:(void (^)(EMMessage * _Nonnull, EMError * _Nonnull))aCompletionBlock {
    [[EMClient sharedClient].chatManager sendMessage:aMessage progress:aProgressBlock completion:aCompletionBlock];
}

@end
