//
//  STKSourceListViewController.h
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKBaseViewController.h"

@class STKSourceListViewController;

@protocol STKSourceListViewControllerDelegate <NSObject>

@required
- (void)sourceListViewController:(STKSourceListViewController *)sourceListViewController didSelectSourceType:(STKSourceType)sourceType;

@end

@interface STKSourceListViewController : STKBaseViewController

@property (weak, nonatomic) id <STKSourceListViewControllerDelegate> delegate;

@end
