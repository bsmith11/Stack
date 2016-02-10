//
//  STKPostSearchResult.m
//  Stack
//
//  Created by Bradley Smith on 12/27/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKPostSearchResult.h"

#import "STKWordpressPostSearchResult.h"
#import "STKBloggerPostSearchResult.h"

#import "STKAPIClient.h"

#import <RZImport/NSObject+RZImport.h>
#import <RZDataBinding/RZDBMacros.h>

@implementation STKPostSearchResult

#pragma mark - Sort Descriptors

+ (NSSortDescriptor *)createDateSortDescriptor {
    return [NSSortDescriptor sortDescriptorWithKey:RZDB_KP(STKPostSearchResult, createDate) ascending:NO];
}

+ (void)searchPostsWithText:(NSString *)text
                 sourceType:(STKSourceType)sourceType
                 completion:(STKPostSearchResultCompletion)completion {
    [[STKAPIClient sharedInstance] searchPostsWithText:text
                                            sourceType:sourceType
                                            completion:^(NSArray *objects, NSError *error, STKSourceType type) {
                                                [self parseResponseObject:objects
                                                                    error:error
                                                               sourceType:type
                                                               completion:completion];
    }];
}

+ (void)parseResponseObject:(id)responseObject
                      error:(NSError *)error
                 sourceType:(STKSourceType)sourceType
                 completion:(STKPostSearchResultCompletion)completion {
    if (!error) {
        STKBackendType backendType = [STKSource backendTypeForType:sourceType];
        Class class;

        switch (backendType) {
            case STKBackendTypeWordpress:
                class = [STKWordpressPostSearchResult class];
                break;

            case STKBackendTypeRSS:
                class = nil;
                break;

            case STKBackendTypeBlogger:
                class = [STKBloggerPostSearchResult class];
                break;

            default:
                class = [STKWordpressPostSearchResult class];
                break;
        }

        NSArray *results = nil;
        if (class && responseObject) {
            results = [class rzi_objectsFromArray:responseObject];

            [results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                STKPostSearchResult *result = (STKPostSearchResult *)obj;
                result.sourceType = @(sourceType);
                result.postDictionary = responseObject[idx];
            }];
        }

        if (completion) {
            completion(results, nil);
        }
    }
    else {
        if (completion) {
            completion(nil, error);
        }
    }
}

+ (void)cancelPreviousPostSearches {
    [[STKAPIClient sharedInstance] cancelPreviousPostSearches];
}

@end
