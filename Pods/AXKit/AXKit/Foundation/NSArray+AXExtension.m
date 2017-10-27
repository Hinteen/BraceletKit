//
//  NSArray+AXExtension.m
//  AXKit
//
//  Created by xaoxuu on 03/06/2017.
//  Copyright © 2017 Titan Studio. All rights reserved.
//

#import "NSArray+AXExtension.h"
@import ObjectiveC.runtime;

inline NSArray *NSClassGetAllSubclasses(Class cls){
    NSMutableArray *subclasses = [NSMutableArray array];
    unsigned int numOfClasses;
    Class *classes = objc_copyClassList(&numOfClasses);
    for (unsigned int ci = 0; ci < numOfClasses; ci++) {
        Class superClass = classes[ci];
        do{
            superClass = class_getSuperclass(superClass);
        } while (superClass && superClass != cls);
        
        if (superClass)
        {
            [subclasses addObject: classes[ci]];
        }
    }
    free(classes);
    return subclasses;
}

@implementation NSArray (AXExtension)


- (CGFloat)ax_sum{
    return [[self valueForKeyPath:@"@sum.doubleValue"] doubleValue];
}

- (CGFloat)ax_avg{
    return [[self valueForKeyPath:@"@avg.doubleValue"] doubleValue];
}

- (CGFloat)ax_max{
    return [[self valueForKeyPath:@"@max.doubleValue"] doubleValue];
}

- (CGFloat)ax_min{
    return [[self valueForKeyPath:@"@min.doubleValue"] doubleValue];
}

- (instancetype)distinctUnionOfObjects{
    return [self valueForKeyPath:@"@distinctUnionOfObjects.self"];
}

@end
