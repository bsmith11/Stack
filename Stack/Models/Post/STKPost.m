//
//  STKPost.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKWordpressPost.h"
#import "STKRSSPost.h"
#import "STKBloggerPost.h"
#import "STKPostSearchResult.h"
#import "STKAttachment.h"
#import "STKAuthor.h"
#import "STKPostParagraphSection.h"
#import "STKPostImageSection.h"
#import "STKPostVideoSection.h"

#import "STKHTML.h"
#import "STKCoreDataStack.h"
#import "STKAPIClient.h"
#import "UIColor+STKStyle.h"
#import "UIFont+STKStyle.h"

#import <RZCollectionList/RZFetchedCollectionList.h>
#import <RZVinyl/RZVinyl.h>
#import <RZDataBinding/RZDBMacros.h>

@implementation STKPost

#pragma mark - RZVinyl

+ (NSPredicate *)rzv_stalenessPredicate {
    NSTimeInterval oneWeekAgo = -604800.0;
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:oneWeekAgo];
    NSPredicate *fetchDatePredicate = [NSPredicate predicateWithFormat:@"%K < %@", RZDB_KP(STKPost, lastSaveDate), date];
    NSPredicate *bookmarkPredicate = [NSPredicate predicateWithFormat:@"%K == %@", RZDB_KP(STKPost, bookmarked), @NO];
    NSCompoundPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[fetchDatePredicate, bookmarkPredicate]];

    return predicate;
}

#pragma mark - Fetches

+ (NSArray *)fetchPostsBeforePost:(STKPost *)post
                           author:(STKAuthor *)author
                       sourceType:(STKSourceType)sourceType {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self rzv_entityName]];
    request.sortDescriptors = @[[self createDateSortDescriptor]];
    NSMutableArray *subPredicates = [@[[self beforePostPredicate:post]] mutableCopy];
    if (author) {
        [subPredicates addObject:[self predicateWithAuthor:author]];
    }

    if (sourceType >= 0) {
        [subPredicates addObject:[self predicateWithSourceType:sourceType]];
    }

    request.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:subPredicates];
    request.fetchLimit = 10;

    NSError *error = nil;
    NSArray *posts = [[STKCoreDataStack defaultStack].mainManagedObjectContext executeFetchRequest:request error:&error];

    if (error ) {
        NSLog(@"Failed to fetch posts with error: %@", error);

        posts = nil;
    }

    return posts;
}

+ (void)fetchPostsBeforePost:(STKPost *)post
                      author:(STKAuthor *)author
                  sourceType:(STKSourceType)sourceType
                  completion:(NSPersistentStoreAsynchronousFetchResultCompletionBlock)completion {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self rzv_entityName]];
    request.sortDescriptors = @[[self createDateSortDescriptor]];
    NSMutableArray *subPredicates = [@[[self beforePostPredicate:post]] mutableCopy];
    if (author) {
        [subPredicates addObject:[self predicateWithAuthor:author]];
    }

    if (sourceType >= 0) {
        [subPredicates addObject:[self predicateWithSourceType:sourceType]];
    }

    request.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:subPredicates];
    request.fetchLimit = 10;

    NSAsynchronousFetchRequest *asyncRequest = [[NSAsynchronousFetchRequest alloc] initWithFetchRequest:request
                                                                                        completionBlock:completion];
    NSManagedObjectContext *context = [STKCoreDataStack defaultStack].mainManagedObjectContext;

    [context performBlock:^{
        [context executeRequest:asyncRequest error:nil];
    }];
}

+ (RZFetchedCollectionList *)fetchedListOfBookmarkedPosts {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self rzv_entityName]];
    request.sortDescriptors = @[[self createDateSortDescriptor]];
    request.predicate = [self bookmarkedPredicate];

    RZFetchedCollectionList *fetchedList = [[RZFetchedCollectionList alloc] initWithFetchRequest:request
                                                                            managedObjectContext:[STKCoreDataStack defaultStack].mainManagedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
    return fetchedList;
}

#pragma mark - Sort Descriptors

+ (NSSortDescriptor *)createDateSortDescriptor {
    return [NSSortDescriptor sortDescriptorWithKey:RZDB_KP(STKPost, createDate) ascending:NO];
}

#pragma mark - Predicates

+ (NSPredicate *)bookmarkedPredicate {
    return [NSPredicate predicateWithFormat:@"%K == YES", RZDB_KP(STKPost, bookmarked)];
}

+ (NSPredicate *)beforePostPredicate:(STKPost *)post {
    NSDate *date = post ? post.createDate : [NSDate date];

    return [NSPredicate predicateWithFormat:@"%K < %@", RZDB_KP(STKPost, createDate), date];
}

+ (NSPredicate *)predicateWithAuthor:(STKAuthor *)author {
    return [NSPredicate predicateWithFormat:@"%K == %@", RZDB_KP_CONCAT(RZDB_KP(STKPost, author), RZDB_KP(STKAuthor, authorID)), author.authorID];
}

+ (NSPredicate *)predicateWithSourceType:(STKSourceType)sourceType {
    return [NSPredicate predicateWithFormat:@"%K == %@", RZDB_KP(STKPost, sourceType), @(sourceType)];
}

#pragma mark - Downloads

+ (void)downloadPostsBeforePost:(STKPost *)post
                         author:(STKAuthor *)author
                     sourceType:(STKSourceType)sourceType
                     completion:(STKPostDownloadCompletion)completion {
    [[STKAPIClient sharedInstance] getPostsBeforePost:post
                                               author:author
                                           sourceType:sourceType
                                           completion:^(id responseObject, NSError *error, STKSourceType type) {
                                               [self parseResponseObject:responseObject
                                                                   error:error
                                                              sourceType:type
                                                              completion:completion];
                                           }];
}

