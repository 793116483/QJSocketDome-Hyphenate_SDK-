//
//  QJAppNotificationManager.h
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/12.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QJAppNotificationManager : NSObject

/// 单例
+(instancetype)manager ;

/// 注册通知
/// @param application 应用
-(void)registerNotificationWithApplication:(UIApplication *)application ;

#pragma mark - 本地通知
/// 处理 当app被关闭时，用户收到通知，然后点击通知，重新启动app
- (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions ;

/// 点击了 本地通知的 行为按钮 回调
/// 如果实现了这个方法，上面的方法就不会被执行
-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)(void))completionHandler ;

/// 接收到通知
/// 在前台时收到通知，可以打印
/// app在后台接收到通知，如果app进入前台，立即打印
/// 如果退出app收到的通知，重新打开app不会打印
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification ;


#pragma mark - 远程通知
/// 远程注册失败
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error ;

/// 远程注册成功后，从苹果服务器获取到 deviceToken(uuid+bundleID标识设备的app，唯一的) 传给自己的服务器保存起来
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken ;

/// 收到远程通知
/// 在前台收到 远程通知
/// 从后台进入前台收到 远程通知
/// 当app被关闭，收到远程推送通知，点击了该通知，重新调起 app 收到 远程通知
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo ;

#pragma mark - 发送本地通知

/// 发送本地通知
/// @param title 通知标题
/// @param message 通知的信息
/// @param userInfo 其他信息
-(void)postLocalNotificationWithTitle:(NSString *)title message:(NSString *)message userInfo:(nullable NSDictionary *)userInfo ;
@end

NS_ASSUME_NONNULL_END
