//
//  STKNetworkImageNode.h
//  Stack
//
//  Created by Bradley Smith on 1/17/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface STKNetworkImageNode : ASNetworkImageNode

@property (assign, nonatomic) CGSize staticImageSize;
@property (assign, nonatomic) CGSize originalImageSize;

@end
