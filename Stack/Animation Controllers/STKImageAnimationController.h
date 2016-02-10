//
//  STKImageAnimationController.h
//  Stack
//
//  Created by Bradley Smith on 12/21/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKBaseAnimationController.h"

@interface STKImageAnimationController : STKBaseAnimationController

@property (copy, nonatomic) NSURL *imageURL;

@property (assign, nonatomic) CGRect originalRect;

@end
