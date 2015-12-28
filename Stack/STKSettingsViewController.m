//
//  STKSettingsViewController.m
//  Stack
//
//  Created by Bradley Smith on 12/28/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import MessageUI;

#import "STKSettingsViewController.h"

#import "STKSettingsViewModel.h"

#import "STKSettingsItem.h"
#import "STKSettingsHeader.h"

#import "STKSettingsItemNode.h"
#import "STKSettingsHeaderNode.h"

#import "STKCollectionListTableViewDataSource.h"
#import "STKAnalyticsManager.h"

#import "UIColor+STKStyle.h"

#import <AsyncDisplayKit/ASTableView.h>

@interface STKSettingsViewController () <ASTableViewDelegate, STKCollectionListTableViewDelegate, STKSettingsItemNodeDelegate, STKSettingsViewModelDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) STKSettingsViewModel *viewModel;
@property (strong, nonatomic) ASTableView *tableView;

@end

@implementation STKSettingsViewController

- (instancetype)init {
    self = [super init];

    if (self) {
        self.viewModel = [[STKSettingsViewModel alloc] init];
        self.viewModel.delegate = self;

        UIImage *image = [UIImage imageNamed:@"Settings Off Icon"];
        UIImage *selectedImage = [UIImage imageNamed:@"Settings On Icon"];
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Settings" image:image selectedImage:selectedImage];
        self.title = self.tabBarItem.title;
    }

    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];

    [self setupTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.viewModel setupCollectionListDataSourceWithTableView:self.tableView delegate:self];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    self.tableView.frame = self.view.frame;
}

#pragma mark - Setup

- (void)setupTableView {
    self.tableView = [[ASTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain asyncDataFetching:NO];
    self.tableView.backgroundColor = [UIColor stk_backgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    CGFloat topInset = CGRectGetHeight(self.navigationController.navigationBar.frame) + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    CGFloat bottomInset = CGRectGetHeight(self.tabBarController.tabBar.frame);
    self.tableView.contentInset = UIEdgeInsetsMake(topInset, 0.0f, bottomInset, 0.0f);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(topInset, 0.0f, bottomInset, 0.0f);
    self.tableView.asyncDelegate = self;

    [self.view addSubview:self.tableView];
}

#pragma mark - Collection List Table View Data Source Delegate

- (ASCellNode *)tableView:(ASTableView *)tableView nodeForObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    ASCellNode *node = nil;

    if ([object isKindOfClass:[STKSettingsItem class]]) {
        node = [[STKSettingsItemNode alloc] init];
    }
    else if ([object isKindOfClass:[STKSettingsHeader class]]) {
        node = [[STKSettingsHeaderNode alloc] init];
    }

    [self tableView:tableView updateNode:node forObject:object atIndexPath:indexPath];

    return node;
}

- (void)tableView:(ASTableView *)tableView updateNode:(ASCellNode *)node forObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    if ([object isKindOfClass:[STKSettingsItem class]]) {
        STKSettingsItemNode *itemNode = (STKSettingsItemNode *)node;
        [itemNode setupWithSettingsItem:object];
        itemNode.delegate = self;
    }
    else if ([object isKindOfClass:[STKSettingsHeader class]]) {
        STKSettingsHeaderNode *headerNode = (STKSettingsHeaderNode *)node;
        [headerNode setupWithSettingsHeader:object];
    }
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewModel didSelectRowAtIndexPath:indexPath];
}

#pragma mark - Settings Item Node Delegate

- (void)settingsItemNode:(STKSettingsItemNode *)node didChangeValue:(BOOL)value {
    NSIndexPath *indexPath = [self.tableView indexPathForNode:node];
    STKSettingsItem *item = [self.viewModel objectAtIndexPath:indexPath];

    if (item.type == STKSettingsItemTypeSwitch) {
        [item performActionWithValue:@(value)];
    }
}

#pragma mark - Settings View Model Delegate

- (void)presentMailViewController {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
            mailViewController.mailComposeDelegate = self;
            [mailViewController setSubject:@"Feedback"];
            [mailViewController setToRecipients:@[@"bradley.d.smith11@gmail.com"]];

            [self presentViewController:mailViewController animated:YES completion:nil];
        }
        else {
            NSLog(@"Device unable to send mail");
        }
    });
}

#pragma mark - Mail Compose View Controller Delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [STKAnalyticsManager logEventDidCompleteFeedback:(result == MFMailComposeResultSent)];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end