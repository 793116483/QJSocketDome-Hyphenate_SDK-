//
//  NSMutableArray+QJWeak.m
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/9.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "QJWeakRefMutableArray.h"

@interface QJWeakRefMutableArray ()
@property (nonatomic , strong) NSMutableArray<NSValue *> * mArray ;
@end
@implementation QJWeakRefMutableArray

+(instancetype)array {
    return [[self alloc] init];
}
+(instancetype)arrayWithArray:(NSArray * _Nullable __weak)array {
    QJWeakRefMutableArray * objct = [self array];
    [objct addObjectsFromArray:array];
    return objct ;
}

-(NSArray *)allObjects {
    NSMutableArray * array = [NSMutableArray array];
    for (NSUInteger i = 0 ; i < self.mArray.count ; i++) {
        id value = [self objectAtIndex:i];
        if (value) {
            [array addObject:value];
        }
    }
    return array ;
}
-(NSUInteger)count {
    return self.mArray.count ;
}

-(void)removeAllObjects {
    [self.mArray removeAllObjects];
}

-(void)removeObject:(id)object {
    NSValue *value = [NSValue valueWithNonretainedObject:object];
    [self.mArray removeObject:value];
}




-(void)addObjectsFromArray:(NSArray *)array {
    for (id objc in array) {
        [self addObject:objc];
    }
}

-(void)addObject:(id)object {
    if(object == nil) return ;
    NSValue *value = [NSValue valueWithNonretainedObject:object];
    [self.mArray addObject:value];
}





-(id)objectAtIndex:(NSUInteger)index {
    
    if (index >= self.mArray.count) {
        return nil ;
    }
    NSValue *value = [self.mArray objectAtIndex:index];
    return [value nonretainedObjectValue] ;
}

-(id)firstObject {
    return [self objectAtIndex:0];
}
-(id)lastObject {
    return [self objectAtIndex:self.mArray.count - 1];
}

-(BOOL)containsObject:(id)object {
    NSValue *value = [NSValue valueWithNonretainedObject:object];
    return [self.mArray containsObject:value];
}

-(NSMutableArray<NSValue *> *)mArray {
    if (!_mArray) {
        _mArray = [NSMutableArray array];
    }
    return _mArray ;
}

@end
