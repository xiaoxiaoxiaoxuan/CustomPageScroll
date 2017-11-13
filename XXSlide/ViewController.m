//
//  ViewController.m
//  XXSlide
//
//  Created by 王笑璇 on 2017/11/10.
//  Copyright © 2017年 wangxiaoxuan. All rights reserved.
//

#import "ViewController.h"
#import "XXSlideView.h"

@interface ViewController ()

@property (nonatomic, strong) XXSlideView *slideView;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    XXSlideView *slideView = [[XXSlideView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 140)];
    slideView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:slideView];
    self.slideView = slideView;
    // 是否轮播
    self.slideView.isSlide = YES;
    // 是否自动轮播
    self.slideView.isAutoScro = YES;
    self.dataArray = @[@"1.png", @"2.png", @"3.png", @"3.png", @"3.png"];
    [self.slideView setImages:self.dataArray];
    slideView.clickCellBlock = ^(NSInteger item) {
        NSLog(@"点击 ========= %ld", item);
    };
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
