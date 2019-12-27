//
//  QJSettingsViewController.m
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/8.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "QJSettingsViewController.h"

@interface QJSettingsViewController ()<QJGroupModelDelegate>

@property (nonatomic , strong) UIButton * logOutBtn ;

@end

@implementation QJSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addGroupModels];
}

#pragma 设置UI
-(void)addGroupModels {
    // 组1
    QJGroupModel * group1 = [QJGroupModel groupModel];
    [group1.models addObject:[QJArrowModel modelWithImageName:nil title:@"账号与安全" subTitle:nil]];
    
    CGFloat headerHeight = 8 ;
    // 组2
    QJGroupModel * group2 = [QJGroupModel groupModel];
    group2.headerSize = CGSizeMake(0, headerHeight);
    [group2.models addObject:[QJSwitchModel modelWithImageName:nil title:@"新消自提醒" subTitle:nil]];
    [group2.models addObject:[QJArrowModel modelWithImageName:nil title:@"勿扰模式" subTitle:nil]];
    [group2.models addObject:[QJArrowModel modelWithImageName:nil title:@"聊天" subTitle:nil]];
    [group2.models addObject:[QJArrowModel modelWithImageName:nil title:@"隐私" subTitle:nil]];
    [group2.models addObject:[QJArrowModel modelWithImageName:nil title:@"通用" subTitle:nil]];

    // 组3
    QJGroupModel * group3 = [QJGroupModel groupModel];
    group3.headerSize = CGSizeMake(0, headerHeight);
    
    [group3.models addObject:[QJArrowModel modelWithImageName:nil title:@"帮助与反馈" subTitle:nil]];

    QJBaseModel * model = [QJArrowModel modelWithImageName:nil title:@"关于微信" subTitle:@"版本1.0"] ;
    model.style = UITableViewCellStyleValue1 ;
    model.hintText = @"new";
    [group3.models addObject:model];
    
    // 组4
    QJGroupModel * group4 = [QJGroupModel groupModel];
    group4.headerSize = CGSizeMake(0, headerHeight);

    [group4.models addObject:[QJArrowModel modelWithImageName:nil title:@"插件" subTitle:nil]];
    
    // 组5：退出登录
    QJGroupModel * group5 = [QJGroupModel groupModel];
    group5.delegate = self ;
    group5.headerSize = CGSizeMake(0, 20);
    self.logOutBtn.frame = CGRectMake(40,0, self.safeFrame.size.width - 80, 40);
    group5.footerView = self.logOutBtn ;

    
    
    [self.groups addObject:group1];
    [self.groups addObject:group2];
    [self.groups addObject:group3];
    [self.groups addObject:group4];
    [self.groups addObject:group5];

    [self.tableView reloadData];

}

#pragma mark - QJGroupModelDelegate
-(void)groupModel:(QJGroupModel *)groupModel didSelectFooterView:(UIView *)footerView {
    // 退出登录
    if (footerView != self.logOutBtn) return ;
    
    UIAlertController * actionSheetVc = [UIAlertController alertControllerWithTitle:@"是否退出登录?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * suerAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [SVProgressHUD showWithStatus:@"正在退出登录" maskType:SVProgressHUDMaskTypeBlack];
        [[EMClient sharedClient] logout:true completion:^(EMError *aError) {
            if (!aError) {
                [QJUserManager manager].isLoging = NO ;
                [SVProgressHUD showSuccessWithStatus:@"退出成功"];
            } else {
                [SVProgressHUD showErrorWithStatus:aError.errorDescription];
            }
        }];
    }];
    
    [actionSheetVc addAction:suerAction];
    [actionSheetVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self.navigationController presentViewController:actionSheetVc animated:YES completion:nil];
}

#pragma mark - 懒加载
-(UIButton *)logOutBtn {
    if (!_logOutBtn) {
        _logOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _logOutBtn.backgroundColor = [UIColor redColor];
        [_logOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [_logOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _logOutBtn.clipsToBounds = true ;
        _logOutBtn.layer.cornerRadius = 4 ;
        _logOutBtn.userInteractionEnabled = NO ;
    }
    return _logOutBtn ;
}



@end
