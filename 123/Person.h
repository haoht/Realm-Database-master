//
//  Person.h
//  123
//
//  Created by liman on 15/2/7.
//  Copyright (c) 2015年 liman. All rights reserved.
//

#import <Realm/Realm.h>

@interface Person : RLMObject

@property NSString *name;
@property NSInteger age;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<Person>
RLM_ARRAY_TYPE(Person)
