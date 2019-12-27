//
//  QJMeViewController.m
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/7.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "QJMeViewController.h"
#import "QJSettingsViewController.h"
#import "QJMeHeaderView.h"

@interface QJMeViewController ()<QJGroupModelDelegate>

@end

@implementation QJMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.sectionHeaderHeight = 20 ;
    [self addGroupModels];
}

-(void)addGroupModels {
    // 头像组
    QJGroupModel * group1 = [[QJGroupModel alloc] init];
    group1.delegate = self ;
    // 用户信息 view
    QJMeHeaderView * headerView = [[QJMeHeaderView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.frame = CGRectMake(0, 0, self.safeFrame.size.width, 100);
    headerView.user = [QJUserManager manager].currentUser ;
    group1.headerView = headerView ;
    
    // 组2
    QJGroupModel * group2 = [[QJGroupModel alloc] init];
    group2.headerSize = CGSizeMake(0, 10);
    [group2.models addObject:[QJArrowModel modelWithImageName:@"MoreMyFavorites" title:@"收藏" subTitle:nil]];
    [group2.models addObject:[QJArrowModel modelWithImageName:@"MoreMyAlbum" title:@"相册" subTitle:nil]];
    [group2.models addObject:[QJArrowModel modelWithImageName:@"MoreMyBankCard" title:@"卡包" subTitle:nil]];
    [group2.models addObject:[QJArrowModel modelWithImageName:@"MoreExpressionShops" title:@"表情" subTitle:nil]];
    
    // 组3
    QJGroupModel * group3 = [[QJGroupModel alloc] init];
    group3.headerSize = CGSizeMake(0, 10);
    [group3.models addObject:[QJArrowModel modelWithImageName:@"MoreSetting" title:@"设置" subTitle:nil]];
    
    [self.groups addObject:group1];
    [self.groups addObject:group2];
    [self.groups addObject:group3];
    
    [self.tableView reloadData];

}

#pragma mark - QJGroupModelDelegate

-(void)groupModel:(QJGroupModel *)groupModel didSelectHeaderView:(UIView *)headerView {
    NSLog(@"%ld , headerView = %@",groupModel.section , headerView);
}

#pragma mark - QJBaseModelDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QJBaseModel * model = self.groups[indexPath.section].models[indexPath.row];
    QJLog(@"%@",model.title);
    
    if ([model.title isEqualToString:@"设置"]) { // 设置
        [self.navigationController pushViewController:[[QJSettingsViewController alloc] init] animated:YES];
    }
}

@end
