//
//  QJContactDetailsViewController.m
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/10.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "QJContactDetailsViewController.h"
#import "QJContactModel.h"
#import "QJMeHeaderView.h"
#import "QJChatViewController.h"
#import "QJContactSettingViewController.h"
#import "QJConversationManager.h"

@interface QJContactDetailsViewController ()<QJGroupModelDelegate >

@end

@implementation QJContactDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUI];
}

#pragma mark - UI
-(void)setUI {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"barbuttonicon_more" target:self action:@selector(more)];
    
    [self resetGroups];
}

-(void)resetGroups {
    [self.groups removeAllObjects];
    
    // 添加第0组：用户信息
    QJGroupModel * group0 = [QJGroupModel groupModel];
    QJMeHeaderView * headerView = [[QJMeHeaderView alloc] init];
    headerView.accessoryType = UITableViewCellAccessoryNone ;
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.frame = CGRectMake(0, 0, self.safeFrame.size.width, 100);
    headerView.user = [QJUserModel userModelWithAccount:self.contactModel.account pwd:nil];
    group0.headerView = headerView ;
    [self addGroup:group0];
    
    QJGroupModel * group1 = [QJGroupModel groupModel];
    group1.headerSize = CGSizeMake(0, 0.5); // 分割线
    [self addGroup:group1];
    [group1 addBaseModel:[QJArrowModel modelWithImageName:nil title:@"设置备注和标签" subTitle:nil]];
    [group1 addBaseModel:[QJBaseModel modelWithImageName:nil title:@"电话号码  1213234323" subTitle:nil]];


    // 1. 添加第 2 组
    QJGroupModel * group2 = [QJGroupModel groupModel];
    group2.headerSize = CGSizeMake(0, 15); // 分割线
    [self addGroup:group2];
    [group2 addBaseModel:[QJArrowModel modelWithImageName:nil title:@"朋友圈" subTitle:nil]];
    [group2 addBaseModel:[QJArrowModel modelWithImageName:nil title:@"更多信息" subTitle:nil]];
    
    // 2. 添加第 3 组 : 发送安钮
    QJGroupModel * group3 = [QJGroupModel groupModel];
    group3.delegate = self ;
    group3.headerSize = CGSizeMake(0, 15); // 分割线
    // 发消息
    UIButton * sendBtn = [[UIButton alloc] init];
    sendBtn.enabled = NO ;
    sendBtn.frame = CGRectMake(0, 0, self.safeFrame.size.width, 50);
    sendBtn.backgroundColor = [UIColor whiteColor];
    [sendBtn setTitle:@"发消息" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor colorWithWhite:0.3 alpha:1.0] forState:UIControlStateNormal];
    group3.footerView = sendBtn ;
    [self addGroup:group3];
    
    [self.tableView reloadData];
}
#pragma mark - 事件点击
-(void)more {
    QJLog(@"点击更多");
    
    QJContactSettingViewController * vc = [[QJContactSettingViewController alloc] init];
    vc.contact = self.contactModel ;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - QJGroupModelDelegate

- (void)groupModel:(QJGroupModel *)groupModel didSelectFooterView:(UIView *)footerView {
    QJLog(@"发消息");
    QJChatViewController * chatVc = [[QJChatViewController alloc] init];
    chatVc.contactModel = self.contactModel ;
    [self.navigationController pushViewController:chatVc animated:YES];
}

#pragma mark - QJBaseModelDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 55;
    }
    return 60;
}



@end
