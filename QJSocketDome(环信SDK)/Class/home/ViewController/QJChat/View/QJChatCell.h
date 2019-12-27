//
//  QJChatCell.h
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/10.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "QJBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@class QJChatModelFrame ;
@interface QJChatCell : UITableViewCell

 @property (nonatomic , strong) QJChatModelFrame * chatModelFrame ;
+ (instancetype)messageCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
