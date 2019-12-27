//
//  QJChatModelFrame.m
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/10.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "QJChatModelFrame.h"
#import "QJChatModel.h"

@implementation QJChatModelFrame

-(void)setChatModel:(QJChatModel *)chatModel {
    _chatModel = chatModel ;
    
    CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width - 100 ;
    [self calculateFrameWithContentMaxWidth:maxWidth];
}

/// 计算所有的 frame , 前提是 chatModel 属性先赋值 。
/// @param maxWidth 内容最大宽度
- (void)calculateFrameWithContentMaxWidth:(CGFloat)maxWidth{
        
    // 计算timeLable 的frame
    if (self.hiddenTime == NO) {
        CGFloat timeLableX = 0;
        CGFloat timeLableY = 0;
        CGFloat timeLableW = screenWidth;
        CGFloat timeLableH = 50;
        self.timeFrame = CGRectMake(timeLableX, timeLableY, timeLableW, timeLableH);
    } else {
        self.timeFrame = CGRectZero ;
    }
    
    // 计算头象iconImg 的frame
    CGFloat iconImgW = 50;
    CGFloat iconImgH = 50;
    CGFloat iconImgY = CGRectGetMaxY(self.timeFrame) + spaceOfTimeAndContent;
    CGFloat iconImgX ;
    if (self.chatModel.fromeType == QJFromeTypeMe) {
        iconImgX = screenWidth - spaceOfTimeAndContent - iconImgW;
    }
    else{
        iconImgX = spaceOfTimeAndContent ;
    }
    self.iconFrame = CGRectMake(iconImgX, iconImgY, iconImgW, iconImgH);
    
    // 用户名
    if (self.chatModel.fromeType == QJFromeTypeMe) {
        self.userNameFrame = CGRectMake(maxWidth , iconImgY, maxWidth-iconImgX - spaceOfTimeAndContent, 20);
    }
    else{
        self.userNameFrame = CGRectMake(iconImgX + iconImgW + spaceOfTimeAndContent , iconImgY, maxWidth-iconImgX-iconImgW - spaceOfTimeAndContent, 20);
    }
    
    // 计算Cell的高度
    self.cellHieght = CGRectGetMaxY(self.iconFrame) + spaceOfTimeAndContent;
}

@end
