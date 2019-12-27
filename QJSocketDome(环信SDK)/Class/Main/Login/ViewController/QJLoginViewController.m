//
//  QJLoginViewController.m
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/7.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "QJLoginViewController.h"


@interface QJLoginViewController ()<UITextFieldDelegate>

@property (nonatomic , strong) UITextField * accountField ;
@property (nonatomic , strong) UITextField * pwdField ;

@property (nonatomic , strong) QJButton * loginBtn ;
@property (nonatomic , strong) QJButton * registBtn ;


@end

@implementation QJLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextChangedNoti) name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UI
-(void)setUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.accountField];
    [self.view addSubview:self.pwdField];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.registBtn];

    CGFloat space = 20 ;
    [self.accountField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(space);
        make.right.equalTo(self.view.mas_right).offset(-space);
        make.top.equalTo(self.view.mas_top).offset(100);
        make.height.mas_equalTo(50);
    }];
    [self.pwdField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(space);
        make.right.equalTo(self.view.mas_right).offset(-space);
        make.top.equalTo(self.accountField.mas_bottom).offset(20);
        make.height.mas_equalTo(50);
    }];
    [self.loginBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(space);
        make.right.equalTo(self.view.mas_right).offset(-space);
        make.top.equalTo(self.pwdField.mas_bottom).offset(40);
        make.height.mas_equalTo(50);
    }];
    [self.registBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(space);
        make.right.equalTo(self.view.mas_right).offset(-space);
        make.top.equalTo(self.loginBtn.mas_bottom).offset(40);
        make.height.mas_equalTo(50);
    }];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - 注册
-(void)registBtnDidClicked {
    
    if (![self checkIsPhoneNumberWithText:self.accountField.text]) return ;

    [SVProgressHUD showWithStatus:@"正在注册"];

    [[EMClient sharedClient] registerWithUsername:self.accountField.text password:self.pwdField.text completion:^(NSString *aUsername, EMError *aError) {
        [SVProgressHUD dismiss];

        if (!aError) {
            QJLog(@"注册成功");
            
            [self loginBtnDidClicked];
            
        } else {
            QJLog(@"注册失败 %@",aError.errorDescription);
        }
    }];
}

#pragma mark - 登录
-(void)loginBtnDidClicked {
    
    if (![self checkIsPhoneNumberWithText:self.accountField.text]) return ;
    
    [SVProgressHUD showWithStatus:@"正在登录"];
    NSString * account = [self.accountField.text lowercaseString];
    NSString * pwd = [self.pwdField.text lowercaseString];

    [[EMClient sharedClient] loginWithUsername:account password:pwd completion:^(NSString *aUsername, EMError *aError) {

        if (!aError) {
            QJLog(@"登录成功 %@",aUsername);
            [[EMClient sharedClient].options setIsAutoLogin:YES];
            [QJUserManager manager].isLoging = YES ;
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            
            // 设置当前用户
            QJUserModel * user = [QJUserModel userModelWithAccount:account pwd:pwd];
            [QJUserManager manager].currentUser = user ;
            
        } else {
            QJLog(@"登录失败 %@",aError.errorDescription);
            [SVProgressHUD showSuccessWithStatus:aError.errorDescription];
        }
    }];
}

- (BOOL)checkIsPhoneNumberWithText:(NSString *)text {
    
    if (text.length != 11) {
        return NO ;
    }
    
    /**
     * 移动号段正则表达式
     */
    NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
    /**
     * 联通号段正则表达式
     */
    NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
    /**
     * 电信号段正则表达式
     */
    NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
    BOOL isMatch1 = [pred1 evaluateWithObject:text];
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
    BOOL isMatch2 = [pred2 evaluateWithObject:text];
    NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
    BOOL isMatch3 = [pred3 evaluateWithObject:text];
      
    if (isMatch1 || isMatch2 || isMatch3) {
        return YES;
    }else{
        
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        
        return NO;
    }
}

#pragma mark - UITextFieldDelegate
-(void)textFieldTextChangedNoti {
    if (self.accountField.text.length > 11) {
        self.accountField.text = [self.accountField.text substringToIndex:11];
    }
    self.loginBtn.enabled = (self.accountField.text.length == 11 && self.pwdField.text.length > 0);
    self.registBtn.enabled = self.loginBtn.enabled ;
    
    
}

#pragma mark - getter 方法

-(UITextField *)accountField {
    if (!_accountField) {
        _accountField = [[UITextField alloc] init];
        _accountField.placeholder = @"请输入手机号";
        _accountField.clipsToBounds = YES ;
        _accountField.layer.cornerRadius = 4 ;
        _accountField.clearButtonMode = UITextFieldViewModeWhileEditing ;
        _accountField.borderStyle = UITextBorderStyleLine ;
        _accountField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _accountField ;
}
-(UITextField *)pwdField {
    if (!_pwdField) {
        _pwdField = [[UITextField alloc] init];
        _pwdField.placeholder = @"请输入密码";
        _pwdField.clipsToBounds = YES ;
        _pwdField.layer.cornerRadius = 4 ;
        _pwdField.clearButtonMode = UITextFieldViewModeWhileEditing ;
        _pwdField.borderStyle = UITextBorderStyleLine ;
        _pwdField.secureTextEntry = YES ;
    }
    return _pwdField ;
}
-(QJButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [QJButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setTitle:@"登录" forState:QJControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:QJControlStateNormal];
        [_loginBtn setBackgroundColor:[UIColor orangeColor] forState:QJControlStateNormal];
        [_loginBtn setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1.0] forState:QJControlStateDisabled];
        [_loginBtn addTarget:self action:@selector(loginBtnDidClicked) forControlEvents:UIControlEventTouchUpInside];
        _loginBtn.enabled = NO ;
    }
    return _loginBtn ;
}

-(QJButton *)registBtn {
    if (!_registBtn) {
        _registBtn = [QJButton buttonWithType:UIButtonTypeCustom];
        [_registBtn setTitle:@"注册" forState:QJControlStateNormal];
        [_registBtn setTitleColor:[UIColor whiteColor] forState:QJControlStateNormal];
        [_registBtn setBackgroundColor:[UIColor orangeColor] forState:QJControlStateNormal];
        [_registBtn setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1.0] forState:QJControlStateDisabled];
        [_registBtn addTarget:self action:@selector(registBtnDidClicked) forControlEvents:UIControlEventTouchUpInside];
        _registBtn.enabled = NO ;
    }
    return _registBtn ;
}

@end
