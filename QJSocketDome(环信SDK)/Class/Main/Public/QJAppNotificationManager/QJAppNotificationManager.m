//
//  QJAppNotificationManager.m
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/12.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "QJAppNotificationManager.h"

@implementation QJAppNotificationManager

+(instancetype)manager {
    static dispatch_once_t onceToken;
    static QJAppNotificationManager * manager = nil ;
    dispatch_once(&onceToken, ^{
        manager = [[QJAppNotificationManager alloc] init];
    });
    return manager ;
}

-(void)registerNotificationWithApplication:(UIApplication *)application {
    // 1. 通知配制
    UIUserNotificationType type = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound ;
    
    // 2. 注册本地推送
    UIUserNotificationSettings * localNoti = [UIUserNotificationSettings settingsForTypes:type categories:[self getCategoriesForRegister]];
    [application registerUserNotificationSettings:localNoti];
    // 3. 注册远程推送
    [application registerForRemoteNotifications];
}
-(NSSet<UIUserNotificationCategory *> *) getCategoriesForRegister {

    // 1. 添加一组行为
    UIMutableUserNotificationCategory * category = [[UIMutableUserNotificationCategory alloc] init];
    category.identifier = @"标识" ;
    
    // 1.2 第 1 个行为
    UIMutableUserNotificationAction * action1 = [[UIMutableUserNotificationAction alloc] init];
    // 行为按钮文字
    action1.title = @"确定" ;
    // 在点击了 确定后，再出现一个textField文本框
    action1.behavior = UIUserNotificationActionBehaviorTextInput ;
    // 文本框
    action1.parameters = @{UIUserNotificationTextInputActionButtonTitleKey:@"发送按钮title"} ;
    // 模式: 就是点击了这个动作，是回到前台执行这个动作，还是直接在后台执行这个动作
    action1.activationMode = UIUserNotificationActivationModeForeground ;
    // true:必须解锁后,行为才会被执行,(如果 activationMode = .foreground , 那么这个属性被忽略)
    [action1 setValue:@(YES) forKeyPath:@"authenticationRequired"] ;
    // 是否是破坏性行为
    [action1 setValue:@(YES) forKeyPath:@"destructive"] ;
    
    // 1.3 第 2 个行为
    UIMutableUserNotificationAction * action2 = [[UIMutableUserNotificationAction alloc] init];
    action2.behavior = UIUserNotificationActionBehaviorTextInput ;
    action2.title = @"行为2提示title" ;
    // 模式: 就是点击了这个动作，是回到前台执行这个动作，还是直接在后台执行这个动作
    action2.activationMode = UIUserNotificationActivationModeBackground ;
    [action1 setValue:@(false) forKeyPath:@"authenticationRequired"] ;
    [action1 setValue:@(false) forKeyPath:@"destructive"] ;

    
    
    
    // 2 添加一组行为
    // default : 最多可以显示 4 个按钮
    // minimal : 最多可以显示 2 个按钮
    UIUserNotificationActionContext actionContext = UIUserNotificationActionContextDefault ;
    [category setActions:@[action1 , action2] forContext:actionContext];
    
    
    
    
    // 3 附加操作行为
    NSMutableSet<UIUserNotificationCategory *> * categories = [NSMutableSet set];
    [categories addObject:category];
    
    return categories ;
}


#pragma mark - 本地通知
/// 处理 当app被关闭时，用户收到通知，然后点击通知，重新启动app
- (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UILocalNotification * localNotif = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif){
        NSLog(@"应用进程被 kill 了，用户点击了通知启动app的，接收到本地通知");
        
        [self application:application didReceiveLocalNotification:localNotif];
    }
}

/// 点击了 本地通知的 行为按钮 回调
/// 如果实现了这个方法，上面的方法就不会被执行
-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)(void))completionHandler {
    
}

/// 接收到通知
/// 在前台时收到通知，可以打印
/// app在后台接收到通知，如果app进入前台，立即打印
/// 如果退出app收到的通知，重新打开app不会打印
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    // 处理
    
}


#pragma mark - 远程通知
/// 远程注册失败
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"注册失败 ， error = %@",error);
}

/// 远程注册成功后，从苹果服务器获取到 deviceToken(uuid+bundleID标识设备的app，唯一的) 传给自己的服务器保存起来
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken {
    
    [[EMClient sharedClient] registerForRemoteNotificationsWithDeviceToken:deviceToken completion:^(EMError *aError) {
        if (aError) {
            NSLog(@"%@",aError.errorDescription);
        }
    }];
}

/// 收到远程 通知
/// 在前台收到 远程通知
/// 从后台进入前台收到 远程通知
/// 当app被关闭，收到远程推送通知，点击了该通知，重新调起 app 收到 远程通知
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[EMClient sharedClient] application:application didReceiveRemoteNotification:userInfo];
}

#pragma mark - 处理 通知

#pragma mark - 发送本地通知
-(void)postLocalNotificationWithTitle:(NSString *)title message:(NSString *)message userInfo:(NSDictionary *)userInfo{
    // 创建本地通知
    UILocalNotification * localNotif = [[UILocalNotification alloc] init];
            
    // 显示 title 标题
    localNotif.alertTitle = title;
            
    // 设置通知的必选项
    localNotif.alertBody = message ;
    // 发送时间
    localNotif.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
            
    // 重复周期
//    localNotif.repeatInterval = .second;
    // 设置锁屏滑动文字
    localNotif.hasAction = true;
    localNotif.alertAction = @"回复";
            
    // ios 9.0前有效，之后无效
    localNotif.alertLaunchImage = @"";
            
    // 通知声音
    localNotif.soundName = @"自己导入的声音文件全名";
            
    // 其他信息
    localNotif.userInfo = userInfo;
            
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}
@end
