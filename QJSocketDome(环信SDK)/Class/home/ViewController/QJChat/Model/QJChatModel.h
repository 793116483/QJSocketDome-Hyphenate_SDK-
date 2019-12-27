//
//  QJChatModel.h
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/10.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    QJFromeTypeMe = 0,
    QJFromeTypeOther
}QJFromeType;
typedef enum {
    QJChatTypeChat = 0,     // 单聊消息
    QJChatTypeGroupChat ,   // 群聊消息
    QJChatTypeChatRoom ,    // 聊天室消息
}QJChatType;
 
@interface QJChatModel : NSObject
 
@property (nonatomic , copy , nullable , readonly) NSString * time;
@property (nonatomic , copy , nullable , readonly) NSString * iconUrlStr ;
@property (nonatomic , copy , nullable , readonly) NSString * userName ;
@property (nonatomic , assign   , readonly) QJFromeType fromeType ;
@property (nonatomic , assign   , readonly) QJChatType chatType ;

@property (nonatomic , nullable , strong) EMMessage * message ;

+(nullable instancetype)chatModelWithMessage:(EMMessage *)message ;

/// 当前用户发送信息 需要的创建方式
/// @param toContact 发送信息给谁
/// @param extDic 扩展信息
+(instancetype)chatModelWithSendToContact:(QJContactModel *)toContact extension:(nullable NSDictionary *)extDic;
@end

NS_ASSUME_NONNULL_END
