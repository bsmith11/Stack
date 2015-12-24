//
//  STKPostSection.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKPostSection.h"
#import "STKPost.h"

#import "STKCoreDataStack.h"

#import <RZCollectionList/RZFetchedCollectionList.h>
#import <RZVinyl/RZVinyl.h>
#import <RZDataBinding/RZDBMacros.h>

@implementation STKPostSection

+ (RZFetchedCollectionList *)fetchedSectionsForPost:(STKPost *)post {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", RZDB_KP_CONCAT(RZDB_KP(STKPostSection, post), RZDB_KP(STKPost, postID)), post.postID];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[self rzv_entityName]];
    request.predicate = predicate;
    request.sortDescriptors = @[[self indexSortDescriptor]];

    RZFetchedCollectionList *fetchedList = [[RZFetchedCollectionList alloc] initWithFetchRequest:request managedObjectContext:[STKCoreDataStack defaultStack].mainManagedObjectContext sectionNameKeyPath:nil cacheName:nil];

    return fetchedList;
}

+ (NSSortDescriptor *)indexSortDescriptor {
    return [NSSortDescriptor sortDescriptorWithKey:RZDB_KP(STKPostSection, index) ascending:YES];
}

@end
