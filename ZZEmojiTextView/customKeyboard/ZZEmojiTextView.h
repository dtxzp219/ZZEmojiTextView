//
//  ZZEmojiTextView.h
//  ZZEmojiTextView
//
//  Created by zhang on 2017/3/26.
//  Copyright © 2017年 zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZFaceKeyBoard.h"


typedef enum : NSUInteger {
    KeyBoardSystem,
    KeyBoardFace,
} KeyBoardType;


@interface ZZEmojiTextView : UITextView<FaceKeyBoardDelegate,FaceKeyBoardDataSource>
//键盘
@property (nonatomic,strong) ZZFaceKeyBoard * faceKB;
//表情数组
@property (nonatomic,strong) NSArray * faces;
//返回的带有表情代码的文本
@property (nonatomic,strong) NSMutableString *plainString;
//切换键盘
- (void)changeKeyBoardType:(KeyBoardType)type;
@end
