//
//  STKSearchViewModel.m
//  Stack
//
//  Created by Bradley Smith on 12/26/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKSearchViewModel.h"

#import "STKPostSearchResult.h"

#import "STKTableViewDataSource.h"
#import "STKContentManager.h"

@interface STKSearchViewModel ()

@property (strong, nonatomic) STKTableViewDataSource *dataSource;
@property (strong, nonatomic) NSUUID *currentSearchID;

@property (assign, nonatomic, readwrite) BOOL searching;

@end

@implementation STKSearchViewModel

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];

    if (self) {
        self.sourceType = -1;
    }

    return self;
}

#pragma mark - Setup

- (void)setupDataSourceWithTableView:(ASTableView *)tableView delegate:(id<STKTableViewDataSourceDelegate>)delegate {
    self.dataSource = [[STKTableViewDataSource alloc] initWithTableView:tableView
                                                                objects:[NSArray array]
                                                        sortDescriptors:@[[STKPostSearchResult createDateSortDescriptor]]
                                                               delegate:delegate];
    self.dataSource.animateChanges = NO;
}

#pragma mark - Actions

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource.objects objectAtIndex:(NSUInteger)indexPath.row];
}

- (void)cancelSearch {
    [STKContentManager cancelPreviousPostSearches];

    [self.dataSource replaceAllObjectsWithObjects:[NSArray array]];
}

- (void)searchPostsWithText:(NSString *)text {
    NSUUID *searchID = [NSUUID UUID];
    self.currentSearchID = searchID;

    [self cancelSearch];

    if (text.length > 0) {
        __weak __typeof(self) wself = self;

        void (^block)() = ^{
            if ([wself.currentSearchID isEqual:searchID]) {
                wself.searching = YES;

                STKContentManagerDownloadCompletion completion = ^(NSArray *results, NSError *error) {
                    if (error) {
                        if (error.code == NSURLErrorCancelled) {
                            NSLog(@"Cancelled search for \"%@\"", text);
                        }
                        else {
                            NSLog(@"Failed to search for \"%@\" with error: %@", text, error);
                        }
                    }

                    [wself.dataSource addObjects:results];

                    wself.searching = NO;
                };

                [STKContentManager searchPostsWithText:text
                                            sourceType:wself.sourceType
                                            completion:completion];
            }
        };

        //delay so we don't send off requests that will immediately be cancelled by subsequent keystrokes
        int64_t delay = NSEC_PER_SEC / 4;
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delay);
        dispatch_after(time, dispatch_get_main_queue(), block);
    }
    else {
        self.searching = NO;
    }
}

@end
