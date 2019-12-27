//
//  QJChatViewController.m
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/10.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "QJChatViewController.h"
#import "QJInputView.h"
#import "QJConversationManager.h"
#import <MJRefresh.h>
#import "QJChatCell.h"

#import "QJTextChatModel.h"
#import "QJTextChatModelFrame.h"

#import "QJImageChatModel.h"
#import "QJImageChatModelFrame.h"
 
@interface QJChatViewController ()<UITextFieldDelegate , QJConversationManagerDelegate>

@property (strong, nonatomic)NSMutableArray<QJChatModelFrame *> * messageFrames;

@property (strong, nonatomic) QJInputView * inputBottomView;
 
@end
 
@implementation QJChatViewController
 
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.contactModel.noteName ;
    
    if (!self.conversation && self.contactModel) {
        NSString * conversationID = [[QJConversationManager manager] createConversationIDWithContacts:@[self.contactModel]];
        self.conversation = [[QJConversationManager manager] getConversationWithID:conversationID type:EMConversationTypeChat];
    }
    QJLog(@"unreadMessagesCount = %d",self.conversation.unreadMessagesCount);
    
    [self setUI];
}

#pragma mark - UI
-(void)setUI {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"barbuttonicon_more" target:self action:@selector(checkDetails)];
    
     // 设置tableView的数据源,代理和一些属性
    self.tableView.allowsSelection = NO; // tableView中的cell不允许选中
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone; // cell的分隔线类型
    [self.tableView registerClass:[QJChatCell class] forCellReuseIdentifier:@"QJChatCell"];
    self.tableView.frame = CGRectMake(0, self.safeFrame.origin.y, self.safeFrame.size.width, self.safeFrame.size.height - 50);
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshOldMessage)];
    
        
    // 底部
    self.inputBottomView = [[QJInputView alloc] init];
    self.inputBottomView.frame = CGRectMake(0, CGRectGetMaxY(self.tableView.frame), self.safeFrame.size.width, 50) ;
    __weak typeof(self) weakSelf = self ;
    self.inputBottomView.sendActionCallBackBlock = ^(UITextView * _Nonnull textView) {
        [weakSelf sendTextMessage:textView.text];
    };
    [self.view addSubview:self.inputBottomView];
    
    // 通知中心 添加 键盘 的 监听器，调用监听器方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillChangeFrameNotification:)  name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // 监听添加
    [[QJConversationManager manager] addDelegate:self];
    
    
    // 最新的一条数据
    if (self.conversation.latestMessage) {
        [self insertMessage:@[self.conversation.latestMessage] isNewData:YES];
    }
    // 第一次：刷新数据
    [self refreshOldMessage];
}
-(void)dealloc {
    [[QJConversationManager manager] removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

 #pragma mark - 事件
 -(void)checkDetails {
     QJLog(@"点击更多");
     [self sendImageMessage:[UIImage imageNamed:@"bottleBkg"]];

 }

-(void)sendTextMessage:(NSString *)text {
    // 设置发送文字模型
    QJTextChatModel * textChatModel = [QJTextChatModel chatModelWithSendToContact:self.contactModel extension:nil];
    textChatModel.text = text ;
    
    // 刷新数据
    [self insertMessage:@[textChatModel.message] isNewData:YES];
    
    // 发送数据
    [[QJConversationManager manager] sendMessage:textChatModel.message progress:nil completion:^(EMMessage * _Nonnull message, EMError * _Nonnull error) {
        QJLog(@"%@",!error ? @"发送成功":@"发送失败");
    }];
}

-(void)sendImageMessage:(UIImage *)image {
    // 设置发送文字模型
    QJImageChatModel * imageChatModel = [QJImageChatModel chatModelWithSendToContact:self.contactModel extension:nil];
    imageChatModel.image = image ;
    
    // 刷新数据
    [self insertMessage:@[imageChatModel.message] isNewData:YES];
    
    QJChatModelFrame * chatModelFrame = self.messageFrames.lastObject ;
    chatModelFrame.chatModel = imageChatModel ;
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageFrames.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];

    // 发送数据
    [[QJConversationManager manager] sendMessage:imageChatModel.message progress:nil completion:^(EMMessage * _Nonnull message, EMError * _Nonnull error) {
        QJLog(@"%@",!error ? @"发送成功":@"发送失败");
    }];
}

-(void)refreshOldMessage {
    if (self.messageFrames.count == 0) {
        [self.tableView.mj_header endRefreshing];
        return ;
    }
    
    long long toTime = self.messageFrames.firstObject.chatModel.message.timestamp ;
    long long fromTime = toTime - 24 * 60 * 60 * 1000 ;
    [self.conversation loadMessagesFrom:fromTime to:toTime count:10 completion:^(NSArray<EMMessage *> *aMessages, EMError *aError) {
        [self.tableView.mj_header endRefreshing];
        
        if (!aError && aMessages.count) {
            [self insertMessage:aMessages.reverseObjectEnumerator.allObjects isNewData:NO];
        }
    }];
}

#pragma mark - 处理数据

/// 处理添加数据
/// @param aMessages 会话中的多条信息
/// @param isNewData 是否是最新数据
-(void)insertMessage:(NSArray<EMMessage *> *)aMessages isNewData:(BOOL)isNewData {
    if (!aMessages.count) return ;
    
    NSMutableArray * indexPathArr = [NSMutableArray arrayWithCapacity:aMessages.count];
    CGFloat scrolTo = 0 ;
    for (EMMessage * message in aMessages) {
        if (![message.conversationId isEqualToString:self.conversation.conversationId]) {
            break ;
        }
        NSLog(@"timestamp = %lld",message.timestamp);
        
        QJChatModel * chatModel = nil ;
        QJChatModelFrame * chatModelFrame = nil ;

        if ([message.body isKindOfClass:[EMTextMessageBody class]]) {
            chatModel = [QJTextChatModel chatModelWithMessage:message];
            chatModelFrame = [[QJTextChatModelFrame alloc]init];
        } else if ([message.body isKindOfClass:[EMImageMessageBody class]]) {
            chatModel = [QJImageChatModel chatModelWithMessage:message];
            chatModelFrame = [[QJImageChatModelFrame alloc]init];
        }
        
        if (isNewData) { // 新数据
            QJChatModelFrame * preChatModelFrame = self.messageFrames.lastObject ;
            chatModelFrame.hiddenTime = [preChatModelFrame.chatModel.time isEqualToString:chatModel.time];
            
            // 添加数据
            [self.messageFrames addObject:chatModelFrame];
            [indexPathArr addObject:[NSIndexPath indexPathForRow:self.messageFrames.count-1 inSection:0]];
        } else { // 旧数据
            QJChatModelFrame * nextChatModelFrame = self.messageFrames.firstObject ;
            nextChatModelFrame.hiddenTime = [nextChatModelFrame.chatModel.time isEqualToString:chatModel.time];
            nextChatModelFrame.chatModel = nextChatModelFrame.chatModel ;
            
            // 添加数据
            [self.messageFrames insertObject:chatModelFrame atIndex:0];
            [indexPathArr addObject:[NSIndexPath indexPathForRow:indexPathArr.count inSection:0]];
        }
        
        // 设置属性，然后自动计算主度
        chatModelFrame.chatModel = chatModel ;
        scrolTo += chatModelFrame.cellHieght ;
    }
    
    
    // 刷新数据
    [self.tableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (isNewData) { // 最新数据才需要滚动
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageFrames.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        } else {
//            self.tableView.contentOffset = CGPointMake(0, scrolTo);
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPathArr.count inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    });
    
}

#pragma mark - QJConversationManagerDelegate
/*!
 *  收到消息
 *  @param aMessages  消息列表<EMMessage>
 */
- (void)messagesDidReceive:(NSArray<EMMessage *> *)aMessages{
    
    [self insertMessage:aMessages isNewData:YES];
}


#pragma mark - 键盘通知
/** 当从通知中心得知键盘frame变动时，调用该方法 */
- (void)KeyboardWillChangeFrameNotification:(NSNotification *)notif{
 
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageFrames.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    // 从打卬中要以看出userInfo中的key,取出对应的属性
    CGFloat time = [notif.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGRect keyboardBeginRect = [notif.userInfo[@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    CGRect keyboardEndRect = [notif.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    // 键盘 坐标y 值的变动值
    CGFloat yMinusValu = keyboardBeginRect.origin.y - keyboardEndRect.origin.y;
    
    CGRect tableViewFrame  = self.tableView.frame;
    [UIView animateWithDuration:time animations:^{ // 执行动画
       // 改变 tableView.frame的坐标y值
        CGFloat X = tableViewFrame.origin.x ;
        CGFloat Y = tableViewFrame.origin.y - yMinusValu ;
        CGFloat W = tableViewFrame.size.width;
        CGFloat H = tableViewFrame.size.height;
        self.tableView.frame = CGRectMake(X, Y, W, H);
    }];
}
 
#pragma mark - UITableView 相关
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageFrames.count ;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {QJLog(@"row = %ld",indexPath.row);
    QJChatModelFrame * model = self.messageFrames[indexPath.row];
    // 1.创建一个Cell
    QJChatCell * cell = [QJChatCell messageCellWithTableView:self.tableView];
    
    // 2.设置Cell的数据
    cell.chatModelFrame = model ;
    
    // 3.返回一个Cell
    return cell;
}

/**  每个Cell 的高度 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    QJChatModelFrame * model = self.messageFrames[indexPath.row];
    return model.cellHieght;
}
/** 当tableView 被拖动地调用 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // 隐藏键盘
    [self.view endEditing:YES];
}

#pragma mark - 懒加载
-(NSMutableArray<QJChatModelFrame *> *)messageFrames {
    if (!_messageFrames) {
        _messageFrames = [NSMutableArray array];
    }
    return _messageFrames ;
}
 
@end
