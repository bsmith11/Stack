//
//  NSString+STKHTML.h
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//
//  GTMNSString+HTML.h
//  Dealing with NSStrings that contain HTML
//
//  Copyright 2006-2008 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not
//  use this file except in compliance with the License.  You may obtain a copy
//  of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
//  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
//  License for the specific language governing permissions and limitations under
//  the License.
//

@import Foundation;

@interface NSString (STKHTML)

- (BOOL)stk_isVideoURL;
- (BOOL)stk_isYoutubeURL;
- (BOOL)stk_isVimeoURL;
- (BOOL)stk_isGfycatURL;

- (NSString *)stk_youtubeVideoID;

@end
