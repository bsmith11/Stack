//
//  STKAuthor.h
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import Foundation;
@import CoreData;

@class STKPost;

NS_ASSUME_NONNULL_BEGIN

@interface STKAuthor : NSManagedObject

- (NSAttributedString *)attributedSummary;

@end

NS_ASSUME_NONNULL_END

#import "STKAuthor+CoreDataProperties.h"
#import "STKAuthor+Analytical.h"
#import "STKAuthor+RZImport.h"
