//
//  QJTextChatModelFrame.m
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/10.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "QJTextChatModelFrame.h"
#import "QJTextChatModel.h"

@implementation QJTextChatModelFrame

-(void)calculateFrameWithContentMaxWidth:(CGFloat)maxWidth {
    [super calculateFrameWithContentMaxWidth:maxWidth];
    
    QJTextChatModel * textChatModel = (QJTextChatModel *)self.chatModel ;
    
    // 计算聊天正文按妞textBtn 的frame
    CGSize textSize = [textChatModel.text sizeWithMaxSize:CGSizeMake(maxWidth - self.iconFrame.size.width - spaceOfTimeAndContent * 2 , CGFLOAT_MAX) font:TextFont];
    CGFloat textY = self.iconFrame.origin.y;
    CGFloat textX ;
    CGFloat edgeW = spaceOfTimeAndContent * 2  ; // 内边距
    if (self.chatModel.fromeType == QJFromeTypeMe) {
        textX = self.iconFrame.origin.x - textSize.width - edgeW*2;
    }
    else{
        textX = CGRectGetMaxX(self.iconFrame) + spaceOfTimeAndContent ;
    }
    self.textFrame = CGRectMake(textX, textY, textSize.width + edgeW*2, textSize.height+edgeW*2);
    
    self.cellHieght = MAX(CGRectGetMaxY(self.textFrame), CGRectGetMaxY(self.iconFrame)) + spaceOfTimeAndContent;
}



@end
