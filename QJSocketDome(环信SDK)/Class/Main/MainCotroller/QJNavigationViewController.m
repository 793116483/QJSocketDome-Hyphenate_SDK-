//
//  QJNavigationViewController.m
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/7.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "QJNavigationViewController.h"

@interface QJNavigationViewController ()

@end

@implementation QJNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    
}

+(void)initialize {
    [super initialize];
    
    UINavigationBar * appearanceNavBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[self class]]] ;
    appearanceNavBar.barTintColor = [UIColor blackColor];
    appearanceNavBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    [UIBarButtonItem appearance].tintColor = [UIColor whiteColor];
}
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent ;
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    self.tabBarController.tabBar.hidden = self.viewControllers.count > 1 ;
}
-(UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIViewController * vc = [super popViewControllerAnimated:animated];
    self.tabBarController.tabBar.hidden = self.viewControllers.count > 1 ;
    
    return vc ;
}
-(NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSArray * controllers = [super popToViewController:viewController animated:animated];
    self.tabBarController.tabBar.hidden = self.viewControllers.count > 1 ;
    return controllers ;
}
-(NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    NSArray * controllers = [super popToRootViewControllerAnimated:animated];
    self.tabBarController.tabBar.hidden = self.viewControllers.count > 1 ;
     return controllers ;
}

@end
