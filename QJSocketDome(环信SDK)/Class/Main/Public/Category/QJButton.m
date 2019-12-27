//
//  QJButton.m
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/10.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "QJButton.h"
#import <objc/message.h>

typedef NS_OPTIONS(NSUInteger, QJFlagDicForStat) {
    QJFlagDicForStatBackgroundColors ,
    QJFlagDicForStatImages ,
    QJFlagDicForStatBackgroundImages ,
    QJFlagDicForStatTitles ,
    QJFlagDicForStatTitleColors ,
    QJFlagDicForStatTitleShadowColors ,
};

@interface QJButton ()

@property (nonatomic , strong) NSMutableDictionary<NSNumber *,UIColor *> * bgColorsForState;
@property (nonatomic , strong) NSMutableDictionary<NSNumber *,UIImage *> * imagesForState;
@property (nonatomic , strong) NSMutableDictionary<NSNumber *,UIImage *> * bgImagesForState;
@property (nonatomic , strong) NSMutableDictionary<NSNumber *,NSString *> * titlesForState;
@property (nonatomic , strong) NSMutableDictionary<NSNumber *,UIColor *> * titleColorsForState;
@property (nonatomic , strong) NSMutableDictionary<NSNumber *,UIColor *> * titleShadowColorsForState;

@end

@implementation QJButton

-(void)setObject:(id)objct flag:(QJFlagDicForStat)flag forState:(QJControlState)state {
    NSMutableDictionary * dicForState = nil ;
    if (flag == QJFlagDicForStatBackgroundColors) dicForState = self.bgColorsForState ;
    if (flag == QJFlagDicForStatImages) dicForState = self.imagesForState ;
    if (flag == QJFlagDicForStatBackgroundImages) dicForState = self.bgImagesForState ;
    if (flag == QJFlagDicForStatTitles) dicForState = self.titlesForState ;
    if (flag == QJFlagDicForStatTitleColors) dicForState = self.titleColorsForState ;
    if (flag == QJFlagDicForStatTitleShadowColors) dicForState = self.titleShadowColorsForState ;

    if (state == QJControlStateNormal) {
        dicForState[@(state)] = objct ;
        if (!dicForState[@(QJControlStateHighlighted)]) {
            dicForState[@(QJControlStateHighlighted)] = objct ;
        }
        if (!dicForState[@(QJControlStateSelected)]) {
            dicForState[@(QJControlStateSelected)] = objct ;
        }
        if (!dicForState[@(QJControlStateSelectedHighlighted)]) {
            dicForState[@(QJControlStateSelectedHighlighted)] = objct ;
        }
        if (!dicForState[@(QJControlStateDisabled)]) {
            dicForState[@(QJControlStateDisabled)] = objct ;
        }
    } else {
         if (state & QJControlStateHighlighted) dicForState[@(QJControlStateHighlighted)] = objct ;
        if (state & QJControlStateDisabled) dicForState[@(QJControlStateDisabled)] = objct ;
        
        // 设置 selected
        if (state & QJControlStateSelected) {
            dicForState[@(QJControlStateSelected)] = objct ;
            if (!dicForState[@(QJControlStateSelectedHighlighted)] ||
                dicForState[@(QJControlStateSelectedHighlighted)] == dicForState[@(QJControlStateNormal)]) {
                dicForState[@(QJControlStateSelectedHighlighted)] = objct ;
            }
        }
        // 设置 selected highlighted
        if (state & QJControlStateSelectedHighlighted) dicForState[@(QJControlStateSelectedHighlighted)] = objct ;
    }
    
    [self setMessageWhenStateChange];
}
#pragma mark - 根据状态 设置 title
-(void)setTitle:(NSString *)title forState:(QJControlState)state {
        
    [self setObject:title flag:QJFlagDicForStatTitles forState:state];
}
-(void)setTitleColor:(UIColor *)color forState:(QJControlState)state {
        
    [self setObject:color flag:QJFlagDicForStatTitleColors forState:state];
}
-(void)setTitleShadowColor:(UIColor *)color forState:(QJControlState)state {
        
    [self setObject:color flag:QJFlagDicForStatTitleShadowColors forState:state];
}
#pragma mark - 根据状态 设置 image
-(void)setImage:(UIImage *)image forState:(QJControlState)state {
        
    [self setObject:image flag:QJFlagDicForStatImages forState:state];
}
-(void)setBackgroundImage:(UIImage *)image forState:(QJControlState)state {
    [self setObject:image flag:QJFlagDicForStatBackgroundImages forState:state];
}
#pragma mark - 根据状态 设置 背景色
-(void)setBackgroundColor:(UIColor *)color forState:(QJControlState)state {
    
    [self setObject:color flag:QJFlagDicForStatBackgroundColors forState:state];
}

