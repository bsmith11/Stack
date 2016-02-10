//
//  STKAPIWordpressConstants.h
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import Foundation;

OBJC_EXTERN NSString * const kSTKAPIWordpressRoutePrefix;
OBJC_EXTERN NSString * const kSTKAPIWordpressRoutePosts;
OBJC_EXTERN NSString * const kSTKAPIWordpressRoutePostComments;

OBJC_EXTERN NSString * const kSTKAPIWordpressRequestKeyFilter;
OBJC_EXTERN NSString * const kSTKAPIWordpressRequestKeySearch;
OBJC_EXTERN NSString * const kSTKAPIWordpressRequestKeyPostsPerPage;
OBJC_EXTERN NSString * const kSTKAPIWordpressRequestKeyDateQuery;
OBJC_EXTERN NSString * const kSTKAPIWordpressRequestKeyBefore;
OBJC_EXTERN NSString * const kSTKAPIWordpressRequestKeyAuthor;

//Post

OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyID;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyAuthor;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyCommentStatus;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyContent;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyDate;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyDateGMT;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyDateTZ;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyExcerpt;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyFeaturedImage;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyFormat;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyGUID;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyLink;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyMenuOrder;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyMeta;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyModified;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyModifiedGMT;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyModifiedTZ;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyParent;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyPingStatus;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeySlug;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyStatus;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeySticky;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyTerms;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyTitle;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyType;

OBJC_EXTERN NSString * const kSTKAPIWordpressResponseValueOpen;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseValueClosed;

//Author

OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyURL;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyAvatar;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyDescription;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyFirstName;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyLastName;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyName;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyNickname;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyRegistered;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeySlug;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyUsername;

//Attachment

OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyAttachmentMeta;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyFile;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyHeight;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyImageMeta;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeySizes;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyWidth;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyIsImage;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeySource;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyErrors;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyErrorData;

//Image

OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyMimeType;
OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyUrl;

//Comment

OBJC_EXTERN NSString * const kSTKAPIWordpressResponseKeyPost;
