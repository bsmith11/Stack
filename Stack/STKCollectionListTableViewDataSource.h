//
//  STKCollectionListTableViewDataSource.h
//  Stack
//
//  Created by Bradley Smith on 12/21/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import <RZCollectionList/RZCollectionList.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@protocol STKCollectionListTableViewDelegate <NSObject>

@required
- (ASCellNode *)tableView:(ASTableView *)tableView nodeForObject:(id)object atIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(ASTableView *)tableView updateNode:(ASCellNode *)node forObject:(id)object atIndexPath:(NSIndexPath *)indexPath;
@optional
- (void)tableView:(ASTableView *)tableView didFinishUpdatingCompleted:(BOOL)completed;

@end

@interface STKCollectionListTableViewDataSource : NSObject <ASTableViewDataSource>

- (instancetype)initWithTableView:(ASTableView *)tableView
                   collectionList:(id <RZCollectionList>)collectionList
                         delegate:(id <STKCollectionListTableViewDelegate>)delegate;

- (void)setAllObjectAnimations:(UITableViewRowAnimation)animation;
- (void)setAllSectionAnimations:(UITableViewRowAnimation)animation;

@property (strong, nonatomic) id <RZCollectionList> collectionList;

@property (weak, nonatomic, readonly) ASTableView *tableView;
@property (weak, nonatomic) id <STKCollectionListTableViewDelegate> delegate;

@property (assign, nonatomic, getter = shouldAnimateTableChanges) BOOL animateTableChanges;

@property (assign, nonatomic) UITableViewRowAnimation addSectionAnimation;
@property (assign, nonatomic) UITableViewRowAnimation removeSectionAnimation;

@property (assign, nonatomic) UITableViewRowAnimation addObjectAnimation;
@property (assign, nonatomic) UITableViewRowAnimation removeObjectAnimation;
@property (assign, nonatomic) UITableViewRowAnimation updateObjectAnimation;

@end
