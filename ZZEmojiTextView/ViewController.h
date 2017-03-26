//
//  ViewController.h
//  ZZEmojiTextView
//
//  Created by zhang on 2017/3/26.
//  Copyright © 2017年 zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZEmojiTextView.h"
@interface ViewController : UIViewController<UITextViewDelegate>

@property(nonatomic,strong)ZZEmojiTextView *textField;
@property (nonatomic,strong) UIButton *giftBtn;  //礼物列表
@property (nonatomic,strong) UIButton *faceBtn;

//展示输入的内容
@property (nonatomic,strong) UILabel *showLabel;

@end

