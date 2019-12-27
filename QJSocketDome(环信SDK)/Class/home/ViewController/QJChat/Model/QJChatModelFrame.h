//
//  QJChatModelFrame.h
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/10.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 时间 与 内容间距
#define spaceOfTimeAndContent 10
#define screenWidth  [UIScreen mainScreen].bounds.size.width

@class QJChatModel ;
@interface QJChatModelFrame : NSObject
 
/**
 *  隐藏时间
 */
@property (assign , nonatomic)BOOL hiddenTime;
/**
 *  时间的frame
 */
@property (assign , nonatomic)CGRect timeFrame;
/**
 *  头象的frame
 */
@property (assign , nonatomic)CGRect iconFrame;
/**
 *  用户名的frame
 */
@property (assign , nonatomic)CGRect userNameFrame;
/**
 *  Cell的高度
 */
@property (assign , nonatomic)CGFloat cellHieght;
 
/// 内容模型
@property (strong , nonatomic)QJChatModel * chatModel;

/// 计算所有的 frame , 前提是 chatModel 属性先赋值 。
/// @param maxWidth 内容最大宽度
-(void)calculateFrameWithContentMaxWidth:(CGFloat)maxWidth ;

@end

NS_ASSUME_NONNULL_END
