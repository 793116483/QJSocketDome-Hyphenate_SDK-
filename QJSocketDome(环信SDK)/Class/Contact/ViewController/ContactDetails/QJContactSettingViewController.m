//
//  QJContactSettingViewController.m
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/13.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "QJContactSettingViewController.h"

@interface QJContactSettingViewController ()<QJGroupModelDelegate , QJSwitchModelDelegate>


@end

@implementation QJContactSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}

#pragma mark - UI
-(void)setUI {

    self.title = @"资料设置";
    [self resetGroups];
}

-(void)resetGroups {
    [self.groups removeAllObjects];
    
    // 添加组
    QJGroupModel * group0 = [QJGroupModel groupModel];
    QJArrowModel * model = [QJArrowModel modelWithImage:nil title:@"设置备注和标签" subTitle:self.contact.noteName];
    model.style = UITableViewCellStyleValue1 ;
    [group0 addBaseModel:model];
    [self addGroup:group0];
    
    QJGroupModel * group1 = [QJGroupModel groupModel];
    group1.headerSize = CGSizeMake(0, 10); // 分割线
    [self addGroup:group1];
    [group1 addBaseModel:[QJArrowModel modelWithImageName:nil title:@"把他推荐给朋友" subTitle:nil]];


    QJGroupModel * group2 = [QJGroupModel groupModel];
    group2.headerSize = CGSizeMake(0, 10); // 分割线
    [self addGroup:group2];
    [group2 addBaseModel:[QJSwitchModel modelWithImageName:nil title:@"设置为星标朋友" subTitle:nil]];
    
    
    QJGroupModel * group3 = [QJGroupModel groupModel];
    group3.headerSize = CGSizeMake(0, 40); // 分割线
    group3.headerTitle = @"朋友圈和视频动态";
    [self addGroup:group3];
    [group3 addBaseModel:[QJSwitchModel modelWithImageName:nil title:@"不让他看" subTitle:nil]];
    [group3 addBaseModel:[QJSwitchModel modelWithImageName:nil title:@"不看他" subTitle:nil]];
    
    QJGroupModel * group4 = [QJGroupModel groupModel];
    group4.headerSize = CGSizeMake(0, 10); // 分割线
    [self addGroup:group4];
    QJSwitchModel * switchModel = [QJSwitchModel modelWithImageName:nil title:@"加入黑名单" subTitle:nil] ;
    switchModel.on = self.contact.isBlackUser ;
    switchModel.delegate = self ;
    [group4 addBaseModel:switchModel];
    [group4 addBaseModel:[QJSwitchModel modelWithImageName:nil title:@"投诉" subTitle:nil]];
    
    
    // 2. 添加第 3 组 : 发送安钮
    QJGroupModel * group5 = [QJGroupModel groupModel];
    group5.delegate = self ;
    group5.headerSize = CGSizeMake(0, 15); // 分割线
    // 发消息
    UIButton * sendBtn = [[UIButton alloc] init];
    sendBtn.enabled = NO ;
    sendBtn.frame = CGRectMake(0, 0, self.safeFrame.size.width, 50);
    sendBtn.backgroundColor = [UIColor whiteColor];
    [sendBtn setTitle:@"删除" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    group5.footerView = sendBtn ;
    [self addGroup:group5];
    
    
    [self.tableView reloadData];
}
#pragma mark - QJGroupModelDelegate
-(void)groupModel:(QJGroupModel *)groupModel didSelectFooterView:(nonnull UIView *)footerView {
    // 删除好友
    NSString * title = [NSString stringWithFormat:@"将联系人\"%@\"删除，同时删除与该联系人的聊天记录",self.contact.noteName];
    UIAlertController * actionSheet = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleActionSheet];
   
    UIAlertAction * declineAction = [UIAlertAction actionWithTitle:@"删除联系人" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [QJContactManager deleteContact:self.contact finish:^(BOOL seccess) {
            if (seccess) [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }];
    [actionSheet addAction:declineAction];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [actionSheet addAction:cancelAction];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark - QJSwitchModelDelegate
-(void)switchModel:(QJSwitchModel *)model switchClicked:(UISwitch *)switchView {
    if (switchView.on) {
        [QJContactManager removeContactFromBlackList:self.contact finish:^(BOOL seccess) {
            if (seccess) {
                switchView.on = !switchView.on ;
                model.on = switchView.on ;
            }
        }];
    } else {
        [QJContactManager addContactToBlackList:self.contact finish:^(BOOL seccess) {
            if (seccess) {
                switchView.on = !switchView.on ;
                model.on = switchView.on ;
            }
        }];
    }
}

@end
