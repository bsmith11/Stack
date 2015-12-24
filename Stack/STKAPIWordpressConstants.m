//
//  STKAPIWordpressConstants.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKAPIWordpressConstants.h"

NSString * const kSTKAPIWordpressRoutePrefix = @"/wp-json";
NSString * const kSTKAPIWordpressRoutePosts = @"/posts";
NSString * const kSTKAPIWordpressRoutePostComments = @"/posts/%@/comments";

NSString * const kSTKAPIWordpressRequestKeyFilter = @"filter";
NSString * const kSTKAPIWordpressRequestKeySearch = @"s";
NSString * const kSTKAPIWordpressRequestKeyPostsPerPage = @"posts_per_page";
NSString * const kSTKAPIWordpressRequestKeyDateQuery = @"date_query";
NSString * const kSTKAPIWordpressRequestKeyBefore = @"before";
NSString * const kSTKAPIWordpressRequestKeyAuthor = @"author";

//Post

NSString * const kSTKAPIWordpressResponseKeyID = @"ID";
NSString * const kSTKAPIWordpressResponseKeyAuthor = @"author";
NSString * const kSTKAPIWordpressResponseKeyCommentStatus = @"comment_status";
NSString * const kSTKAPIWordpressResponseKeyContent = @"content";
NSString * const kSTKAPIWordpressResponseKeyDate = @"date";
NSString * const kSTKAPIWordpressResponseKeyDateGMT = @"date_gmt";
NSString * const kSTKAPIWordpressResponseKeyDateTZ = @"date_tz";
NSString * const kSTKAPIWordpressResponseKeyExcerpt = @"excerpt";
NSString * const kSTKAPIWordpressResponseKeyFeaturedImage = @"featured_image";
NSString * const kSTKAPIWordpressResponseKeyFormat = @"format";
NSString * const kSTKAPIWordpressResponseKeyGUID = @"guid";
NSString * const kSTKAPIWordpressResponseKeyLink = @"link";
NSString * const kSTKAPIWordpressResponseKeyMenuOrder = @"menu_order";
NSString * const kSTKAPIWordpressResponseKeyMeta = @"meta";
NSString * const kSTKAPIWordpressResponseKeyModified = @"modified";
NSString * const kSTKAPIWordpressResponseKeyModifiedGMT = @"modified_gmt";
NSString * const kSTKAPIWordpressResponseKeyModifiedTZ = @"modified_tz";
NSString * const kSTKAPIWordpressResponseKeyParent = @"parent";
NSString * const kSTKAPIWordpressResponseKeyPingStatus = @"ping_status";
NSString * const kSTKAPIWordpressResponseKeySlug = @"slug";
NSString * const kSTKAPIWordpressResponseKeyStatus = @"status";
NSString * const kSTKAPIWordpressResponseKeySticky = @"sticky";
NSString * const kSTKAPIWordpressResponseKeyTerms = @"terms";
NSString * const kSTKAPIWordpressResponseKeyTitle = @"title";
NSString * const kSTKAPIWordpressResponseKeyType = @"type";

NSString * const kSTKAPIWordpressResponseValueOpen = @"open";
NSString * const kSTKAPIWordpressResponseValueClosed = @"closed";

//Author

NSString * const kSTKAPIWordpressResponseKeyURL = @"URL";
NSString * const kSTKAPIWordpressResponseKeyAvatar = @"avatar";
NSString * const kSTKAPIWordpressResponseKeyDescription = @"description";
NSString * const kSTKAPIWordpressResponseKeyFirstName = @"first_name";
NSString * const kSTKAPIWordpressResponseKeyLastName = @"last_name";
NSString * const kSTKAPIWordpressResponseKeyName = @"name";
NSString * const kSTKAPIWordpressResponseKeyNickname = @"nickname";
NSString * const kSTKAPIWordpressResponseKeyRegistered = @"registered";
NSString * const kSTKAPIWordpressResponseKeyUsername = @"username";

//Attachment

NSString * const kSTKAPIWordpressResponseKeyAttachmentMeta = @"attachment_meta";
NSString * const kSTKAPIWordpressResponseKeyFile = @"file";
NSString * const kSTKAPIWordpressResponseKeyHeight = @"height";
NSString * const kSTKAPIWordpressResponseKeyImageMeta = @"image_meta";
NSString * const kSTKAPIWordpressResponseKeySizes = @"sizes";
NSString * const kSTKAPIWordpressResponseKeyWidth = @"width";
NSString * const kSTKAPIWordpressResponseKeyIsImage = @"is_image";
NSString * const kSTKAPIWordpressResponseKeySource = @"source";
NSString * const kSTKAPIWordpressResponseKeyErrors = @"errors";
NSString * const kSTKAPIWordpressResponseKeyErrorData = @"error_data";

//Image

NSString * const kSTKAPIWordpressResponseKeyMimeType = @"mime-type";
NSString * const kSTKAPIWordpressResponseKeyUrl = @"url";

//Comment

NSString * const kSTKAPIWordpressResponseKeyPost = @"post";
