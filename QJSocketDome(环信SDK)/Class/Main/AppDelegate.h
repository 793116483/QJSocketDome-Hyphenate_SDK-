//
//  AppDelegate.h
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/6.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic , strong) UIWindow * window ;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@end

