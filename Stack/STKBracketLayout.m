//
//  STKBracketLayout.m
//  Stack
//
//  Created by Bradley Smith on 2/7/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKBracketLayout.h"

#import "NSNumber+STKCGFloat.h"

#import <tgmath.h>

@interface STKBracketLayout ()

@property (strong, nonatomic) NSMutableArray *itemlayoutAttributesCache;
@property (strong, nonatomic) NSMutableArray *headerLayoutAttributesCache;

@property (strong, nonatomic) NSMutableArray<NSNumber *> *itemCounts;
@property (strong, nonatomic) NSMutableDictionary<NSNumber *, NSMutableArray *> *itemCountOriginYs;

@property (assign, nonatomic) CGFloat contentWidth;
@property (assign, nonatomic) CGFloat contentHeight;

@property (assign, nonatomic) CGFloat headerWidth;
@property (assign, nonatomic) CGFloat itemWidth;

@property (assign, nonatomic) NSInteger maxItemCount;

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
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    self.collectionView.directionalLockEnabled = YES;

    [self calculateMaxItemCount];
    [self calculateContentHeight];

    CGFloat collectionViewAvailableWidth = CGRectGetWidth(self.collectionView.bounds) - self.collectionView.contentInset.left - self.collectionView.contentInset.right;
    self.contentWidth = collectionViewAvailableWidth * self.collectionView.numberOfSections;
    self.headerWidth = collectionViewAvailableWidth;
    self.itemWidth = collectionViewAvailableWidth - (4 * self.minimumItemSpacing);

    [self calculateItemOriginYs];

    [self.itemCounts enumerateObjectsUsingBlock:^(NSNumber *itemCountNumber, NSUInteger idx, BOOL *stop) {
        //Header
        NSIndexPath *headerIndexPath = [NSIndexPath indexPathForItem:0 inSection:(NSInteger)idx];
        UICollectionViewLayoutAttributes *headerAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:headerIndexPath];
        CGRect headerFrame = CGRectMake(self.headerWidth * idx, self.collectionView.contentOffset.y + self.collectionView.contentInset.top, self.headerWidth, self.headerHeight);

        headerAttributes.frame = headerFrame;
        [self.headerLayoutAttributesCache addObject:headerAttributes];

        NSMutableArray *itemLayoutAttributes = [NSMutableArray array];

        for (NSInteger item = 0; item < itemCountNumber.integerValue; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:(NSInteger)idx];
            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

            CGFloat yOffset = [self.itemCountOriginYs[itemCountNumber][(NSUInteger)item] CGFloatValue];
            itemAttributes.frame = CGRectMake((collectionViewAvailableWidth * idx) + (2 * self.minimumItemSpacing), yOffset, self.itemWidth, self.itemHeight);
            [itemLayoutAttributes addObject:itemAttributes];
        }

        [self.itemlayoutAttributesCache addObject:itemLayoutAttributes];
    }];
}

- (void)calculateMaxItemCount {
    self.maxItemCount = 0;
    NSInteger sectionCount = self.collectionView.numberOfSections;
    self.itemCounts = [NSMutableArray array];

    for (NSInteger sectionIndex = 0; sectionIndex < sectionCount; sectionIndex++) {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:sectionIndex];
        [self.itemCounts addObject:@(itemCount)];

        self.maxItemCount = MAX(self.maxItemCount, itemCount);
    }
}

- (void)calculateContentHeight {
    CGFloat height = 0.0f;
    height += (self.headerHeight - self.minimumItemSpacing);
    height += (self.itemHeight * self.maxItemCount);
    height += (self.minimumItemSpacing * (self.maxItemCount + 1));

    CGFloat collectionViewAvailableHeight = CGRectGetHeight(self.collectionView.bounds) - self.collectionView.contentInset.top - self.collectionView.contentInset.bottom;

    if (height <= collectionViewAvailableHeight) {
        self.contentHeight = collectionViewAvailableHeight;
    }
    else {
        self.contentHeight = height;
    }
}

