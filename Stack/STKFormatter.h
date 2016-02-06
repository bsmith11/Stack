//
//  STKFormatter.h
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import Foundation;

@interface STKFormatter : NSObject

+ (NSDateFormatter *)wordpressDateFormatter;
+ (NSDateFormatter *)twitterDateFormatter;
+ (NSDateFormatter *)bloggerDateFormatter;
+ (NSDateFormatter *)eventDateFormatter;
+ (NSDateFormatter *)gameDateDateFormatter;
+ (NSDateFormatter *)gameTimeDateFormatter;
+ (NSDateFormatter *)gameDisplayDateFormatter;

@end
