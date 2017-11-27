//
//  XXSlideView.m
//  XXSlide
//
//  Created by 王笑璇 on 2017/11/10.
//  Copyright © 2017年 wangxiaoxuan. All rights reserved.
//

#import "XXSlideView.h"

@interface XXSlideView()<UIScrollViewDelegate>

@property (nonatomic, assign) CGFloat paddingLeftRight; // 左右间距
@property (nonatomic, assign) CGFloat paddingTopBottom; // 上下间距
@property (nonatomic, assign) CGFloat cellWidth; // 每一页的宽度
@property (nonatomic, strong) NSMutableArray *imagesArr;

@property (nonatomic, strong) NSTimer *timer; // 自动滚动计时器

@end

const static NSInteger tagView = 1000000;
@implementation XXSlideView

+ (instancetype)slideViewWithFrame:(CGRect)frame padding_left_right:(CGFloat)lr padding_top_bottom:(CGFloat)tb cellWidth:(CGFloat)width {
    XXSlideView *slideView = [[self alloc] initWithFrame:frame];
    slideView.paddingLeftRight = lr;
    slideView.paddingTopBottom = tb;
    slideView.cellWidth = width;
    [slideView setupViewWithFrame:frame];
    return slideView;
}

- (void)setupViewWithFrame:(CGRect)frame {
    CGFloat lWidth = (frame.size.width - self.cellWidth) / 2.0; // 左右宽度
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(lWidth, 0, self.cellWidth, frame.size.height)];
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    self.scrollView.bounces = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.layer.masksToBounds = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
}

- (void)setImages:(NSArray *)images {
    if (images == nil || images.count == 0) {
        return ;
    }
    self.imagesArr = [NSMutableArray array];
    if (images.count == 1) {
        self.imagesArr = @[images[0],images[0],images[0],images[0],images[0]].mutableCopy;
    } else {
        [self.imagesArr addObject:images[images.count - 2]];
        [self.imagesArr addObject:images[images.count - 1]];
        [self.imagesArr addObjectsFromArray:images];
        [self.imagesArr addObject:images[0]];
        [self.imagesArr addObject:images[1]];
    }
    // 是否轮播
    if (self.isSlide == NO) {
        self.imagesArr = images.mutableCopy;
        CGFloat lWidth = (self.frame.size.width - self.cellWidth) / 2.0; // 左右宽度
        self.scrollView.contentOffset = CGPointMake(lWidth + 10, 0);
        self.scrollView.contentInset = UIEdgeInsetsMake(0, -lWidth, 0, -lWidth);
    } else {
        self.scrollView.delegate = self;
    }
    self.scrollView.contentSize = CGSizeMake(self.cellWidth * self.imagesArr.count, self.frame.size.height);
    for (int i = 0; i < self.imagesArr.count; i++) {
        CGFloat viewWidth = self.cellWidth - 10;
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(self.cellWidth * i + self.paddingLeftRight / 2.0, self.paddingTopBottom, viewWidth, self.scrollView.frame.size.height - self.paddingTopBottom * 2)];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.clipsToBounds = YES;
        view.backgroundColor = [UIColor grayColor];
        view.image = [UIImage imageNamed:self.imagesArr[i]];
        [self.scrollView addSubview:view];
        view.tag = tagView + i;
        
        view.userInteractionEnabled = YES;
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapAction:)]];
    }
    if (self.isAutoScro) {
        [self.timer invalidate];
        self.timer = nil;
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.timeBetween target:self selector:@selector(autoSlide) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        self.timer = timer;
    }
    
    if (self.isSlide) {
        self.scrollView.contentOffset = CGPointMake(self.cellWidth * 2, 0);
    }
}

- (void)autoSlide {
    [UIView animateWithDuration:0.5 animations:^{
        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x + self.cellWidth, 0);
    } completion:^(BOOL finished) {
        if (self.scrollView.contentOffset.x == self.cellWidth * (self.imagesArr.count - 2)) {
            self.scrollView.contentOffset = CGPointMake(self.cellWidth * 2, 0);
        }
    }];
}

- (void)viewTapAction:(UITapGestureRecognizer *)tap {
    if (_clickCellBlock) {
        NSInteger clickItem = [[tap valueForKey:@"view"] tag] - tagView - 1;
        if (clickItem == self.imagesArr.count - 4 + 1) {
            _clickCellBlock(1);
        } else if (clickItem == 0) {
            _clickCellBlock(self.imagesArr.count - 4);
        } else {
            _clickCellBlock(clickItem);
        }
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if ([self.layer containsPoint:point]) {
        NSInteger lWidth = (self.frame.size.width - self.cellWidth) / 2.0; // 左右宽度
        NSInteger x = (point.x + self.scrollView.contentOffset.x - lWidth)/ self.cellWidth;
        UIView *view = [self.scrollView viewWithTag:x + tagView];
        return view;
    }
    return [super hitTest:point withEvent:event];
}

#pragma mark --- scrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger dataCount = self.imagesArr.count;
    if (scrollView.contentOffset.x == 240 * (dataCount - 2)) {
        scrollView.contentOffset = CGPointMake(240 * 2, 0);
    }
    if (scrollView.contentOffset.x == 240) {
        scrollView.contentOffset = CGPointMake(240 * (dataCount - 3), 0);
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger dataCount = self.imagesArr.count;
    CGFloat scrWidth = scrollView.bounds.size.width;
    if (scrollView.contentOffset.x > scrWidth * (dataCount - 2)) {
        CGFloat overflowX = scrWidth * (dataCount - 2) - scrollView.contentOffset.x;
        scrollView.contentOffset = CGPointMake(scrWidth * 2 + overflowX, 0);
    }
    if (scrollView.contentOffset.x < scrWidth) {
        CGFloat overflowX = (scrWidth - scrollView.contentOffset.x);
        scrollView.contentOffset = CGPointMake(scrWidth * (dataCount - 3) - overflowX, 0);
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer setFireDate:[NSDate distantFuture]];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:3]];
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
