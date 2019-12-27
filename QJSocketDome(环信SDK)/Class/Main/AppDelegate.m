//
//  AppDelegate.m
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/6.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "AppDelegate.h"
#import "QJTabBarViewController.h"
#import "QJLoginViewController.h"

@interface AppDelegate ()<QJUserManagerDelegate>

@end

@implementation AppDelegate

-(void)dealloc {
    [[QJUserManager manager] removeDelegate:self];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self initWithApplication:application];

    [[QJAppNotificationManager manager] application:application didFinishLaunchingWithOptions:launchOptions];
    
    return YES;
}
#pragma mark - 初始化
-(void)initWithApplication:(UIApplication *) application{
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIViewController * rootVc = [[QJLoginViewController alloc] init];
    if ([QJUserManager manager].isLoging) {
        rootVc = [[QJTabBarViewController alloc] init];
    }
    self.window.rootViewController = rootVc ;
    [self.window makeKeyAndVisible];
    
    // 获取 联系人数据
    [[QJContactManager manager] initContactManager];
    
    // 添加代理 , 监听登录状态
    [[QJUserManager manager] addDelegate:self];
        
    // 注册
    [self registerWithApplication:application];
}

#pragma mark - QJUserManagerDelegate
-(void)userManager:(QJUserManager *)manager loginStateChanged:(BOOL)isLogin {
    
    UIViewController * rootVc = [[QJLoginViewController alloc] init];
    if (isLogin) {
        rootVc = [[QJTabBarViewController alloc] init];

        // 获取数据
        [[QJContactManager manager] initContactManager];
    }
    self.window.rootViewController = rootVc ;
}

#pragma mark - 注册
-(void)registerWithApplication:(UIApplication *) application {
    // 注册环信AppKey
    EMOptions * options = [EMOptions optionsWithAppkey:kSocketAppKey];
    options.enableConsoleLog = true;
//    options.apnsCertName = @"xxx";
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    // 注册推送 通知
    [[QJAppNotificationManager manager] registerNotificationWithApplication:application];
}

#pragma mark - APP 代理方法

-(void)applicationDidEnterBackground:(UIApplication *)application {
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}
-(void)applicationWillEnterForeground:(UIApplication *)application {
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}


#pragma mark - 推送相关
// 本地推送
-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)(void))completionHandler {
    
    [[QJAppNotificationManager manager] application:application handleActionWithIdentifier:identifier forLocalNotification:notification withResponseInfo:responseInfo completionHandler:completionHandler];
}
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    [[QJAppNotificationManager manager] application:application didReceiveLocalNotification:notification];
}
// 远程推送
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
    [[QJAppNotificationManager manager] application:application didFailToRegisterForRemoteNotificationsWithError:error];
}
-(void)application:(UIApplication *)application
                didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken{
    
    [[QJAppNotificationManager manager] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [[QJAppNotificationManager manager] application:application didReceiveRemoteNotification:userInfo];
}


@end
