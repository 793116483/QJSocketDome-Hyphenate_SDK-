//
//  QJInputView.m
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/10.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "QJInputView.h"
#import "QJButton.h"

@interface QJInputView ()<UITextViewDelegate>

#pragma mark - subview 属性
@property (nonatomic , strong) QJButton * leftBtn ;
@property (nonatomic , strong) QJButton * voceBtn ;
@property (nonatomic , strong) QJButton * emojiBtn ;
@property (nonatomic , strong) QJButton * addBtn ;

#pragma mark - 辅助属性
/// 看不见的 view , 只用于展示键盘 , 与 inputTextView 的键盘相互切换
@property (nonatomic , strong) UITextField * textFieldForKeybordUse ;
// 记录高度
@property (nonatomic , assign) BOOL setFrameFromInside ;  // 是否是来自外界设置的frame
@property (nonatomic , assign) CGFloat heightForOutsideSet ;  // 外界设置的 frame

@end

@implementation QJInputView
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.voceBtn removeObserver:self forKeyPath:@"pressing"];
    [self.inputTextView removeObserver:self forKeyPath:@"hidden"];
}
#pragma mark 设置 UI
CGFloat space = 10 ;
-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        
        [self addSubview:self.leftBtn];
        [self addSubview:self.voceBtn];
        [self addSubview:self.inputTextView];
        [self addSubview:self.emojiBtn];
        [self addSubview:self.addBtn];
        [self addSubview:self.textFieldForKeybordUse];

        __weak typeof(self) weakSelf = self ;
        [self.leftBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).offset(space);
            make.bottom.equalTo(weakSelf).offset(-space);
            make.width.mas_offset(35);
            make.height.mas_offset(35);
        }];
        [self.addBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf).offset(-space);
            make.bottom.equalTo(weakSelf).offset(-space);
            make.width.mas_offset(35);
            make.height.mas_offset(35);
        }];
        [self.emojiBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.addBtn.mas_left).offset(-space);
            make.bottom.equalTo(weakSelf).offset(-space);
            make.width.mas_offset(35);
            make.height.mas_offset(35);
        }];
        
        [self.voceBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.leftBtn.mas_right).offset(space);
            make.right.equalTo(weakSelf.emojiBtn.mas_left).offset(-space);
            make.top.equalTo(weakSelf).offset(space);
            make.bottom.equalTo(weakSelf).offset(-space);
        }];
        [self.inputTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.leftBtn.mas_right).offset(space);
            make.right.equalTo(weakSelf.emojiBtn.mas_left).offset(-space);
            make.top.equalTo(weakSelf).offset(space);
            make.bottom.equalTo(weakSelf).offset(-space);
        }];
        
        
        // 通知中心 添加 键盘 的 监听器，调用监听器方法
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillChangeFrameNotification:)  name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self ;
}
#pragma mark - frame 变更相关
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    if (self.setFrameFromInside == NO) {
        self.heightForOutsideSet = frame.size.height ;
    }
}
-(void)setFrameWhenTextViewDidChange:(UITextView *)textView {
    if (self.heightForOutsideSet == 0) {
        self.heightForOutsideSet = self.frame.size.height;
    }
    self.setFrameFromInside = YES ;
    if (textView.hidden) {
        // 高度变回 外界设置的原始值
        CGFloat height = self.heightForOutsideSet ;
        CGFloat offsetH = height - self.frame.size.height ;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y - offsetH , self.frame.size.width, height);
    } else if(!self.isAutolayout) {
        self.frame = [self getMutableFrameWithTextView:textView];
    }
    self.setFrameFromInside = NO ;
}
/// frame 根据 text内容 计算高度
-(CGRect)getMutableFrameWithTextView:(UITextView *)textView{
    
    CGFloat maxW = textView.frame.size.width - textView.contentInset.left - textView.contentInset.right ;
    CGFloat height = [textView.text sizeWithMaxSize:CGSizeMake(maxW, CGFLOAT_MAX) font:textView.font].height + 20 ;
    if (height > 120) {
        height = 120 ;
    }
    if (height < self.heightForOutsideSet ) {
        height = self.heightForOutsideSet ;
    }
    CGFloat offsetH = height - self.frame.size.height ;
    
    return CGRectMake(self.frame.origin.x, self.frame.origin.y - offsetH , self.frame.size.width, height);
}

