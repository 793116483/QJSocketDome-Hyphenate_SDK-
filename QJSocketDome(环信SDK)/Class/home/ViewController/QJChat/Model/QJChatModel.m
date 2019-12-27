//
//  QJChatModel.m
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/10.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "QJChatModel.h"
#import "QJConversationManager.h"

@implementation QJChatModel

-(void)setMessage:(EMMessage *)message {
    _message = message ;
    
    [self setValue:[NSDate dateStringWithTimeInterval:message.timestamp dateFormat:@"yyyy MM-dd HH:mm"] forKeyPath:@"time"];
    [self setValue:@(message.direction) forKeyPath:@"fromeType"];
    [self setValue:@(message.chatType) forKeyPath:@"chatType"];
    QJContactModel * contact = [[QJContactManager manager] getContactModelWithAccount:message.from];
    [self setValue:contact.noteName forKeyPath:@"userName"];
    [self setValue:contact.iconUrlStr forKeyPath:@"iconUrlStr"];
}
+(instancetype)chatModelWithMessage:(EMMessage *)message {
    
    if (!message) {
        return nil ;
    }
    
    QJChatModel * chatModel = [[self alloc] init];
    chatModel.message = message ;
    return chatModel ;
}

+(instancetype)chatModelWithSendToContact:(QJContactModel *)toContact extension:(NSDictionary *)extDic {
    
    NSString * conversationID = [[QJConversationManager manager] createConversationIDWithContacts:@[ toContact]];
    EMMessage * message = [[EMMessage alloc] initWithConversationID:conversationID from:[QJUserManager manager].currentUser.account to:toContact.account body:nil ext:extDic];
    message.chatType = EMChatTypeChat ;
    
    return [self chatModelWithMessage:message];
}

@end
