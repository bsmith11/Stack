//
//  STKPermissionViewController.h
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import UIKit;

@class STKPermissionViewController;

@protocol STKPermissionViewControllerDelegate <NSObject>

- (void)permissionViewControllerDidFinish:(STKPermissionViewController *)permissionViewController;

@end

@interface STKPermissionViewController : UIViewController

@property (weak, nonatomic) id <STKPermissionViewControllerDelegate> delegate;

@end