-(void)setBackgroundColor:(UIColor *)backgroundColor {
    if (_backgroundColor == backgroundColor) return ;
    _backgroundColor = backgroundColor ;
    [self setObject:backgroundColor flag:QJFlagDicForStatBackgroundColors forState:QJControlStateNormal];
}

-(void)setHighlighted:(BOOL)highlighted {
    if (self.highlighted == highlighted) return ;
    
    [super setHighlighted:highlighted];
    self.pressing = highlighted ;
    [self setMessageWhenStateChange];
}

-(void)setEnabled:(BOOL)enabled {
    if (self.enabled == enabled) return ;
    
    [super setEnabled:enabled];
    [self setMessageWhenStateChange];
}

-(void)setSelected:(BOOL)selected {
    if (self.selected == selected) return ;

    [super setSelected:selected];
    [self setMessageWhenStateChange];
}

@synthesize state_qj = _state_qj ;
-(void)setMessageWhenStateChange {
    [self state_qj];
    [super setBackgroundColor:self.bgColorsForState[@(_state_qj)]];
    UIControlState systemState = (UIControlState)_state_qj ;
    if (_state_qj == QJControlStateSelectedHighlighted) {
        systemState = UIControlStateNormal ;
    } else {
        
    }
    [super setTitle:self.titlesForState[@(_state_qj)] forState:systemState];
    [super setTitleColor:self.titleColorsForState[@(_state_qj)] forState:systemState];
    [super setTitleShadowColor:self.titleShadowColorsForState[@(_state_qj)] forState:systemState];
    [super setImage:self.imagesForState[@(_state_qj)] forState:systemState];
    [super setBackgroundImage:self.bgImagesForState[@(_state_qj)] forState:systemState];
}
#pragma mark - 懒加载
-(QJControlState)state_qj {
    if (!self.enabled) {
        _state_qj = QJControlStateDisabled ;
    }else if (self.selected) {
        _state_qj = QJControlStateSelected ;
        if (self.highlighted) {
            _state_qj = QJControlStateSelectedHighlighted ;
        }
    }else if (self.highlighted) {
        _state_qj = QJControlStateHighlighted ;
    }
    else {
        _state_qj = QJControlStateNormal ;
    }
    return _state_qj ;
}
-(NSMutableDictionary<NSNumber *,UIColor *> *)bgColorsForState {
    if (!_bgColorsForState) {
        _bgColorsForState = [NSMutableDictionary dictionary];
    }
    return _bgColorsForState ;
}
-(NSMutableDictionary<NSNumber *,UIImage *> *)imagesForState {
    if (!_imagesForState) {
        _imagesForState = [NSMutableDictionary dictionary];
    }
    return _imagesForState ;
}
-(NSMutableDictionary<NSNumber *,UIImage *> *)bgImagesForState {
    if (!_bgImagesForState) {
        _bgImagesForState = [NSMutableDictionary dictionary];
    }
    return _bgImagesForState ;
}
-(NSMutableDictionary<NSNumber *,NSString *> *)titlesForState{
    if (!_titlesForState) {
        _titlesForState = [NSMutableDictionary dictionary];
    }
    return _titlesForState ;
}
-(NSMutableDictionary<NSNumber *,UIColor *> *)titleColorsForState {
    if (!_titleColorsForState) {
        _titleColorsForState = [NSMutableDictionary dictionary] ;
    }
    return _titleColorsForState ;
}
-(NSMutableDictionary<NSNumber *,UIColor *> *)titleShadowColorsForState {
    if (!_titleShadowColorsForState) {
        _titleShadowColorsForState = [NSMutableDictionary dictionary] ;
    }
    return _titleShadowColorsForState ;
}

@end
