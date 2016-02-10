//
//  STKPostImageSection.h
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import Foundation;

#import "STKPostMediaSection.h"

@class STKHTMLImageSection;

NS_ASSUME_NONNULL_BEGIN

@interface STKPostImageSection : STKPostMediaSection

+ (instancetype)sectionWithSection:(STKHTMLImageSection *)section context:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "STKPostImageSection+CoreDataProperties.h"
