//
//  QJHomeTableViewCell.m
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/16.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "QJHomeTableViewCell.h"

@implementation QJHomeTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {
        
    }
    return self ;
}

-(void)setConversation:(EMConversation *)conversation {
    _conversation = conversation ;
    
    QJContactModel * contact = [[QJContactManager manager] getContactModelWithAccount:conversation.latestMessage.to];
    self.imageView.image = [UIImage imageNamed:contact.iconUrlStr];
    self.textLabel.text = conversation.latestMessage.to;
    if (conversation.latestMessage.body.type == EMMessageBodyTypeText) {
        EMTextMessageBody * body = (EMTextMessageBody *)conversation.latestMessage.body ;
        self.detailTextLabel.text = body.text ;

    }
}

@end