+ (void)parseResponseObject:(id)responseObject
                      error:(NSError *)error
                 sourceType:(STKSourceType)sourceType
                 completion:(void (^)(NSError *))completion {
    if (!error) {
        STKBackendType backendType = [STKSource backendTypeForType:sourceType];
        Class class;

        switch (backendType) {
            case STKBackendTypeWordpress:
                class = [STKWordpressPost class];
                break;

            case STKBackendTypeRSS:
                class = [STKRSSPost class];
                break;

            case STKBackendTypeBlogger:
                class = [STKBloggerPost class];
                break;

            default:
                class = [STKWordpressPost class];
                break;
        }

        [[STKCoreDataStack defaultStack] performBlockUsingBackgroundContext:^(NSManagedObjectContext *context) {
            NSArray *posts = [class rzi_objectsFromArray:responseObject inContext:context];
            NSDate *date = [NSDate date];

            for (STKPost *post in posts) {
                post.sourceType = @(sourceType);
                post.author.sourceType = @(sourceType);
                post.lastSaveDate = date;
            }
        } completion:completion];
    }
    else {
        if (completion) {
            completion(error);
        }
    }
}

#pragma mark - Actions

+ (STKPost *)postFromPostSearchResult:(STKPostSearchResult *)postSearchResult {
    STKBackendType backendType = [STKSource backendTypeForType:postSearchResult.sourceType.integerValue];
    Class class;

    switch (backendType) {
        case STKBackendTypeWordpress:
            class = [STKWordpressPost class];
            break;

        case STKBackendTypeRSS:
            class = [STKRSSPost class];
            break;

        case STKBackendTypeBlogger:
            class = [STKBloggerPost class];
            break;

        default:
            class = [STKWordpressPost class];
            break;
    }

    __block STKPost *post = nil;
    NSManagedObjectContext *context = [STKCoreDataStack defaultStack].mainManagedObjectContext;

    [context performBlockAndWait:^{
        post = [class rzi_objectFromDictionary:postSearchResult.postDictionary inContext:context];
        post.author.sourceType = postSearchResult.sourceType;
        post.sourceType = postSearchResult.sourceType;

        [context save:NULL];
    }];
    
    return post;
}

- (void)bookmark {
    [[STKCoreDataStack defaultStack] performBlockUsingBackgroundContext:^(NSManagedObjectContext *context) {
        STKPost *post = (STKPost *)[context objectWithID:self.objectID];
        post.bookmarked = @(!post.bookmarked.boolValue);
    } completion:nil];
}

- (NSURL *)featureImageURL {
    NSURL *featureImageURL = nil;

    if (self.attachment.sourceURL) {
        featureImageURL = [NSURL URLWithString:self.attachment.sourceURL];
    }
    else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"class == %@", [STKPostImageSection class]];
        NSSet *imageSections = [self.sections filteredSetUsingPredicate:predicate];
        NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:RZDB_KP(STKPostImageSection, index) ascending:YES]];
        STKPostImageSection *section = [imageSections sortedArrayUsingDescriptors:sortDescriptors].firstObject;

        if (section.sourceURL) {
            featureImageURL = [NSURL URLWithString:section.sourceURL];
        }
    }

    return featureImageURL;
}

- (void)initializeSectionsFromHTML:(NSString *)HTML {
    NSManagedObjectContext *context = self.managedObjectContext;

    for (STKPostSection *section in self.sections) {
        [context deleteObject:section];
    }

    NSDictionary *options = @{kSTKHTMLOptionsKeyFontFamily:@"Gotham",
                              kSTKHTMLOptionsKeyFontSize:@(kSTKDefaultFontSize),
                              kSTKHTMLOptionsKeyTextColor:[UIColor stk_stackColor]};
    NSMutableArray *sections = [[STKHTMLSection sectionsFromHTML:HTML options:options] mutableCopy];

    if ([sections.firstObject isKindOfClass:[STKHTMLImageSection class]] && !self.attachment.attachmentID) {
        if (!self.attachment) {
            STKAttachment *attachment = [STKAttachment attachmentWithSection:sections.firstObject context:context];
            self.attachment = attachment;
        }
        else {
            [self.attachment setupWithSection:sections.firstObject];
        }

        [sections removeObject:sections.firstObject];
    }

    [sections enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[STKHTMLParagraphSection class]]) {
            STKHTMLParagraphSection *section = (STKHTMLParagraphSection *)obj;
            STKPostParagraphSection *postParagraphSection = [STKPostParagraphSection sectionWithSection:section context:context];
            [self addSectionsObject:postParagraphSection];
        }
        else if ([obj isKindOfClass:[STKHTMLImageSection class]]) {
            STKHTMLImageSection *section = (STKHTMLImageSection *)obj;
            STKPostImageSection *postImageSection = [STKPostImageSection sectionWithSection:section context:context];
            [self addSectionsObject:postImageSection];
        }
        else if ([obj isKindOfClass:[STKHTMLVideoSection class]]) {
            STKHTMLVideoSection *section = (STKHTMLVideoSection *)obj;
            STKPostVideoSection *postVideoSection = [STKPostVideoSection sectionWithSection:section context:context];
            [self addSectionsObject:postVideoSection];
        }
    }];
}

@end
