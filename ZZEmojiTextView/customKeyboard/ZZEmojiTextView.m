//
//  ZZEmojiTextView.m
//  ZZEmojiTextView
//
//  Created by zhang on 2017/3/26.
//  Copyright © 2017年 zhang. All rights reserved.
//

#import "ZZEmojiTextView.h"
#import "ZZEmojiTextAttachment.h"

@implementation ZZEmojiTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //初始化CoreDataManager
        self.font = [UIFont systemFontOfSize:18];
        //获取所有表情
        NSString * path = [[NSBundle mainBundle]pathForResource:@"Emoji" ofType:@"plist"];
        self.faces = [NSArray arrayWithContentsOfFile:path];
        
        
        self.faceKB = [[ZZFaceKeyBoard alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 170)];
        
        self.faceKB.backgroundColor = [UIColor greenColor];
        self.faceKB.delegate = self;
        self.faceKB.dataSource = self;
        
        //        self.inputView = self.faceKB;
        
        
        
    }
    return self;
}
#pragma mark FaceKeyBoardDelegate
- (void)faceKeyBoard:(ZZFaceKeyBoard *)faceKB didTapFaceItemsAtIndex:(NSInteger)index
{
    
    //通过点击按钮的索引index到数组faces中找到对应的dic
    NSString * name = self.faces[index];
    
    if ([name isEqualToString:@"faceDelete"]) {
        //系统的删除方法 删除一个长度
        [self deleteBackward];
    }
    else
    {
        //显示表情图片
        self.font=[UIFont systemFontOfSize:17];
        
        int cha= (int)index /20;
        float height=  self.font.lineHeight;
        
        UIImage * image = [UIImage imageNamed:name];
        ZZEmojiTextAttachment * attachment = [[ZZEmojiTextAttachment alloc]init];
        attachment.image = image;
        attachment.emojiSize=CGSizeMake(height, height);
        if (index == 40) {
            attachment.emojiTag=[NSString stringWithFormat:@"[em:%ld]",(long)index-1];
            
        }
        else
        {
            attachment.emojiTag=[NSString stringWithFormat:@"[em:%ld]",(long)index-cha];
        }
        NSAttributedString * attributedStr = [NSAttributedString attributedStringWithAttachment:attachment];
        
        //在光标位置插入emoji
        [self.textStorage insertAttributedString:attributedStr
                                         atIndex:self.selectedRange.location];
        
        //移动光标位置
        self.selectedRange = NSMakeRange(self.selectedRange.location + 1, self.selectedRange.length);
        
        [self resetTextStyle];
    }
    
    
}

#pragma makr FaceKeyBoardDataSource
- (NSInteger)numberOfFaceItemsInFaceKeyBoarad:(ZZFaceKeyBoard *)faceKB
{
    return self.faces.count;
}

- (UIImage *)faceKeyBoard:(ZZFaceKeyBoard *)fk faceImageWithIndex:(NSInteger)index
{
    NSString * name = self.faces[index];
    UIImage * image = [UIImage imageNamed:name];
    return image;
}

#pragma mark changeKeyBoard

- (void)changeKeyBoardType:(KeyBoardType)type
{
    switch (type)
    {
        case KeyBoardSystem:
        {
            self.inputView = nil;
            [self resignFirstResponder];
            [self becomeFirstResponder];
            
            break;
        }
        case KeyBoardFace:
        {
            [self resignFirstResponder];
            
            self.inputView = self.faceKB;
            [self becomeFirstResponder];
            
            break;
        }
        default:
            break;
    }
    
}

-(NSMutableString *)plainString
{
    
    _plainString = [NSMutableString stringWithString:self.textStorage.string];
    __block NSUInteger base = 0;
    
    [self.textStorage enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.textStorage.length)
                                 options:0
                              usingBlock:^(id value, NSRange range, BOOL *stop) {
                                  if (value && [value isKindOfClass:[ZZEmojiTextAttachment class]]) {
                                      [_plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length)
                                                                  withString:((ZZEmojiTextAttachment *) value).emojiTag];
                                      base += ((ZZEmojiTextAttachment *) value).emojiTag.length - 1;
                                  }
                              }];
    
    
    
    return _plainString;
}

- (void)resetTextStyle {
    //在输入完表情后需要重新设置文本的格式
    NSRange wholeRange = NSMakeRange(0, self.textStorage.length);
    
    [self.textStorage removeAttribute:NSFontAttributeName range:wholeRange];
    
    [self.textStorage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:wholeRange];
}
@end
