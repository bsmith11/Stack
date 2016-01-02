//
//  STKBaseViewController.h
//  Stack
//
//  Created by Bradley Smith on 12/21/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "STKNavigationController.h"

@interface STKBaseViewController : UIViewController

- (STKNavigationController *)stk_navigationController;

@property (assign, nonatomic) BOOL didLayoutSubviews;

@end
