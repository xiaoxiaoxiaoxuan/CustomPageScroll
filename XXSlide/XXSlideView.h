//
//  XXSlideView.h
//  XXSlide
//
//  Created by 王笑璇 on 2017/11/10.
//  Copyright © 2017年 wangxiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXSlideView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) BOOL isSlide; // 是否轮播

@property (nonatomic, assign) BOOL isAutoScro; // 是否自动滚动

@property (nonatomic, assign) CGFloat timeBetween; // 自动轮播间隔时间

@property (nonatomic, copy) void (^clickCellBlock)(NSInteger item);


/**
 创建slideView
 @param frame 可视区域的frame
 @param lr 左右间距
 @param tb 上下间距
 @param width 每一模块的宽度
 @return slideView
 */
+ (instancetype)slideViewWithFrame:(CGRect)frame padding_left_right:(CGFloat)lr padding_top_bottom:(CGFloat)tb cellWidth:(CGFloat)width;

- (void)setImages:(NSArray *)images;

@end
