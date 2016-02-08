//
//  STKEventBracketsViewModel.h
//  Stack
//
//  Created by Bradley Smith on 2/5/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RZCollectionListCollectionViewDataSourceDelegate;
@class STKEventBracket, STKEventStage, STKEventGame;

@interface STKEventBracketsViewModel : NSObject

- (instancetype)initWithEventBracket:(STKEventBracket *)bracket;

- (void)setupDataSourceWithCollectionView:(UICollectionView *)collectionView delegate:(id <RZCollectionListCollectionViewDataSourceDelegate>)delegate;

- (STKEventStage *)stageForSection:(NSInteger)section;
- (STKEventGame *)objectAtIndexPath:(NSIndexPath *)indexPath;

@end
