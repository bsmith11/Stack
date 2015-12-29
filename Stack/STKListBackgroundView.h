//
//  STKListBackgroundView.h
//  Stack
//
//  Created by Bradley Smith on 12/23/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, STKListBackgroundViewState) {
    STKListBackgroundViewStateNone,
    STKListBackgroundViewStateEmpty,
    STKListBackgroundViewStateError
};

@class ASTableView;

@protocol STKListBackgroundContentViewProtocol <NSObject>

- (void)updateState:(STKListBackgroundViewState)state;

@property (assign, nonatomic) BOOL loading;

@end

@interface STKListBackgroundView : UIView

- (instancetype)initWithTableView:(ASTableView *)tableView;
- (void)tableViewDidChangeContent;

@property (strong, nonatomic) UIView <STKListBackgroundContentViewProtocol> *contentView;

@property (assign, nonatomic) STKListBackgroundViewState state;
@property (assign, nonatomic) BOOL loading;

@end
