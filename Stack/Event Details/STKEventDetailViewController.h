//
//  STKEventDetailViewController.h
//  Stack
//
//  Created by Bradley Smith on 2/5/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKBaseViewController.h"

@class STKEventGroup;

@interface STKEventDetailViewController : STKBaseViewController

- (instancetype)initWithEventGroup:(STKEventGroup *)group;

@end
