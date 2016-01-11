//
//  STKAPIBloggerConstants.h
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import Foundation;

OBJC_EXTERN NSString * const kSTKAPIBloggerRoutePrefix;
OBJC_EXTERN NSString * const kSTKAPIBloggerRoutePosts;
OBJC_EXTERN NSString * const kSTKAPIBloggerRoutePostComments;
OBJC_EXTERN NSString * const kSTKAPIBloggerRoutePostsSearch;

OBJC_EXTERN NSString * const kSTKAPIBloggerRequestKeyMaxResults;
OBJC_EXTERN NSString * const kSTKAPIBloggerRequestKeyFetchImages;
OBJC_EXTERN NSString * const kSTKAPIBloggerRequestKeyStatus;
OBJC_EXTERN NSString * const kSTKAPIBloggerRequestKeyEndDate;
OBJC_EXTERN NSString * const kSTKAPIBloggerRequestKeyAPIKey;
OBJC_EXTERN NSString * const kSTKAPIBloggerRequestKeyQuery;

OBJC_EXTERN NSString * const kSTKAPIBloggerRequestValueStatus;

//Post

OBJC_EXTERN NSString * const kSTKAPIBloggerRequestKeyBlogID;

OBJC_EXTERN NSString * const kSTKAPIBloggerResponseKeyItems;
OBJC_EXTERN NSString * const kSTKAPIBloggerResponseKeyID;
OBJC_EXTERN NSString * const kSTKAPIBloggerResponseKeyTitle;
OBJC_EXTERN NSString * const kSTKAPIBloggerResponseKeyURL;
OBJC_EXTERN NSString * const kSTKAPIBloggerResponseKeyPublished;
OBJC_EXTERN NSString * const kSTKAPIBloggerResponseKeyContent;
OBJC_EXTERN NSString * const kSTKAPIBloggerResponseKeyUpdated;
OBJC_EXTERN NSString * const kSTKAPIBloggerResponseKeySelfLink;
OBJC_EXTERN NSString * const kSTKAPIBloggerResponseKeyLabels;
OBJC_EXTERN NSString * const kSTKAPIBloggerResponseKeyReplies;
OBJC_EXTERN NSString * const kSTKAPIBloggerResponseKeyBlog;
OBJC_EXTERN NSString * const kSTKAPIBloggerResponseKeyImages;
OBJC_EXTERN NSString * const kSTKAPIBloggerResponseKeyKind;
OBJC_EXTERN NSString * const kSTKAPIBloggerResponseKeyETag;

//Author

OBJC_EXTERN NSString * const kSTKAPIBloggerResponseKeyAuthor;
OBJC_EXTERN NSString * const kSTKAPIBloggerResponseKeyDisplayName;
OBJC_EXTERN NSString * const kSTKAPIBloggerResponseKeyImage;

//Comment

OBJC_EXTERN NSString * const kSTKAPIBloggerRequestKeyPostID;
OBJC_EXTERN NSString * const kSTKAPIBloggerRequestKeyFetchBodies;

OBJC_EXTERN NSString * const kSTKAPIBloggerResponseKeyPost;
