//
//  STKPostSearchResult.h
//  Stack
//
//  Created by Bradley Smith on 12/27/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^STKPostSearchResultCompletion)(NSArray *results, NSError *error);

@interface STKPostSearchResult : NSObject

+ (NSSortDescriptor *)createDateSortDescriptor;

+ (void)searchPostsWithText:(NSString *)text
                 sourceType:(STKSourceType)sourceType
                 completion:(STKPostSearchResultCompletion)completion;

+ (void)cancelPreviousPostSearches;

@property (strong, nonatomic) NSString *postID;
@property (strong, nonatomic) NSDate *createDate;
@property (strong, nonatomic) NSDate *modifyDate;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSNumber *sourceType;
@property (strong, nonatomic) NSDictionary *postDictionary;

@end
