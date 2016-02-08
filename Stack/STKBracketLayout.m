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
        CGRect headerFrame = CGRectMake(self.headerWidth * idx, 0.0f, self.headerWidth, self.headerHeight);

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
    height += self.headerHeight;
    height += (self.itemHeight * self.maxItemCount);
    height += (self.minimumItemSpacing * (self.maxItemCount + 1));

    CGFloat collectionViewAvailableHeight = CGRectGetHeight(self.collectionView.bounds) - self.collectionView.contentInset.top - self.collectionView.contentInset.bottom;

    if (height <= collectionViewAvailableHeight) {
        self.contentHeight = collectionViewAvailableHeight;
        self.collectionView.pagingEnabled = YES;
    }
    else {
        self.contentHeight = height;
        self.collectionView.pagingEnabled = NO;
    }
}

- (void)calculateItemOriginYs {
    self.itemCountOriginYs = [NSMutableDictionary dictionary];

    NSInteger previousItemCount = 0;
    NSArray *sortedItemCounts = [self.itemCounts sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO]]];

    for (NSNumber *itemCountNumber in sortedItemCounts) {
        NSInteger itemCount = itemCountNumber.integerValue;

        if (itemCount == self.maxItemCount) {
            CGFloat totalSpacing = self.contentHeight - self.headerHeight - (itemCount * self.itemHeight);
            CGFloat itemSpacing = totalSpacing / (itemCount + 1);
            CGFloat yOffset = self.headerHeight + itemSpacing;

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
