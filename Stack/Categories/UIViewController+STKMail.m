//
//  UIViewController+STKMail.m
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import MessageUI;

#import "UIViewController+STKMail.h"

#import "STKMailViewController.h"

@interface UIViewController () <MFMailComposeViewControllerDelegate>

@end

@implementation UIViewController (STKMail)

- (void)stk_presentMailComposeViewControllerWithRecipients:(NSArray *)recipients {
    [self stk_presentMailComposeViewControllerWithRecipients:recipients body:nil];
}

- (void)stk_presentMailComposeViewControllerWithRecipients:(NSArray *)recipients body:(NSString *)body {
    [self stk_presentMailComposeViewControllerWithRecipients:recipients body:body subject:nil];
}

- (void)stk_presentMailComposeViewControllerWithRecipients:(NSArray *)recipients body:(NSString *)body subject:(NSString *)subject {
    if ([MFMailComposeViewController canSendMail]) {
        STKMailViewController *mailComposeViewController = [[STKMailViewController alloc] init];
        mailComposeViewController.mailComposeDelegate = self;
        [mailComposeViewController setToRecipients:recipients];
        [mailComposeViewController setMessageBody:body isHTML:NO];
        [mailComposeViewController setSubject:subject];

        [self presentViewController:mailComposeViewController animated:YES completion:nil];
    }
}

#pragma mark - Mail Compose View Controller Delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if (error) {
        NSLog(@"Failed MFMailComposeViewController with error: %@", error);
    }
    else {
        [self handleMailResult:result];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleMailResult:(MFMailComposeResult)result {
    switch (result) {
        case MFMailComposeResultSent:

            break;

        case MFMailComposeResultSaved:

            break;

        case MFMailComposeResultCancelled:

            break;

        case MFMailComposeResultFailed:
            
            break;
    }
}

@end
