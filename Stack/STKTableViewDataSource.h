//
//  STKTableViewDataSource.h
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import Foundation;

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@protocol STKTableViewDataSourceDelegate

@required
- (ASCellNode *)tableView:(ASTableView *)tableView nodeForObject:(id)object atIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(ASTableView *)tableView updateNode:(ASCellNode *)node forObject:(id)object atIndexPath:(NSIndexPath *)indexPath;
- (void)tableViewDidChangeContent:(ASTableView *)tableView;

@end

@interface STKTableViewDataSource : NSObject <ASTableViewDataSource>

- (instancetype)initWithTableView:(ASTableView *)tableView
                          objects:(NSArray *)objects
                  sortDescriptors:(NSArray *)sortDescriptors
                         delegate:(id <STKTableViewDataSourceDelegate>)delegate;

- (void)addObjects:(NSArray *)objects completion:(void (^)(NSArray *newObjects))completion;
- (void)removeObjects:(NSArray *)objects completion:(void (^)(NSArray *removedObjects))completion;
- (void)replaceAllObjectsWithObjects:(NSArray *)objects completion:(void (^)())completion;

- (void)registerForChangeNotificationsForContext:(NSManagedObjectContext *)context entityName:(NSString *)entityName;
- (void)unregisterForChangeNotificationsForContext:(NSManagedObjectContext *)context;

@property (copy, nonatomic, readonly) NSArray *objects;

@property (weak, nonatomic, readonly) ASTableView *tableView;
@property (weak, nonatomic, readonly) id <STKTableViewDataSourceDelegate> delegate;

@property (assign, nonatomic) BOOL animateChanges;

@end
