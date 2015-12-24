//
//  STKRSSSessionManager.h
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import Foundation;

#import "STKSessionManagerProtocol.h"

@interface STKRSSSessionManager : NSObject <STKSessionManagerProtocol>

@property (strong, nonatomic, readonly) NSURL *baseURL;

@end
