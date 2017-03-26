//
//  ZZEmojiTextAttachment.m
//  ZZEmojiTextView
//
//  Created by zhang on 2017/3/26.
//  Copyright © 2017年 zhang. All rights reserved.
//

#import "ZZEmojiTextAttachment.h"

@implementation ZZEmojiTextAttachment
//重写系统的方法 设置表情的大小
- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex {
    return CGRectMake(0, -4, _emojiSize.width, _emojiSize.height);
}
@end
