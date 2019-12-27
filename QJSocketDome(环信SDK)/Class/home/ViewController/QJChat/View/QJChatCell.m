//
//  QJChatCell.m
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/10.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "QJChatCell.h"
// 信息是 文字
#import "QJTextChatModel.h"
#import "QJTextChatModelFrame.h"
// 信息是 图片
#import "QJImageChatModel.h"
#import "QJImageChatModelFrame.h"

@interface QJChatCell ()
 
@property (weak , nonatomic)UILabel * timeLable;
@property (weak , nonatomic)QJButton * iconBtn;
@property (weak , nonatomic)UIButton * textBtn;
 
@end

@implementation QJChatCell

+ (instancetype)messageCellWithTableView:(UITableView *)tableView{
    
    NSString * ID = @"QJChatCell";
    QJChatCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (nil == cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell ;
}
 
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 添加timeLable
        UILabel * timeLable = [[UILabel alloc]init];
        timeLable.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:timeLable];
        self.timeLable = timeLable ;
        self.timeLable.textColor = [UIColor grayColor];
        
        // 添加头象iconImg
        QJButton * iconBtn = [[QJButton alloc]init];
        [self.contentView addSubview:iconBtn];
        self.iconBtn = iconBtn ;
        self.iconBtn.layer.masksToBounds = YES ;
        self.iconBtn.layer.cornerRadius = 8 ;
        
        // 添加聊天正文按妞textBtn
        UIButton * textBtn = [[UIButton alloc]init];
        [self.contentView addSubview:textBtn];
        self.textBtn = textBtn ;
        self.textBtn.titleLabel.font = TextFont;
        self.textBtn.titleLabel.numberOfLines = 0;
        [self.textBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }
    return self;
}
 
- (void)setChatModelFrame:(QJChatModelFrame *)chatModelFrame{
    
    _chatModelFrame = chatModelFrame ;
        
    // 设置timeLable 的内容与frame
    self.timeLable.frame = chatModelFrame.timeFrame;
    self.timeLable.text = chatModelFrame.chatModel.time;
    
    // 设置头象iconImg 的内容与frame
    [self.iconBtn setImage:[UIImage imageNamed:chatModelFrame.chatModel.iconUrlStr] forState:QJControlStateNormal] ;
    self.iconBtn.frame = chatModelFrame.iconFrame;
    
    // 设置聊天正文按妞textBtn 的内容与frame
    if (chatModelFrame.chatModel.fromeType == QJFromeTypeMe) {
        [self.textBtn setBackgroundImage:[UIImage resizableImageWithName:@"SenderTextNodeBkg"] forState:UIControlStateNormal];
        [self.textBtn setBackgroundImage:[UIImage resizableImageWithName:@"SenderTextNodeBkgHL"] forState:UIControlStateHighlighted];
    }
    else{
        [self.textBtn setBackgroundImage:[UIImage resizableImageWithName: @"ReceiverTextNodeBkg"] forState:UIControlStateNormal];
        [self.textBtn setBackgroundImage:[UIImage resizableImageWithName:@"ReceiverTextNodeBkgHL"] forState:UIControlStateHighlighted];
    }
    
    [self setSubChatModelFrame:chatModelFrame];
}

-(void)setSubChatModelFrame:(QJChatModelFrame *)chatModelFrame {
    //设置内边距
    CGFloat edgeW = spaceOfTimeAndContent * 2 ;
    self.textBtn.contentEdgeInsets = UIEdgeInsetsMake(edgeW, edgeW, edgeW + spaceOfTimeAndContent, edgeW);
    
    if ([chatModelFrame isKindOfClass:[QJTextChatModelFrame class]]) {
        QJTextChatModelFrame * textModelFrame = (QJTextChatModelFrame *)chatModelFrame ;
        QJTextChatModel * textModel = (QJTextChatModel *)textModelFrame.chatModel ;
        [self.textBtn setTitle:textModel.text forState:UIControlStateNormal] ;
        self.textBtn.frame = textModelFrame.textFrame;
    } else if ([chatModelFrame isKindOfClass:[QJImageChatModelFrame class]]) {
        QJImageChatModelFrame * textModelFrame = (QJImageChatModelFrame *)chatModelFrame ;
        QJImageChatModel * textModel = (QJImageChatModel *)textModelFrame.chatModel ;
        [self.textBtn setImage:textModel.image forState:UIControlStateNormal];
        self.textBtn.frame = textModelFrame.imageFrame;
        self.textBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

@end
