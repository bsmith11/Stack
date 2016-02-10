//
//  STKCoreDataStack.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKCoreDataStack.h"

#import <AssertMacros.h>

@implementation STKCoreDataStack

+ (void)configureStack {
    RZCoreDataStackOptions options = RZCoreDataStackOptionDeleteDatabaseIfUnreadable | RZCoreDataStackOptionsEnableAutoStalePurge;
    STKCoreDataStack *stack = [[STKCoreDataStack alloc] initWithModelName:@"Stack"
                                                            configuration:nil
                                                                storeType:NSSQLiteStoreType
                                                                 storeURL:nil
                                                                  options:options];
    __Check(stack);
    [STKCoreDataStack setDefaultStack:stack];
}

@end
