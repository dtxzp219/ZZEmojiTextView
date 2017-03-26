//
//  ZZFaceKeyBoard.m
//  ZZEmojiTextView
//
//  Created by zhang on 2017/3/26.
//  Copyright © 2017年 zhang. All rights reserved.
//

#import "ZZFaceKeyBoard.h"

@interface ZZFaceKeyBoard()
//背景View
@property (nonatomic,strong) UIScrollView * scrollView;

@end

@implementation ZZFaceKeyBoard

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //初始化组件
        
        //初始化表情界面
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        self.scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.scrollView.pagingEnabled = YES;
        [self addSubview:self.scrollView];
        
        
        [self addObserver:self forKeyPath:@"dataSource" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //获取需要展示的表情的个数
    NSInteger count = [self.dataSource numberOfFaceItemsInFaceKeyBoarad:self];
    
    //计算所需页数3
    int pageNum=21;
    int rowNum=7;
    int pages = ceil(count/pageNum);
    self.scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
    
    for (int i = 0; i < count; i++)
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        //确定button位置
        //1.在哪一页
        int section = (int)button.tag / pageNum;
        //2.在哪一页第几个
        int index = button.tag % pageNum;
        //3.在第几行
        int row = index / rowNum;
        //4.在第几列
        int cloumn = index % rowNum;
        
        CGFloat w = self.bounds.size.width;
        CGFloat bw = 25;
        CGFloat blankWidth=(w-7*bw)/8;
        CGFloat blankheight=(self.frame.size.height-3*bw)/4;
        
        CGFloat x = blankWidth+ w * section + (bw+blankWidth) * cloumn;
        CGFloat y = (bw+blankheight) * row+blankheight;
        
        button.frame = CGRectMake(x, y, bw, bw);
        
        [button addTarget:self action:@selector(tapFaceButton:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage * image = [self.dataSource faceKeyBoard:self faceImageWithIndex:button.tag];
        
        [button setImage:image forState:UIControlStateNormal];
        
        [self.scrollView addSubview:button];
    }
}

#pragma mark 点击表情的方法
- (void)tapFaceButton:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(faceKeyBoard:didTapFaceItemsAtIndex:)])
    {
        [self.delegate faceKeyBoard:self didTapFaceItemsAtIndex:sender.tag];
    }
}



@end
