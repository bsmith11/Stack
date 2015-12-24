//
//  RSSItem+STKImport.m
//  Stack
//
//  Created by Bradley Smith on 12/21/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "RSSItem+STKImport.h"

#import "STKFormatter.h"
#import "STKAPIRSSConstants.h"

#import <RZUtils/RZCommonUtils.h>

@implementation RSSItem (STKImport)

+ (NSDictionary *)stk_postImportDictionaryFromItem:(RSSItem *)item {
    NSMutableDictionary *dictionary = nil;

    if (![item.categories containsObject:@"Deals"] && ![item.categories containsObject:@"Deal Alert"]) {
        dictionary = [NSMutableDictionary dictionary];

        NSString *postID = [item.guid componentsSeparatedByString:@"="].lastObject;
        dictionary[kSTKAPIRSSResponseKeyID] = RZNilToNSNull(postID);
        dictionary[kSTKAPIRSSResponseKeyTitle] = RZNilToNSNull(item.title);
        dictionary[kSTKAPIRSSResponseKeyLink] = RZNilToNSNull(item.link.absoluteString);

        NSString *createDate = [[STKFormatter wordpressDateFormatter] stringFromDate:item.pubDate];
        dictionary[kSTKAPIRSSResponseKeyCreateDate] = RZNilToNSNull(createDate);
        dictionary[kSTKAPIRSSResponseKeyCommentsRSS] = RZNilToNSNull(item.commentsFeed.absoluteString);

        dictionary[kSTKAPIRSSResponseKeyAuthor] = RZNilToNSNull(item.author);
        NSString *content = item.content ?: item.itemDescription;
        dictionary[kSTKAPIRSSResponseKeyContent] = RZNilToNSNull(content);
    }

    return [dictionary copy];
}

+ (NSDictionary *)stk_commentImportDictionaryFromItem:(RSSItem *)item postID:(NSString *)postID {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    NSString *endString = [item.guid componentsSeparatedByString:@"="].lastObject;
    NSString *commentID = [endString componentsSeparatedByString:@"-"].lastObject;
    dictionary[kSTKAPIRSSResponseKeyID] = RZNilToNSNull(commentID);

    NSString *createDate = [[STKFormatter wordpressDateFormatter] stringFromDate:item.pubDate];
    dictionary[kSTKAPIRSSResponseKeyCreateDate] = RZNilToNSNull(createDate);
    dictionary[kSTKAPIRSSResponseKeyAuthor] = RZNilToNSNull(item.author);

    NSString *content = item.content ?: item.itemDescription;
    dictionary[kSTKAPIRSSResponseKeyContent] = RZNilToNSNull(content);
    dictionary[kSTKAPIRSSResponseKeyPostID] = RZNilToNSNull(postID);

    return [dictionary copy];
}

+ (NSArray *)stk_postImportDictionariesFromArray:(NSArray *)feedItems {
    NSMutableArray *dictionaries = [NSMutableArray array];

    for (RSSItem *item in feedItems) {
        NSDictionary *dictionary = [self stk_postImportDictionaryFromItem:item];
        if (dictionary) {
            [dictionaries addObject:dictionary];
        }
    }

    return [dictionaries copy];
}

+ (NSArray *)stk_commentImportDictionariesFromArray:(NSArray *)feedItems postID:(NSString *)postID {
    NSMutableArray *dictionaries = [NSMutableArray array];

    for (RSSItem *item in feedItems) {
        NSDictionary *dictionary = [self stk_commentImportDictionaryFromItem:item postID:postID];
        if (dictionary) {
            [dictionaries addObject:dictionary];
        }
    }

    return [dictionaries copy];
}

@end
