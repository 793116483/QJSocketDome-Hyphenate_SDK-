//
//  QJChatViewController.h
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/10.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "QJBaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class QJContactModel ;
@interface QJChatViewController : QJBaseTableViewController

@property (nonatomic , strong) QJContactModel * contactModel ;

/// 当前会话
@property (nonatomic , strong) EMConversation * conversation ;

@end

NS_ASSUME_NONNULL_END
