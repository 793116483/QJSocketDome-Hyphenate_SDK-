//
//  QJImageChatModelFrame.m
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/10.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "QJImageChatModelFrame.h"
#import "QJImageChatModel.h"

@implementation QJImageChatModelFrame

-(void)calculateFrameWithContentMaxWidth:(CGFloat)maxWidth {
    [super calculateFrameWithContentMaxWidth:maxWidth];
    
    QJImageChatModel * imageChatModel = (QJImageChatModel *)self.chatModel ;
    
    // 图片高宽比
    CGFloat scale = 1.0 ;
    if (imageChatModel.image.size.width > 0) {
        scale = imageChatModel.image.size.height / imageChatModel.image.size.width ;
    }
    // 图片size
    CGSize imageSize = imageChatModel.image.size ;
    if (imageSize.width > maxWidth - self.iconFrame.size.width - spaceOfTimeAndContent*2) {
        imageSize.width = maxWidth - self.iconFrame.size.width - spaceOfTimeAndContent*2 ;
    }
    if (imageSize.width > 200) imageSize.width = 200 ;
    imageSize.height = imageSize.width * scale ;
    
    CGFloat y = self.iconFrame.origin.y;//CGRectGetMaxY(self.userNameFrame) ;
    CGFloat x ;
    if (self.chatModel.fromeType == QJFromeTypeMe) {
        x = self.iconFrame.origin.x - imageSize.width - spaceOfTimeAndContent;
    }
    else{
        x = CGRectGetMaxX(self.iconFrame) + spaceOfTimeAndContent ;
    }
    self.imageFrame = CGRectMake(x, y, imageSize.width, imageSize.height);
    
    self.cellHieght = MAX(CGRectGetMaxY(self.imageFrame), CGRectGetMaxY(self.iconFrame)) + spaceOfTimeAndContent;
}

@end
