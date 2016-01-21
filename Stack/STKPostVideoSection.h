//
//  STKPostVideoSection.h
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import Foundation;

#import "STKPostMediaSection.h"

@class STKHTMLVideoSection;

NS_ASSUME_NONNULL_BEGIN

@interface STKPostVideoSection : STKPostMediaSection

+ (instancetype)sectionWithSection:(STKHTMLVideoSection *)section context:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "STKPostVideoSection+CoreDataProperties.h"
