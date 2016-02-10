//
//  NSParagraphStyle+STKHTML.h
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import UIKit;

@interface NSParagraphStyle (STKHTML)


+ (instancetype)stk_paragraphStyleFromCTParagraphStyle:(CTParagraphStyleRef)paragraphStyleRef;

@end
