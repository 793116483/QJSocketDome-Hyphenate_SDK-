//
//  QJTextChatModelFrame.h
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/10.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "QJChatModelFrame.h"

NS_ASSUME_NONNULL_BEGIN

/// 内容显示的字体大小
#define TextFont [UIFont systemFontOfSize:16]

@interface QJTextChatModelFrame : QJChatModelFrame
/**
 *  正文的frame
 */
@property (assign , nonatomic)CGRect textFrame;

@end

NS_ASSUME_NONNULL_END
