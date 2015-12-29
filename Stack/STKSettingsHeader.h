//
//  STKSettingsHeader.h
//  Stack
//
//  Created by Bradley Smith on 12/28/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STKSettingsHeader : NSObject

+ (instancetype)headerWithTitle:(NSAttributedString *)title;

@property (copy, nonatomic) NSAttributedString *title;

@end
