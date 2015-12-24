//
//  STKHTMLMediaSection.h
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKHTMLSection.h"

@interface STKHTMLMediaSection : STKHTMLSection

@property (strong, nonatomic) NSString *sourceURL;
@property (strong, nonatomic) NSNumber *width;
@property (strong, nonatomic) NSNumber *height;
@property (strong, nonatomic) NSString *linkURL;

@end
