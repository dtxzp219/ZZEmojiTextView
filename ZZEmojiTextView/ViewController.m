//
//  ViewController.m
//  ZZEmojiTextView
//
//  Created by zhang on 2017/3/26.
//  Copyright © 2017年 zhang. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Frame.h"
@interface ViewController ()

@end

@implementation ViewController
{
    UIView *inputView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registerForKeyboardNotifications];
    
    self.showLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 30, self.view.width-20, 150)];
    self.showLabel.backgroundColor=[UIColor yellowColor];
    self.showLabel.numberOfLines=0;
    [self.view addSubview:self.showLabel];
    
    
    inputView=[[UIView alloc]initWithFrame:CGRectMake(10, self.view.height-50, self.view.width-20, 40)];
    inputView.layer.cornerRadius=5;
    inputView.backgroundColor=[UIColor whiteColor];
    inputView.layer.borderColor=[UIColor grayColor].CGColor;
    inputView.layer.borderWidth=1;
    
    [self.view addSubview:inputView];
    
    UIButton *sendBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame=CGRectMake(inputView.width-60,0, 60, inputView.height);
    sendBtn.backgroundColor=[UIColor colorWithRed:0.74 green:0.12 blue:0.15 alpha:1];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.contentMode=UIViewContentModeLeft;
    [inputView addSubview:sendBtn];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:sendBtn.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = sendBtn.bounds;
    maskLayer.path = maskPath.CGPath;
    sendBtn.layer.mask = maskLayer;
    
    
    _faceBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _faceBtn.frame=CGRectMake(5, 0, inputView.height, inputView.height);
    [_faceBtn setImage:[UIImage imageNamed:@"smileFaceGray"] forState:UIControlStateNormal];
    [_faceBtn setImage:[UIImage imageNamed:@"smileFaceRed"] forState:UIControlStateSelected];
    
    [_faceBtn addTarget:self action:@selector(faceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:_faceBtn];
    
    
    
    
    self.textField=[[ZZEmojiTextView alloc]initWithFrame:CGRectMake(_faceBtn.right, 0, inputView.width-_faceBtn.width-80, inputView.height)];
    self.textField.delegate=self;
        self.textField.textAlignment=NSTextAlignmentLeft;;
    self.textField.text=@"说点什么";
    self.textField.showsVerticalScrollIndicator=NO;
    self.textField.textColor=[UIColor colorWithRed:0.61 green:0.61 blue:0.61 alpha:1];
    [inputView addSubview:self.textField];

    // Do any additional setup after loading the view, typically from a nib.
}

-(void)sendBtnClick
{
  
    NSLog(@"%@",self.textField.plainString);
    [self changeMessage:self.textField.plainString];
//    self.showLabel.text=self.textField.plainString;
    
}
- (void)keyboardWillShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSLog(@"keyboardWillShown:%@",info);
    
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect beginRect=value.CGRectValue;
    
    NSValue *endValue1 = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect endRect=endValue1.CGRectValue;
    int height=endRect.size.height-beginRect.size.height;
        [UIView animateWithDuration:0.2 animations:^{
            inputView.frame=CGRectMake(0, (self.view.height-inputView.height)-beginRect.size.height-height, inputView.width, inputView.height);
        }];
    
}
- (void)keyboardWillHidden:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSLog(@"keyboardWillHidden:%@",info);
    
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyboardWasHidden keyBoard:%f", keyboardSize.height);
    
        [UIView animateWithDuration:0.2 animations:^{
            inputView.frame=CGRectMake(0, (self.view.height-inputView.height), inputView.width, inputView.height);
            
        }];
    
    
}
- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textField resignFirstResponder];
}
-(void)faceBtnClick:(UIButton *)btn
{
    [self.textField resignFirstResponder];
    btn.selected=!btn.selected;
    [self.textField changeKeyBoardType:btn.isSelected?KeyBoardFace:KeyBoardSystem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)changeMessage:(NSString *)str
{

    NSString * path = [[NSBundle mainBundle]pathForResource:@"expression" ofType:@"plist"];
    NSDictionary *emojiDict =[[NSDictionary alloc]initWithContentsOfFile:path];

    float height=  _showLabel.font.lineHeight;
  NSMutableAttributedString * mainAttr =[[NSMutableAttributedString alloc]initWithString:str];
    
    //通过正则表达式 判断是否 含有特定字符
    NSRegularExpression *regex=[NSRegularExpression regularExpressionWithPattern:@"\\[em:[0-9]*\\]"options:NSRegularExpressionAnchorsMatchLines error:nil];
    __block NSUInteger location=0;
    
    
    NSArray *matches=[regex matchesInString:str options:NSMatchingWithoutAnchoringBounds range:NSMakeRange(0, str.length)];
    
    if (matches.count>0) {
        NSRange range={0,str.length};
        [regex enumerateMatchesInString:str options:NSMatchingWithTransparentBounds range:range usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            //将特定字符 替换为 图片
            NSRange matchRange=[result range];
            NSString *subStr=[str substringWithRange:matchRange];
            
            NSTextAttachment *attachemnt=[[NSTextAttachment alloc]init];
            attachemnt.bounds=CGRectMake(0, -4, height, height);
            attachemnt.image=[UIImage imageNamed:emojiDict[subStr]];
            NSAttributedString *imageString=[NSAttributedString attributedStringWithAttachment:attachemnt];
            
            NSRange newRange={matchRange.location-location,matchRange.length};
            [mainAttr replaceCharactersInRange:newRange withAttributedString:imageString];
            location=location+matchRange.length-1;
            self.showLabel.attributedText=mainAttr;
            
        }];
        
    }
    else
    {
        self.showLabel.text=str;
    }
    
    
}


@end
