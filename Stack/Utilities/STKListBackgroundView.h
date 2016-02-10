//
//  STKListBackgroundView.h
//  Stack
//
//  Created by Bradley Smith on 12/23/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import Foundation;

typedef NS_ENUM(NSInteger, STKListBackgroundViewState) {
    STKListBackgroundViewStateNone,
    STKListBackgroundViewStateEmpty,
};

@class ASTableView;

@protocol STKListBackgroundContentViewProtocol <NSObject>

- (void)updateState:(STKListBackgroundViewState)state;

@end

@interface STKListBackgroundView : UIView

- (instancetype)initWithTableView:(ASTableView *)tableView;

@property (strong, nonatomic) UIView <STKListBackgroundContentViewProtocol> *contentView;

@property (assign, nonatomic) UIEdgeInsets baseInsets;
@property (assign, nonatomic) NSInteger emptyThreshold;
@property (assign, nonatomic, readonly) STKListBackgroundViewState state;


- (void)tableViewDidChangeContent;

@end
