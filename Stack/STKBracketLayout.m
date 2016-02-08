//
//  STKBracketLayout.m
//  Stack
//
//  Created by Bradley Smith on 2/7/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKBracketLayout.h"

#import <tgmath.h>

@interface STKBracketLayout ()

@property (strong, nonatomic) NSMutableArray *itemlayoutAttributesCache;
@property (strong, nonatomic) NSMutableArray *headerLayoutAttributesCache;

@property (assign, nonatomic) CGFloat contentWidth;
@property (assign, nonatomic) CGFloat contentHeight;

@end

@implementation STKBracketLayout

- (instancetype)init {
    self = [super init];

    if (self) {
        self.itemlayoutAttributesCache = [NSMutableArray array];
        self.headerLayoutAttributesCache = [NSMutableArray array];
    }

    return self;
}

- (void)prepareLayout {
    //Find max item count
    NSInteger maxItemCount = 0;
    NSInteger sectionCount = self.collectionView.numberOfSections;
    NSMutableArray *itemCounts = [NSMutableArray array];

    for (NSInteger sectionIndex = 0; sectionIndex < sectionCount; sectionIndex++) {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:sectionIndex];
        [itemCounts addObject:@(itemCount)];

        maxItemCount = MAX(maxItemCount, itemCount);
    }

    //Determine if content fits in one content page
    CGFloat height = 0.0f;
    height += self.headerHeight;
    height += (self.itemHeight * maxItemCount);
    height += (self.minimumItemSpacing * (maxItemCount + 1));

    CGFloat collectionViewAvailableHeight = CGRectGetHeight(self.collectionView.bounds) - self.collectionView.contentInset.top - self.collectionView.contentInset.bottom;

    if (height <= collectionViewAvailableHeight) {
        self.contentHeight = collectionViewAvailableHeight;
        self.collectionView.pagingEnabled = YES;
    }
    else {
        self.contentHeight = height - self.collectionView.contentInset.top - self.collectionView.contentInset.bottom;
        self.collectionView.pagingEnabled = NO;
    }

    CGFloat collectionViewAvailableWidth = CGRectGetWidth(self.collectionView.bounds) - self.collectionView.contentInset.left - self.collectionView.contentInset.right;
    self.contentWidth = collectionViewAvailableWidth * sectionCount;

    CGFloat headerWidth = collectionViewAvailableWidth;
    CGFloat itemWidth = collectionViewAvailableWidth - (2 * self.minimumItemSpacing);

    [itemCounts enumerateObjectsUsingBlock:^(NSNumber *itemCount, NSUInteger idx, BOOL *stop) {
        CGFloat yOffset = 0.0f;

        //Header
        NSIndexPath *headerIndexPath = [NSIndexPath indexPathForItem:0 inSection:(NSInteger)idx];
        UICollectionViewLayoutAttributes *headerAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:headerIndexPath];
        CGRect headerFrame = CGRectMake(headerWidth * idx, yOffset, headerWidth, self.headerHeight);

        headerAttributes.frame = headerFrame;
        [self.headerLayoutAttributesCache addObject:headerAttributes];
        yOffset += self.headerHeight;

        NSMutableArray *itemLayoutAttributes = [NSMutableArray array];

        //Items
        CGFloat totalSpacing = (self.contentHeight - self.headerHeight - (itemCount.integerValue * self.itemHeight));
        CGFloat itemSpacing = totalSpacing / (itemCount.integerValue + 1);

        yOffset += itemSpacing;

        for (NSInteger item = 0; item < itemCount.integerValue; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:(NSInteger)idx];
            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            CGRect frame = CGRectMake((collectionViewAvailableWidth * idx) + self.minimumItemSpacing, yOffset, itemWidth, self.itemHeight);

            itemAttributes.frame = frame;
            [itemLayoutAttributes addObject:itemAttributes];
            yOffset += (self.itemHeight + itemSpacing);
        }

        [self.itemlayoutAttributesCache addObject:itemLayoutAttributes];
    }];
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.contentWidth, self.contentHeight);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *layoutAttributes = [NSMutableArray array];

    for (NSArray *itemAttributes in self.itemlayoutAttributesCache) {
        for (UICollectionViewLayoutAttributes *attributes in itemAttributes) {
            if (CGRectIntersectsRect(attributes.frame, rect)) {
                [layoutAttributes addObject:attributes];
            }
        }
    }

    for (UICollectionViewLayoutAttributes *headerAttributes in self.headerLayoutAttributesCache) {
        if (CGRectIntersectsRect(headerAttributes.frame, rect)) {
            [layoutAttributes addObject:headerAttributes];
        }
    }

    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = nil;

    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        attributes = self.headerLayoutAttributesCache[(NSUInteger)indexPath.section];
    }

    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.itemlayoutAttributesCache[(NSUInteger)indexPath.section][(NSUInteger)indexPath.item];
}

- (void)invalidateLayout {
    [self.headerLayoutAttributesCache removeAllObjects];
    [self.itemlayoutAttributesCache removeAllObjects];
}

//- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
//    CGFloat currentContentOffsetX = self.collectionView.contentOffset.x;
//
//    CGPoint newContentOffset = CGPointMake(0.0f, proposedContentOffset.y);
//    CGFloat collectionViewAvailableWidth = CGRectGetWidth(self.collectionView.bounds) - self.collectionView.contentInset.left - self.collectionView.contentInset.right;
//    CGFloat value = currentContentOffsetX / collectionViewAvailableWidth;
//    NSInteger nextPageIndex = (NSInteger)__tg_ceil(value);
//    NSInteger previousPageIndex = (NSInteger)__tg_floor(value);
//
//    NSLog(@"Velocity: %@", @(velocity.x));
//
//    if (velocity.x > 0) {
//        newContentOffset.x = nextPageIndex * collectionViewAvailableWidth;
//    }
//    else {
//        newContentOffset.x = previousPageIndex * collectionViewAvailableWidth;
//    }
//
//    return newContentOffset;
//}

@end
