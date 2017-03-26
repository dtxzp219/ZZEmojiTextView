//
//  ZZFaceKeyBoard.h
//  ZZEmojiTextView
//
//  Created by zhang on 2017/3/26.
//  Copyright © 2017年 zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FaceKeyBoardDelegate;
@protocol FaceKeyBoardDataSource;

@interface ZZFaceKeyBoard : UIView


@property (nonatomic,weak)__weak id<FaceKeyBoardDelegate> delegate;
@property (nonatomic,weak)__weak  id<FaceKeyBoardDataSource> dataSource;
@end

@protocol FaceKeyBoardDelegate <NSObject>

@optional
//点击选中的表情的 index
- (void)faceKeyBoard:(ZZFaceKeyBoard *)faceKB didTapFaceItemsAtIndex:(NSInteger)index;
@end

@protocol FaceKeyBoardDataSource <NSObject>

@required
//获取要展示的表情个数
- (NSInteger)numberOfFaceItemsInFaceKeyBoarad:(ZZFaceKeyBoard *)faceKB;

//用户获取当前表情的图片
- (UIImage *)faceKeyBoard:(ZZFaceKeyBoard *)faceKB faceImageWithIndex:(NSInteger)index;

@end
