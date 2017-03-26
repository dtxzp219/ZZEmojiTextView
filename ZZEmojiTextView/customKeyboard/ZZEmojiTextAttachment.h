//
//  ZZEmojiTextAttachment.h
//  ZZEmojiTextView
//
//  Created by zhang on 2017/3/26.
//  Copyright © 2017年 zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZEmojiTextAttachment : NSTextAttachment
//定义表情的格式  例如:[em:01] [em:02] 等 
@property(strong, nonatomic) NSString *emojiTag;
//定义表情的大小
@property(assign, nonatomic) CGSize emojiSize;
@end
