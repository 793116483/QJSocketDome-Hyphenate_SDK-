//
//  QJTabBarViewController.m
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/7.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "QJTabBarViewController.h"
#import "QJNavigationViewController.h"
#import "QJHomeViewController.h"
#import "QJContactViewController.h"
#import "QJDiscoverViewController.h"
#import "QJMeViewController.h"

@interface QJTabBarViewController ()

@end

@implementation QJTabBarViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addChildViewController:[QJHomeViewController class] title:@"微信" icon:@"mainframe"];
    [self addChildViewController:[QJContactViewController class] title:@"联系人" icon:@"contacts"];
    [self addChildViewController:[QJDiscoverViewController class] title:@"发现" icon:@"discover"];
    [self addChildViewController:[QJMeViewController class] title:@"我" icon:@"me"];
    
}

-(void)addChildViewController:(Class)classVc title:(NSString *)title icon:(NSString *)icon {
    
    UIViewController * vc = [[classVc alloc] init];
    vc.title = title ;
    UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_%@",icon]];
    UIImage * imageHL = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_%@HL",icon]];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image selectedImage:imageHL];
    
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:QJColor(23, 160, 10, 1)} forState:UIControlStateHighlighted];
    
    QJNavigationViewController * nav = [[QJNavigationViewController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
    
    
}

@end
