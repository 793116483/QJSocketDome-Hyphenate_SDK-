//
//  QJUserManager.h
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/7.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QJUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@class QJUserManager ;
@protocol QJUserManagerDelegate <NSObject>

@optional
// 登录状态改变：成功 或 退出登录
-(void)userManager:(QJUserManager *)manager loginStateChanged:(BOOL)isLogin ;

-(void)userManager:(QJUserManager *)manager connectionStateChanged:(BOOL)isConnected ;

@end

@interface QJUserManager : NSObject

@property (nonatomic , assign , readonly) BOOL isConnected ;
@property (nonatomic , assign) BOOL isLoging ;

@property (nonatomic , strong) QJUserModel * currentUser ;

+(instancetype)manager ;


/// 添加代理 ，用完后需要主动移除
/// @param delegate 代理
-(void)addDelegate:(nonnull __weak id<QJUserManagerDelegate>)delegate ;
-(void)removeDelegate:(nonnull id<QJUserManagerDelegate>)delegate ;
@end

NS_ASSUME_NONNULL_END
