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

+ (NSMutableDictionary *)stk_postImportDictionaryFromItem:(RSSItem *)item {
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

    return dictionary;
}

+ (NSMutableDictionary *)stk_commentImportDictionaryFromItem:(RSSItem *)item {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    NSString *endString = [item.guid componentsSeparatedByString:@"="].lastObject;
    NSString *commentID = [endString componentsSeparatedByString:@"-"].lastObject;
    dictionary[kSTKAPIRSSResponseKeyID] = RZNilToNSNull(commentID);

    NSString *createDate = [[STKFormatter wordpressDateFormatter] stringFromDate:item.pubDate];
    dictionary[kSTKAPIRSSResponseKeyCreateDate] = RZNilToNSNull(createDate);
    dictionary[kSTKAPIRSSResponseKeyAuthor] = RZNilToNSNull(item.author);

    NSString *content = item.content ?: item.itemDescription;
    dictionary[kSTKAPIRSSResponseKeyContent] = RZNilToNSNull(content);

    return dictionary;
}

+ (NSMutableArray *)stk_postImportDictionariesFromArray:(NSArray *)feedItems {
    NSMutableArray *dictionaries = [NSMutableArray array];

    for (RSSItem *item in feedItems) {
        NSMutableDictionary *dictionary = [self stk_postImportDictionaryFromItem:item];
        if (dictionary) {
            [dictionaries addObject:dictionary];
        }
    }

    return dictionaries;
}

+ (NSMutableArray *)stk_commentImportDictionariesFromArray:(NSArray *)feedItems {
    NSMutableArray *dictionaries = [NSMutableArray array];

    for (RSSItem *item in feedItems) {
        NSMutableDictionary *dictionary = [self stk_commentImportDictionaryFromItem:item];
        if (dictionary) {
            [dictionaries addObject:dictionary];
        }
    }

    return dictionaries;
}

@end
