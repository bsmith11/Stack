//
//  STKEventBracketsViewController.m
//  Stack
//
//  Created by Bradley Smith on 2/5/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventBracketsViewController.h"
#import "STKEventBracketsViewModel.h"

#import "STKEventBracket.h"

#import "STKBracketLayout.h"
#import "STKEventBracketHeader.h"
#import "STKEventBracketCell.h"

#import "UIColor+STKStyle.h"
#import "UICollectionReusableView+STKReuse.h"

#import <RZCollectionList/RZCollectionList.h>

@interface STKEventBracketsViewController () <RZCollectionListCollectionViewDataSourceDelegate>

@property (strong, nonatomic) STKEventBracketsViewModel *viewModel;
@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation STKEventBracketsViewController

#pragma mark - Lifecycle

- (instancetype)initWithEventBracket:(STKEventBracket *)bracket {
    self = [super init];

    if (self) {
        self.viewModel = [[STKEventBracketsViewModel alloc] initWithEventBracket:bracket];
        self.title = bracket.name;
    }

    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor stk_backgroundColor];

    [self setupCollectionView];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setHidesBackButton:NO animated:YES];

    [self.viewModel setupDataSourceWithCollectionView:self.collectionView delegate:self];
}

#pragma mark - Setup

- (void)setupCollectionView {
    STKBracketLayout *layout = [[STKBracketLayout alloc] init];
    layout.itemHeight = [STKEventBracketCell height];
    layout.minimumItemSpacing = 12.5f;
    layout.headerHeight = [STKEventBracketHeader height];

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.collectionView];

    self.collectionView.backgroundColor = [UIColor stk_backgroundColor];
    self.collectionView.alwaysBounceHorizontal = YES;
    CGFloat topInset = self.statusBarHeight + self.navigationBarHeight;
    CGFloat bottomInset = CGRectGetHeight(self.tabBarController.tabBar.bounds);
    self.collectionView.contentInset = UIEdgeInsetsMake(topInset, 0.0f, bottomInset, 0.0f);
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(topInset, 0.0f, bottomInset, 0.0f);

    [self.collectionView registerClass:[STKEventBracketCell class] forCellWithReuseIdentifier:[STKEventBracketCell stk_reuseIdentifier]];
    [self.collectionView registerClass:[STKEventBracketHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[STKEventBracketHeader stk_reuseIdentifier]];

    [self.collectionView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.collectionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.view.trailingAnchor constraintEqualToAnchor:self.collectionView.trailingAnchor].active = YES;
    [self.view.bottomAnchor constraintEqualToAnchor:self.collectionView.bottomAnchor].active = YES;
}

#pragma mark - Collection List Collection View Data Source Delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    STKEventBracketCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[STKEventBracketCell stk_reuseIdentifier] forIndexPath:indexPath];

    [cell setupWithGame:object];

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    STKEventBracketHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[STKEventBracketHeader stk_reuseIdentifier] forIndexPath:indexPath];
    STKEventStage *stage = [self.viewModel stageForSection:indexPath.section];

    [header setupWithStage:stage];

    return header;
}

@end
