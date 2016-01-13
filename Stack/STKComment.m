//
//  STKComment.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKComment.h"
#import "STKPost.h"
#import "STKWordpressComment.h"
#import "STKRSSComment.h"
#import "STKBloggerComment.h"

#import "STKCoreDataStack.h"
#import "STKAPIClient.h"

#import <RZVinyl/RZVinyl.h>
#import <RZDataBinding/RZDBMacros.h>
#import <RZCollectionList/RZFetchedCollectionList.h>

@implementation STKComment

+ (RZFetchedCollectionList *)fetchedListOfCommentsForPost:(STKPost *)post {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self rzv_entityName]];
    request.sortDescriptors = @[[self createDateSortDescriptor]];
    request.predicate = [self predicateWithPost:post];

    RZFetchedCollectionList *fetchedList = [[RZFetchedCollectionList alloc] initWithFetchRequest:request
                                                                            managedObjectContext:[STKCoreDataStack defaultStack].mainManagedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
    return fetchedList;
}

+ (NSSortDescriptor *)createDateSortDescriptor {
    return [NSSortDescriptor sortDescriptorWithKey:RZDB_KP(STKComment, createDate) ascending:YES];
}

+ (NSPredicate *)predicateWithPost:(STKPost *)post {
    return [NSPredicate predicateWithFormat:@"%K == %@", RZDB_KP(STKComment, post), post];
}

+ (void)downloadCommentsForPost:(STKPost *)post completion:(void (^)(NSError *error))completion {
    [[STKAPIClient sharedInstance] getCommentsForPost:post completion:^(id responseObject, NSError *error, STKSourceType type) {
        if (!error) {
            if ([responseObject isKindOfClass:[NSArray class]]) {
                NSLog(@"Finished downloading comments for post: %@", post.title);

                STKBackendType backendType = [STKSource backendTypeForType:type];
                Class class;

                switch (backendType) {
                    case STKBackendTypeWordpress:
                        class = [STKWordpressComment class];
                        break;

                    case STKBackendTypeRSS:
                        class = [STKRSSComment class];
                        break;

                    case STKBackendTypeBlogger:
                        class = [STKBloggerComment class];
                        break;
                        
                    default:
                        class = [STKWordpressComment class];
                        break;
                }

                [[STKCoreDataStack defaultStack] performBlockUsingBackgroundContext:^(NSManagedObjectContext *context) {
                    NSArray *comments = [class rzi_objectsFromArray:responseObject inContext:context];
                    STKPost *cachedPost = [context objectWithID:post.objectID];

                    for (STKComment *comment in comments) {
                        comment.post = cachedPost;
                    }
                } completion:completion];
            }
            else {
                NSLog(@"Failed to parse comments: Root element is not NSArray");
                NSError *parseError = [NSError errorWithDomain:@"parse.error" code:0 userInfo:nil];

                if (completion) {
                    completion(parseError);
                }
            }
        }
        else {
            NSLog(@"Failed comments request with error: %@", error);

            if (completion) {
                completion(error);
            }
        }
    }];
}

- (NSAttributedString *)attributedContent {
    return [NSKeyedUnarchiver unarchiveObjectWithData:self.content];
}

@end
