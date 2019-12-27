//
//  NSMutableArray+QJWeak.h
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/9.
//  Copyright © 2019 yiniu. All rights reserved.
//  针对所有 被添加进数据的 object 弱引用

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QJWeakRefMutableArray<ObjectType> : NSObject

#pragma mark - 创建对象
+(instancetype)array ;
+(instancetype)arrayWithArray:(nullable __weak NSArray<ObjectType> *)array ;

/// 获取所有对象 : 在获取到所有对象之前，内部已经删除所有 空对象(即被释放了的对象)
-(NSArray<ObjectType> *) allObjects ;
-(NSUInteger)count ;

#pragma mark - 添加对像

/// 添加数组中所有对象 ，且对 数组中所有对象 弱引用
/// @param array 数组，数组内的对象被释放时需尽可能移除对象
-(void)addObjectsFromArray:(nullable __weak NSArray<ObjectType> *)array ;

/// 添加对象 ， object 被释放后最好删除掉
/// @param object 对object弱引用
-(void)addObject:(nonnull __weak ObjectType)object ;


#pragma mark - 移除对像
-(void)removeObject:(nonnull ObjectType)object ;
/// 删除所有 对象
-(void)removeAllObjects ;


#pragma mark - 获取对像
-(nullable ObjectType)objectAtIndex:(NSUInteger)index ;
-(nullable ObjectType)firstObject ;
-(nullable ObjectType)lastObject ;

-(BOOL)containsObject:(nonnull ObjectType)object ;
@end

NS_ASSUME_NONNULL_END
