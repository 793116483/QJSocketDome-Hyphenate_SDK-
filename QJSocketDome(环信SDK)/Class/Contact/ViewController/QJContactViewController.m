//
//  QJContactViewController.m
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/7.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "QJContactViewController.h"
#import "QJContactDetailsViewController.h"
#import "QJNewFriendViewController.h"

@interface QJContactViewController ()<QJContactManagerDelegate,QJGroupModelDelegate >

@property (nonatomic , readonly) NSArray<QJContactModel *> * contacts ;
@property (nonatomic , readonly) NSArray<QJContactModel *> * askContacts ;

@end

@implementation QJContactViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [[QJContactManager manager] addDelegate:self];
    }
    return self ;
}
-(void)dealloc{
    [[QJContactManager manager] removeDelegate:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavBarView];
}


#pragma mark - UI
-(void)setUpNavBarView {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"contacts_add_friend" target:self action:@selector(addFriend)];
    
    [self resetGroups];
}

-(void)resetGroups {
    [self.groups removeAllObjects];
    
    // 1. 添加第 1 组
    QJGroupModel * group1 = [QJGroupModel groupModel];
    [self addGroup:group1];
    // 1.1 新的朋友
    QJBaseModel * model = [QJBaseModel modelWithImageName:@"plugins_FriendNotify" title:@"新的朋友" subTitle:nil] ;
    if (self.askContacts.count) {
        model.hintText = [NSString stringWithFormat:@"%ld   ",self.askContacts.count];
    }
    
    [group1 addBaseModel:model];
    
    // 1.2 other model
    [group1 addBaseModel:[QJBaseModel modelWithImageName:@"add_friend_icon_addgroup" title:@"群聊" subTitle:nil ]];
    [group1 addBaseModel:[QJBaseModel modelWithImageName:@"Contact_icon_ContactTag" title:@"标签" subTitle:nil ]];
    [group1 addBaseModel:[QJBaseModel modelWithImageName:@"add_friend_icon_offical" title:@"公众号" subTitle:nil ]];
    
    // 2. 添加第 2 组
    QJGroupModel * group2 = [QJGroupModel groupModel];
    group2.headerSize = CGSizeMake(0, 15);
    [self addGroup:group2];
    // 好友
    for (QJContactModel * contact in self.contacts) {
        [group2 addBaseModel:[QJBaseModel modelWithImageName:@"add_friend_icon_offical" title:contact.noteName subTitle:nil ]];
    }
    
    [self.tableView reloadData];
}

#pragma mark - QJTableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 55;
    }
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            QJNewFriendViewController * newFriendVc = [[QJNewFriendViewController alloc] init];
            [self.navigationController pushViewController:newFriendVc animated:YES];
        }
        
    } else if (indexPath.section == 1) {
        QJContactModel * contactModel = self.contacts[indexPath.row];
        QJContactDetailsViewController * detailsVc = [[QJContactDetailsViewController alloc] init];
        detailsVc.contactModel = contactModel ;
        
        [self.navigationController pushViewController:detailsVc animated:true];
    }
}

#pragma mark - QJContactManagerDelegate

/// 添加了 好友
/// @param manager 管理联系人对象
/// @param contact 已经 添加了 好友
-(void)contactManager:(QJContactManager *)manager contactsDidAdd:(QJContactModel *)contact {
    [self resetGroups];
    
    [[QJAppNotificationManager manager] postLocalNotificationWithTitle:@"添加好友成功" message:[NSString stringWithFormat:@"好友【%@】添加成功",contact.account] userInfo:nil];
}

/// 其他人 请求添加 你为好友
/// @param manager 管理联系人对象
/// @param askContact 请求添加为好友的 联系人
-(void)contactManager:(QJContactManager *)manager otherAskAddFriendBy:(QJContactModel *)askContact {
    // 新朋友模型
    [self resetGroups] ;
    
    // 发本地通知
    [[QJAppNotificationManager manager] postLocalNotificationWithTitle:@"添加好友" message:[NSString stringWithFormat:@"【%@】请求添加您为好友",askContact.account] userInfo:nil];
}

/// 移除 好友 回调
/// @param manager 管理联系人对象
/// @param contact 被移除的 好友
-(void)contactManager:(QJContactManager *)manager didRemoveContact:(QJContactModel *)contact {
    
    [self resetGroups];

    [self.tableView reloadData];
    
    [[QJAppNotificationManager manager] postLocalNotificationWithTitle:@"删除好友" message:[NSString stringWithFormat:@"好友【%@】从好友列表被删除了",contact.account] userInfo:nil];
}

/// 请求添加好友 被拒绝
/// @param manager 管理联系人对象
/// @param contact 拒绝你请求的联系人
-(void)contactManager:(QJContactManager *)manager askDidDeclineBy:(QJContactModel *)contact {
    QJLog(@"请求添加好友 被 (%@) 拒绝",contact.account);
    if ([contact.account isEqualToString:[QJUserManager manager].currentUser.account]) {
        [self resetGroups];
        [self.tableView reloadData];
    } else {
        [[QJAppNotificationManager manager] postLocalNotificationWithTitle:@"添加好友被拒" message:[NSString stringWithFormat:@"你添加的【%@】拒绝您的请求",contact.account] userInfo:nil];
    }
}

#pragma mark - 添加好友
-(void)addFriend {
    
    UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:@"添加好友" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertVc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入好友账号";
    }];
    [alertVc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入好友验证信息";
    }];
    
    [alertVc addAction:[UIAlertAction actionWithTitle:@"发送" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        // 发送添加好友请求
        [QJContactManager addContactWithAccount:alertVc.textFields.firstObject.text reason:alertVc.textFields.lastObject.text];
        
    }]];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:alertVc animated:YES completion:nil];
}

#pragma mark - 懒加载
-(NSArray<QJContactModel *> *)contacts {
    return [QJContactManager manager].contacts;
}
-(NSArray<QJContactModel *> *)askContacts {
    // 应用角标
    [UIApplication sharedApplication].applicationIconBadgeNumber = [QJContactManager manager].askContacts.count ;
    return [QJContactManager manager].askContacts;
}

@end
