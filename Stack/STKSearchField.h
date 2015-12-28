//
//  STKSearchField.h
//  Stack
//
//  Created by Bradley Smith on 12/27/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STKSearchField : UITextField

- (void)stk_setPlaceholderText:(NSString *)placeholderText;
- (void)stk_clearText;

@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) BOOL loading;

@end
