//
//  QJTextChatModel.m
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/10.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "QJTextChatModel.h"

@implementation QJTextChatModel

-(void)setText:(NSString *)text {
    _text = text ;
    
    EMTextMessageBody * textBody = [[EMTextMessageBody alloc] initWithText:text];
    self.message.body = textBody ;
}

-(void)setMessage:(EMMessage *)message {
    [super setMessage:message];
    
    EMTextMessageBody * textBody = (EMTextMessageBody *)message.body ;
    _text = textBody.text ;
}

@end
