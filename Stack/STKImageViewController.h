//
//  STKImageViewController.h
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import UIKit;

@class STKImageViewController;

@protocol STKImageViewControllerDelegate <NSObject>

- (void)imageViewControllerWillStartPresentAnimation:(STKImageViewController *)imageViewController;
- (void)imageViewControllerDidFinishDismissAnimation:(STKImageViewController *)imageViewController;

@end

@interface STKImageViewController : UIViewController

- (instancetype)initWithURL:(NSURL *)URL originalRect:(CGRect)originalRect;

@property (weak, nonatomic) id <STKImageViewControllerDelegate> delegate;

@end
