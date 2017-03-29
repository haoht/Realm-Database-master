//
//  ViewController.m
//  123
//
//  Created by liman on 15-1-16.
//  Copyright (c) 2015年 liman. All rights reserved.
//

#warning 对实体的所有更改(添加,修改,删除), 都必须通过写入事务(transaction)完成。

#import "ViewController.h"
#import "Person.h"

@implementation ViewController

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    // 删除数据库
    if ([FILE_MANAGER fileExistsAtPath:[RLMRealm defaultRealmPath]]) {
        [FILE_MANAGER removeItemAtPath:[RLMRealm defaultRealmPath] error:nil];
    }
    
    _realm = [RLMRealm defaultRealm]; // 不能用于多线程!!!
    
    // 插入实体
    [self insertData];
    
    // 更新实体
    [self updateData];
    
    // 删除实体
    [self deleteData];
    
    // 多线程
    [self multiThread];
    
    // 查询实体
    [self queryData];
}


#pragma mark - private method
// 插入实体
- (void)insertData
{
    [_realm transactionWithBlock:^{
    
        Person *person = [Person new];
        person.name = @"liman";
        person.age = 25;
        
        [_realm addObject:person];
        
        
        /*
        [Person createInDefaultRealmWithObject:@[@"liman", @25]];

        [Person createInDefaultRealmWithObject:@{
                                                 @"name": @"liman",
                                                 @"age": @25,
                                                 }]; 
         */
    }];
    
    
    
    /*
    Person *person = [[Person alloc] init];
    person.name = @"liman_add";
    person.age = 25;
    
    [_realm beginWriteTransaction];
    [_realm addObject:person];
    [_realm commitWriteTransaction];
    */
}


// 更新实体
- (void)updateData
{
    for (Person *person in [Person allObjects]) {

        [_realm transactionWithBlock:^{
            person.name = @"liman_update";
            person.age = 26;
        }];
        
        
        
        /*
        [_realm beginWriteTransaction];
        person.name = @"liman_update";
        person.age = 26;
        [_realm commitWriteTransaction];
        */
    }
}


// 删除实体
- (void)deleteData
{
    [_realm transactionWithBlock:^{
        
        [_realm deleteAllObjects];
        
        [_realm deleteObjects:[Person objectsWhere:@"age = 25 AND name = 'liman'"]];
    }];
    
    
    
    /*
    [_realm beginWriteTransaction];
    [_realm deleteAllObjects];
    [_realm commitWriteTransaction];
    */
}


// 多线程
- (void)multiThread
{
    MULTI_THREAD((^{
        
        // 必须在多线程内部实例化!!!
        RLMRealm *realm = [RLMRealm defaultRealm];
        
        
        // 插入实体
        [realm transactionWithBlock:^{

            Person *person = [Person new];
            person.name = @"liman";
            person.age = 25;
            
            [realm addObject:person];
        }];
        
        
        // 更新实体
        for (Person *person in [Person allObjects]) {
            
            [realm transactionWithBlock:^{
                person.name = @"liman_update";
                person.age = 26;
            }];
        }
        
        
        // 删除实体
        [realm transactionWithBlock:^{
            
            [realm deleteAllObjects];
            
            [realm deleteObjects:[Person objectsWhere:@"age = 25 AND name = 'liman'"]];
        }];
        
        
        // 查询实体
        RLMResults *allPersons = [Person allObjects];
        NSLog(@"在多线程: %@",allPersons);
    }));
}


// 查询实体
- (void)queryData
{
    RLMResults *allPersons = [Person allObjects];
    NSLog(@"不在多线程: %@",allPersons);

    
    RLMResults *allPersons2 = [Person objectsWhere:@"age = 25 AND name = 'liman'"];
//    NSLog(@"%@", allPersons2);
    
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"age = %d AND name BEGINSWITH %@", 25, @"l"];
    RLMResults *allPersons3 = [Person objectsWithPredicate:pred];
//    NSLog(@"%@", allPersons3);
    
    
    RLMResults *allPersons4 = [Person allObjects];
    for (Person *person in allPersons4) {
//        NSLog(@"%@",[person valueForKeyPath:@"name"]);
//        NSLog(@"%@, %ld",person.name, person.age);
    }
    
    
    // 排序 (升序)
    RLMResults *sortedPersons = [allPersons sortedResultsUsingProperty:@"age" ascending:YES];
//    NSLog(@"%@", sortedPersons);
}

@end
