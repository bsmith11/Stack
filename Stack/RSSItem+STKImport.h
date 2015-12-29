//
//  RSSItem+STKImport.h
//  Stack
//
//  Created by Bradley Smith on 12/21/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import <BlockRSSParser/RSSItem.h>

@interface RSSItem (STKImport)

+ (NSMutableDictionary *)stk_postImportDictionaryFromItem:(RSSItem *)item;
+ (NSMutableDictionary *)stk_commentImportDictionaryFromItem:(RSSItem *)item;

+ (NSMutableArray *)stk_postImportDictionariesFromArray:(NSArray *)feedItems;
+ (NSMutableArray *)stk_commentImportDictionariesFromArray:(NSArray *)feedItems;

@end
