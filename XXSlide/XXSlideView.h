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

@property (nonatomic, strong) NSTimer *timer; // 自动滚动计时器

@property (nonatomic, assign) BOOL isAutoScro; // 是否自动滚动

@property (nonatomic, copy) void (^clickCellBlock)(NSInteger item);

- (void)setImages:(NSArray *)images;

@end
