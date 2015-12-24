//
//  STKAttachment.h
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STKHTMLImageSection;

NS_ASSUME_NONNULL_BEGIN

@interface STKAttachment : NSManagedObject

+ (instancetype)attachmentWithSection:(STKHTMLImageSection *)section context:(NSManagedObjectContext *)context;

- (void)setupWithSection:(STKHTMLImageSection *)section;

@end

NS_ASSUME_NONNULL_END

#import "STKAttachment+CoreDataProperties.h"
#import "STKAttachment+RZImport.h"