- (void)calculateItemOriginYs {
    self.itemCountOriginYs = [NSMutableDictionary dictionary];

    NSInteger previousItemCount = 0;
    NSArray *sortedItemCounts = [self.itemCounts sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO]]];
    NSOrderedSet *uniqueItemCounts = [NSOrderedSet orderedSetWithArray:sortedItemCounts];

    for (NSNumber *itemCountNumber in uniqueItemCounts) {
        NSInteger itemCount = itemCountNumber.integerValue;

        if (itemCount == self.maxItemCount) {
            CGFloat totalSpacing = self.contentHeight - (self.headerHeight - self.minimumItemSpacing) - (itemCount * self.itemHeight);
            CGFloat itemSpacing = totalSpacing / (itemCount + 1);
            CGFloat yOffset = (self.headerHeight - self.minimumItemSpacing) + itemSpacing;

            NSMutableArray *itemOriginYs = [NSMutableArray array];

            for (NSInteger item = 0; item < itemCount; item++) {
                [itemOriginYs addObject:@(yOffset)];

                yOffset += (self.itemHeight + itemSpacing);
            }

            self.itemCountOriginYs[@(itemCount)] = itemOriginYs;
        }
        else {
            NSMutableArray *itemOriginYs = [NSMutableArray array];

            for (NSInteger item = 0; item < itemCount; item++) {
                NSMutableArray *previousItemOriginYs = self.itemCountOriginYs[@(previousItemCount)];
                NSUInteger firstItem = (NSUInteger)(item * 2);
                NSUInteger secondItem = firstItem + 1;

                CGFloat firstYOffset = [previousItemOriginYs[firstItem] CGFloatValue];
                CGFloat yOffset;

                if (secondItem < previousItemOriginYs.count) {
                    CGFloat secondYOffset = [previousItemOriginYs[secondItem] CGFloatValue];
                    yOffset = ((firstYOffset + secondYOffset + self.itemHeight) / 2) - (self.itemHeight / 2);
                }
                else {
                    yOffset = firstYOffset;
                }

                [itemOriginYs addObject:@(yOffset)];
            }
            
            self.itemCountOriginYs[@(itemCount)] = itemOriginYs;
        }
        
        previousItemCount = itemCount;
    }
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
        CGRect frame = attributes.frame;
        frame.origin.y = self.collectionView.contentOffset.y + self.collectionView.contentInset.top;
        attributes.frame = frame;
        attributes.zIndex = 999;
    }

    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.itemlayoutAttributesCache[(NSUInteger)indexPath.section][(NSUInteger)indexPath.item];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    [self invalidateLayoutWithContext:[self invalidationContextForBoundsChange:newBounds]];

    return [super shouldInvalidateLayoutForBoundsChange:newBounds];
}

- (UICollectionViewLayoutInvalidationContext *)invalidationContextForBoundsChange:(CGRect)newBounds {
    UICollectionViewLayoutInvalidationContext *context = [super invalidationContextForBoundsChange:newBounds];

    NSArray *headerIndexPaths = [self.headerLayoutAttributesCache valueForKey:@"indexPath"];
    [context invalidateSupplementaryElementsOfKind:UICollectionElementKindSectionHeader atIndexPaths:headerIndexPaths];

    return context;
}

- (void)invalidateLayout {
    [self.headerLayoutAttributesCache removeAllObjects];
    [self.itemlayoutAttributesCache removeAllObjects];

    [super invalidateLayout];
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGFloat collectionViewWidth = (CGRectGetWidth(self.collectionView.bounds) - self.collectionView.contentInset.left - self.collectionView.contentInset.right);
    CGFloat value = self.collectionView.contentOffset.x / collectionViewWidth;
    NSInteger index = 0;

    if (velocity.x > 0) {
        index = MIN((NSInteger)__tg_ceil(value), self.collectionView.numberOfSections - 1);
    }
    else if (velocity.x < 0) {
        index = MAX((NSInteger)__tg_floor(value), 0);
    }
    else {
        index = MAX((NSInteger)__tg_round(value), 0);
    }

    proposedContentOffset.x = index * collectionViewWidth;

    return proposedContentOffset;
}

@end
