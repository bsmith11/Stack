//
//  UIViewController+STKMail.h
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (STKMail)

- (void)stk_presentMailComposeViewControllerWithRecipients:(NSArray *)recipients;
- (void)stk_presentMailComposeViewControllerWithRecipients:(NSArray *)recipients body:(NSString *)body;

@end