#pragma mark - 键盘 显示与隐藏
-(BOOL)becomeFirstResponder {
    BOOL result = [super becomeFirstResponder];
    if (self.emojiBtn.selected || self.addBtn.selected ) {
        [self.textFieldForKeybordUse becomeFirstResponder];
    }
    else if (self.inputTextView.isHidden == NO) {
        [self.inputTextView becomeFirstResponder];
    } else {
        [self.textFieldForKeybordUse becomeFirstResponder];
    }
    return result ;
}
-(BOOL)resignFirstResponder {
    BOOL result = [super resignFirstResponder];
    [self endEditing:YES];
    return result ;
}
/** 当从通知中心得知键盘frame变动时，调用该方法 */
- (void)KeyboardWillChangeFrameNotification:(NSNotification *)notif{
    
    // 从打卬中要以看出userInfo中的key,取出对应的属性
    CGFloat time = [notif.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGRect keyboardBeginRect = [notif.userInfo[@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    CGRect keyboardEndRect = [notif.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    // 键盘 坐标y 值的变动值
    CGFloat yMinusValu = keyboardBeginRect.origin.y - keyboardEndRect.origin.y;
    
    CGRect bottomViewFrame = self.frame ;
    
    [UIView animateWithDuration:time animations:^{ // 执行动画
        // 改变 inputBottomView.frame的坐标y值
        CGFloat X = bottomViewFrame.origin.x;
        CGFloat Y = bottomViewFrame.origin.y - yMinusValu;
        CGFloat W = bottomViewFrame.size.width;
        CGFloat H = bottomViewFrame.size.height;
        self.setFrameFromInside = YES ;
        self.frame = CGRectMake(X, Y, W, H);
        self.setFrameFromInside = NO ;
    }];
}
#pragma mark - UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView {
    self.leftBtn.selected = NO ;
    self.emojiBtn.selected = NO ;
    self.addBtn.selected = NO ;
    [self becomeFirstResponder];
}
// 输入框 内容改变
-(void)textViewDidChange:(UITextView *)textView {
    // 变更高度
    [self setFrameWhenTextViewDidChange:textView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        if (!self.sendActionCallBackBlock) return YES ;
        
//        [self resignFirstResponder];
        
        self.sendActionCallBackBlock(textView);
        
        textView.text = @"";
        [self textViewDidChange:textView];
        return NO;
    }
  
    return YES;
}

#pragma mark - 点击事件
-(void)leftBtnDidClicked:(UIButton *)btn {
    // 恢复设置的值
    self.emojiBtn.selected = NO ;
    self.addBtn.selected = NO ;
    [self resignFirstResponder];
    
    // 设置状态
    btn.selected = !btn.selected ;
    self.inputTextView.hidden = btn.selected ;
    
    if (!btn.selected) { // 需要文字输入
        // 显示键盘
        [self becomeFirstResponder];
    }
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"pressing"] && object == self.voceBtn ) {
        if (self.voceBtn.isHighlighted) {
            NSLog(@"开始说话");
        }else {
            NSLog(@"结束说话");
        }
    } else if ([keyPath isEqualToString:@"hidden"] && object == self.inputTextView ) {
        // 显示或隐藏 都需要重新设置 frame
        [self setFrameWhenTextViewDidChange:self.inputTextView];
    }
}

-(void)emojiBtnDidClicked:(UIButton *)btn {
    
    self.leftBtn.selected = NO ;
    self.addBtn.selected = NO ;
    self.inputTextView.hidden = NO ;

    btn.selected = !btn.selected ;
            
    if (btn.selected) {
        // 自定义 键盘
        self.textFieldForKeybordUse.inputView = [[UISwitch alloc] init]; // 表情键盘
        self.textFieldForKeybordUse.inputView.frame = CGRectMake(0, 0, 200, 200);
        [self.textFieldForKeybordUse reloadInputViews];
        // 显示 键盘
        [self becomeFirstResponder];
    } else {
        [self becomeFirstResponder];
    }
}
-(void)addBtnDidClicked:(UIButton *)btn {
    
    self.leftBtn.selected = NO ;
    self.emojiBtn.selected = NO ;
    self.inputTextView.hidden = NO ;
    
    btn.selected = !btn.selected ;

    if (btn.selected) { // 显示 自定义 键盘
        self.textFieldForKeybordUse.inputView = [UIButton buttonWithType:UIButtonTypeContactAdd];
        self.textFieldForKeybordUse.inputView.frame = CGRectMake(0, 0, 200, 200);
        [self.textFieldForKeybordUse reloadInputViews];
    }
    // 显示 键盘
    [self becomeFirstResponder];
}



#pragma mark - 懒加载
-(QJButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [[QJButton alloc] init];
        [_leftBtn setImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:QJControlStateNormal];
        [_leftBtn setImage:[UIImage imageNamed:@"ToolViewInputVoiceHL"] forState:QJControlStateHighlighted];
        [_leftBtn setImage:[UIImage imageNamed:@"ToolViewInputText"] forState:QJControlStateSelected];
        [_leftBtn setImage:[UIImage imageNamed:@"ToolViewInputTextHL"] forState:QJControlStateSelectedHighlighted];
        [_leftBtn addTarget:self action:@selector(leftBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn ;
}

-(QJButton *)voceBtn {
    if (!_voceBtn) {
        _voceBtn = [[QJButton alloc] init];
        
        [_voceBtn setTitle:@"按住 说话" forState:QJControlStateNormal];
        [_voceBtn setTitle:@"松开 结束" forState:QJControlStateHighlighted];
        // 根据状态 设置title color
        [_voceBtn setTitleColor:[UIColor colorWithWhite:0.3 alpha:1.0] forState:QJControlStateNormal];
        [_voceBtn setTitleColor:[UIColor colorWithWhite:0.1 alpha:1.0] forState:QJControlStateHighlighted];
        // 根据状态 设置背景色
        [_voceBtn setBackgroundColor:[UIColor whiteColor] forState:QJControlStateNormal];
        [_voceBtn setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:1.0] forState:QJControlStateHighlighted];

        [_voceBtn addObserver:self forKeyPath:@"pressing" options:NSKeyValueObservingOptionNew context:nil];
        
        _voceBtn.clipsToBounds = YES ;
        _voceBtn.layer.cornerRadius = 4 ;
    }
    return _voceBtn ;
}
@synthesize inputTextView = _inputTextView ;
-(UITextView *)inputTextView{
    if (!_inputTextView) {
        _inputTextView = [[UITextView alloc] init];
        _inputTextView.font = [UIFont systemFontOfSize:15];
        _inputTextView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
        _inputTextView.delegate = self ;
        // 修改 return key 样式
        _inputTextView.returnKeyType = UIReturnKeySend ;
        // 当输入有值的时候可以点击
        _inputTextView.enablesReturnKeyAutomatically = YES ;
        
        [_inputTextView addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _inputTextView ;
}
-(QJButton *)emojiBtn {
    if (!_emojiBtn) {
        _emojiBtn = [[QJButton alloc] init];
        [_emojiBtn setImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:QJControlStateNormal];
        [_emojiBtn setImage:[UIImage imageNamed:@"ToolViewEmotionHL"] forState:QJControlStateHighlighted];
        [_emojiBtn setImage:[UIImage imageNamed:@"ToolViewInputText"] forState:QJControlStateSelected];
        [_emojiBtn setImage:[UIImage imageNamed:@"ToolViewInputTextHL"] forState:QJControlStateSelectedHighlighted];
        [_emojiBtn addTarget:self action:@selector(emojiBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _emojiBtn ;
}
-(QJButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [[QJButton alloc] init];
        [_addBtn setImage:[UIImage imageNamed:@"TypeSelectorBtn_Black"] forState:QJControlStateNormal];
        [_addBtn setImage:[UIImage imageNamed:@"TypeSelectorBtnHL_Black"] forState:QJControlStateHighlighted];
        [_addBtn addTarget:self action:@selector(addBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn ;
}

-(UITextField *)textFieldForKeybordUse {
    if (!_textFieldForKeybordUse) {
        _textFieldForKeybordUse = [[UITextField alloc] init];
        _textFieldForKeybordUse.hidden = YES ;
    }
    return _textFieldForKeybordUse ;
}

@end
