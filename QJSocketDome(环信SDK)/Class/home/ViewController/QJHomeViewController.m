//
//  QJHomeViewController.m
//  
//
//  Created by 瞿杰 on 2019/12/7.
//

#import "QJHomeViewController.h"
#import "QJConversationManager.h"
#import "QJHomeTableViewCell.h"
#import "QJChatViewController.h"

@interface QJHomeViewController ()<QJUserManagerDelegate , QJConversationManagerDelegate>

/// 会话列表
@property (nonatomic , readonly) NSArray<EMConversation *> * conversations ;

@end

@implementation QJHomeViewController

-(void)dealloc {
    // 移除监听
    [[QJUserManager manager] removeDelegate:self];
    [[QJConversationManager manager] removeDelegate:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitleView];
    [self.tableView registerClass:[QJHomeTableViewCell class] forCellReuseIdentifier:@"QJHomeTableViewCell"];
    
    // 添加状态监听
    [[QJUserManager manager] addDelegate:self];
    [[QJConversationManager manager] addDelegate:self];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 第一次注动调用
    [self userManager:[QJUserManager manager] connectionStateChanged:[QJUserManager manager].isConnected];
}

#pragma mark - UI
-(void)setTitleView {
    // 设置 titleView
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    titleView.textColor = [UIColor whiteColor];
    titleView.textAlignment = UITextAlignmentCenter ;
    titleView.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    self.navigationItem.titleView = titleView ;
}

#pragma mark - QJUserManagerDelegate
-(void)userManager:(QJUserManager *)manager connectionStateChanged:(BOOL)isConnected {
    UILabel * titleView = (UILabel *)self.navigationItem.titleView ;
    if (isConnected) {
        titleView.text = @"微信";
    } else {
        titleView.text = @"微信(未联接)";
    }
}

#pragma mark - QJConversationManagerDelegate
-(void)conversationListDidUpdate:(NSArray<EMConversation *> *)aConversationList {
    [self.tableView reloadData];
}
-(void)messagesDidReceive:(NSArray<EMMessage *> *)aMessages {
    [self conversationListDidUpdate:self.conversations];
}

#pragma mark -
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.conversations.count ;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QJHomeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"QJHomeTableViewCell" forIndexPath:indexPath];
    
    cell.conversation = self.conversations[indexPath.row];
    
    return cell ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80 ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QJChatViewController * chatVc = [[QJChatViewController alloc] init];
    chatVc.conversation = self.conversations[indexPath.row];
    
    if ([[QJUserManager manager].currentUser.account isEqualToString:chatVc.conversation.latestMessage.to]) {
        chatVc.contactModel = [[QJContactManager manager] getContactModelWithAccount:chatVc.conversation.latestMessage.from];
    } else {
        chatVc.contactModel = [[QJContactManager manager] getContactModelWithAccount:chatVc.conversation.latestMessage.to];
    }
    [self.navigationController pushViewController:chatVc animated:YES];
    
}

#pragma mark - 懒加载
-(NSArray<EMConversation *> *)conversations {
    return [QJConversationManager manager].conversations ;
}

@end
