//
//  STKPost.h
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import Foundation;
@import CoreData;

typedef void (^ _Nullable STKPostDownloadCompletion)(NSError * _Nullable error);

@class STKAttachment, STKAuthor, STKComment, STKPostSection, RZFetchedCollectionList, STKPostSearchResult;

@interface STKPost : NSManagedObject

+ (RZFetchedCollectionList * _Nonnull)fetchedListOfBookmarkedPosts;
+ (NSArray * _Nullable)fetchPostsBeforePost:(STKPost * _Nullable)post
                                     author:(STKAuthor * _Nullable)author
                                 sourceType:(STKSourceType)sourceType;
+ (void)fetchPostsBeforePost:(STKPost * _Nullable)post
                      author:(STKAuthor * _Nullable)author
                  sourceType:(STKSourceType)sourceType
                  completion:(NSPersistentStoreAsynchronousFetchResultCompletionBlock _Nullable)completion;

+ (NSSortDescriptor * _Nonnull)createDateSortDescriptor;
+ (NSPredicate * _Nonnull)predicateWithSourceType:(STKSourceType)sourceType;

+ (void)downloadPostsBeforePost:(STKPost * _Nullable)post
                         author:(STKAuthor * _Nullable)author
                     sourceType:(STKSourceType)sourceType
                     completion:(STKPostDownloadCompletion)completion;

+ (STKPost * _Nullable)postFromPostSearchResult:(STKPostSearchResult * _Nullable)postSearchResult;

- (void)bookmark;
- (NSURL * _Nullable)featureImageURL;
- (void)initializeSectionsFromHTML:(NSString * _Nullable)HTML;

@end

#import "STKPost+CoreDataProperties.h"
#import "STKPost+Analytical.h"
