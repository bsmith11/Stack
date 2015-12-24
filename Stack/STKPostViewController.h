//
//  STKPostViewController.h
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKInteractiveViewController.h"

@class STKPost;

@interface STKPostViewController : STKInteractiveViewController

- (instancetype)initWithPost:(STKPost *)post;

@end
