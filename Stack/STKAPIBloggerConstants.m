//
//  STKAPIBloggerConstants.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKAPIBloggerConstants.h"

NSString * const kSTKAPIBloggerRoutePrefix = @"/blogger/v3/blogs";
NSString * const kSTKAPIBloggerRoutePosts = @"/posts";
NSString * const kSTKAPIBloggerRoutePostComments = @"/posts/%@/comments";

NSString * const kSTKAPIBloggerRequestKeyMaxResults = @"maxResults";
NSString * const kSTKAPIBloggerRequestKeyFetchImages = @"fetchImages";
NSString * const kSTKAPIBloggerRequestKeyStatus = @"status";
NSString * const kSTKAPIBloggerRequestKeyEndDate = @"endDate";
NSString * const kSTKAPIBloggerRequestKeyAPIKey = @"key";

NSString * const KSTKAPIBloggerRequestValueStatus = @"live";

//Post

NSString * const kSTKAPIBloggerRequestKeyBlogID = @"blogId";

NSString * const kSTKAPIBloggerResponseKeyItems = @"items";
NSString * const kSTKAPIBloggerResponseKeyID = @"id";
NSString * const kSTKAPIBloggerResponseKeyTitle = @"title";
NSString * const kSTKAPIBloggerResponseKeyURL = @"url";
NSString * const kSTKAPIBloggerResponseKeyPublished = @"published";
NSString * const kSTKAPIBloggerResponseKeyContent = @"content";
NSString * const kSTKAPIBloggerResponseKeyUpdated = @"updated";
NSString * const kSTKAPIBloggerResponseKeySelfLink = @"selfLink";
NSString * const kSTKAPIBloggerResponseKeyLabels = @"labels";
NSString * const kSTKAPIBloggerResponseKeyReplies = @"replies";
NSString * const kSTKAPIBloggerResponseKeyBlog = @"blog";
NSString * const kSTKAPIBloggerResponseKeyImages = @"images";
NSString * const kSTKAPIBloggerResponseKeyKind = @"kind";
NSString * const kSTKAPIBloggerResponseKeyETag = @"etag";

//Author

NSString * const kSTKAPIBloggerResponseKeyAuthor = @"author";
NSString * const kSTKAPIBloggerResponseKeyDisplayName = @"authorName";
NSString * const kSTKAPIBloggerResponseKeyImage = @"image";

//Comment

NSString * const kSTKAPIBloggerRequestKeyPostID = @"postId";
NSString * const kSTKAPIBloggerRequestKeyFetchBodies = @"fetchBodies";

NSString * const kSTKAPIBloggerResponseKeyPost = @"post";
