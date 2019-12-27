//
//  QJInputView.h
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/10.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QJInputView : UIView

/// 注意：
/// 当前 InputView 是否用自动布局方式添加到 父控件的
@property (nonatomic , assign) BOOL isAutolayout ;

/// 中间的输入框
@property (nonatomic , strong , readonly) UITextView *inputTextView;


/// 键盘的 发送按钮 被点击回调
@property (nonatomic , copy) void(^sendActionCallBackBlock)(UITextView * textView) ;

@end

NS_ASSUME_NONNULL_END
