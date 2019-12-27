//
//  QJNewFriendViewController.m
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/12.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "QJNewFriendViewController.h"

@interface QJNewFriendViewController ()

@end

@implementation QJNewFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addGroups];
}

-(void)addGroups {
    //  添加第 1 组
    QJGroupModel * group1 = [QJGroupModel groupModel];
    group1.headerSize = CGSizeMake(0, 30);
    group1.headerTitle = @"最近";
    [self addGroup:group1];
    // 好友
    for (QJContactModel * contact in [QJContactManager manager].askContacts) {
        [group1 addBaseModel:[QJBaseModel modelWithImageName:@"add_friend_icon_offical" title:contact.noteName subTitle:contact.reason]];
    }
    
    [self.tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60 ;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QJButton * checkBtn = [[QJButton alloc] init];
    [checkBtn setTitle:@"查看" forState:QJControlStateNormal];
    checkBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [checkBtn setTitleColor:QJColor(119, 215, 55, 1.0) forState:QJControlStateNormal];
    [checkBtn setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1.0] forState:QJControlStateNormal];
    [checkBtn setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0] forState:QJControlStateHighlighted];
    [checkBtn setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1.0] forState:QJControlStateDisabled];

    checkBtn.frame = CGRectMake(0, 0, 40, 30);
    checkBtn.layer.masksToBounds = YES ;
    checkBtn.layer.cornerRadius = 4 ;
    checkBtn.tag = indexPath.row ;
    [checkBtn addTarget:self action:@selector(checkBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.accessoryView = checkBtn;
}

-(void)checkBtnClicked:(UIButton *)btn {
    
    UIAlertController * actionSheet = [UIAlertController alertControllerWithTitle:@"好友请求" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * consentAction = [UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        QJContactModel * model = [QJContactManager manager].askContacts[btn.tag];
        [QJContactManager consentAskAddFriendForContact:model finish:^(BOOL seccess) {
            btn.enabled = !seccess ;
        }];
    }];
    [actionSheet addAction:consentAction];
    
    UIAlertAction * declineAction = [UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        QJContactModel * model = [QJContactManager manager].askContacts[btn.tag];
        [QJContactManager declineAskAddFriendForContact:model finish:^(BOOL seccess) {
            btn.enabled = !seccess ;
        }];
    }];
    [actionSheet addAction:declineAction];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [actionSheet addAction:cancelAction];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}



@end
