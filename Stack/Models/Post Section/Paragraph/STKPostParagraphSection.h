//
//  STKPostParagraphSection.h
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import Foundation;

#import "STKPostSection.h"

@class STKHTMLParagraphSection;

NS_ASSUME_NONNULL_BEGIN

@interface STKPostParagraphSection : STKPostSection

+ (instancetype)sectionWithSection:(STKHTMLParagraphSection *)section context:(NSManagedObjectContext *)context;

- (NSAttributedString *)attributedContent;

@end

NS_ASSUME_NONNULL_END

#import "STKPostParagraphSection+CoreDataProperties.h"
