//
//  QJButton.h
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/10.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, QJControlState) {
    QJControlStateNormal                    = 0,
    QJControlStateHighlighted               = 1 << 0,
    QJControlStateDisabled                  = 1 << 1,
    QJControlStateSelected                  = 1 << 2,
    QJControlStateSelectedHighlighted       = 1 << 3,   // 按钮在 选中状态下长按
};

@interface QJButton : UIButton

/// 是否正在 按压
@property (nonatomic , getter=isPressing) BOOL pressing ;

@property (nonatomic , readonly) QJControlState state_qj ;  // 自定义的 state

/// 根据状态设置不同的 image 、bacgroundImage
/// @param state 状态
- (void)setImage:(nullable UIImage *)image forState:(QJControlState)state;
- (void)setBackgroundImage:(nullable UIImage *)image forState:(QJControlState)state ;

/// 根据状态设置不同的 title 、titleColor 、titleShadowColor
/// @param state 状态
- (void)setTitle:(nullable NSString *)title forState:(QJControlState)state; 
- (void)setTitleColor:(nullable UIColor *)color forState:(QJControlState)state ;
-(void)setTitleShadowColor:(nullable UIColor *)color forState:(QJControlState)state ;

/// 根据状态设置不同的 背景色
/// @param color 背景色
/// @param state 状态
- (void)setBackgroundColor:(nullable UIColor *)color forState:(QJControlState)state ;

#pragma mark - 被弃用的 方法

/// 背景色 , 已经被弃用，请使用 -[QJButton setBackgroundColor:forState:]
@property(nullable, nonatomic,copy)  UIColor *backgroundColor API_DEPRECATED("Use -[QJButton setBackgroundColor:forState:]",ios(2.0, 3.0));
@end

NS_ASSUME_NONNULL_END
