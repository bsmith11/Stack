//
//  STKAPIConstants.h
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import Foundation;

typedef void (^STKAPIURLSessionCompletion)(id responseObject, NSError *error);
typedef void (^STKAPICompletion)(NSArray *objects, NSError *error, STKSourceType sourceType);

OBJC_EXTERN NSString * const kSTKAPIBaseURLSkyd;
OBJC_EXTERN NSString * const kSTKAPIBaseURLBamaSecs;
OBJC_EXTERN NSString * const kSTKAPIBaseURLUltiworld;
OBJC_EXTERN NSString * const kSTKAPIBaseURLAUDL;
OBJC_EXTERN NSString * const kSTKAPIBaseURLMLU;
OBJC_EXTERN NSString * const kSTKAPIBaseURLGetHorizontal;
OBJC_EXTERN NSString * const kSTKAPIBaseURLBlogger;

OBJC_EXTERN NSString * const kSTKAPIBloggerIDSludge;
OBJC_EXTERN NSString * const kSTKAPIBloggerIDProcessOfIllumination;
