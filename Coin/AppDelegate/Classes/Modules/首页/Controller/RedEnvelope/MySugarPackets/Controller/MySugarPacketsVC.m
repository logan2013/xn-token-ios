//
//  MySugarPacketsVC.m
//  Coin
//
//  Created by QinBao Zheng on 2018/7/2.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "MySugarPacketsVC.h"
#import "GetTheVC.h"
#import "SendVC.h"
@interface MySugarPacketsVC ()<UIScrollViewDelegate>
{
    UISegmentedControl *segment;
}
@property (nonatomic, strong)UIScrollView *scroll;
@property (nonatomic, strong)UIButton *selectBtn;

@property (nonatomic, assign)NSInteger currentPages;

//@property (nonatomic, strong)UILabel *WeiGreLabel;
@property (nonatomic, strong)GetTheVC *vc1;
@property (nonatomic, strong)SendVC *vc2;
@property (nonatomic , strong)UIButton *backbButton;
#define kPageCount 2
#define kButton_H 70
#define kMrg 10
#define kTag 1000

@end

@implementation MySugarPacketsVC

-(UIButton *)backbButton
{
    if (!_backbButton) {
        _backbButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _backbButton.frame = CGRectMake(0, 0, 44, 44);
        [_backbButton setImage:kImage(@"返回1") forState:(UIControlStateNormal)];
        [_backbButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];

        [_backbButton addTarget:self action:@selector(buttonMethodClick) forControlEvents:(UIControlEventTouchUpInside)];

    }
    return _backbButton;
}

-(void)buttonMethodClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.text = [LangSwitcher switchLang:@"我的红包" key:nil];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18];
    self.navigationItem.titleView = label;

    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    backView.backgroundColor = HeadBackColor;
    [self.view addSubview:backView];

    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];

    //    negativeSpacer.width = -10;
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:self.backbButton]];self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]};
    self.navigationController.navigationBar.titleTextAttributes=
  @{NSForegroundColorAttributeName:[UIColor whiteColor],
    NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:18]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = HeadBackColor;
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置可以左右滑动的ScrollView
    [self setupScrollView];
    //设置控制的每一个子控制器
    [self setupChildViewControll];
    //设置分页按钮
    [self setupPageButton];

//    [self setupSelectBtn];
    [_scroll setContentOffset:CGPointMake(SCREEN_WIDTH * _currentPages, 0) animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setShadowImage:nil];
}

#pragma mark - 设置可以左右滑动的ScrollView
- (void)setupScrollView{

    self.scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kButton_H , SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scroll.pagingEnabled = YES;
    _scroll.delegate = self;
    _scroll.showsVerticalScrollIndicator = NO;
    _scroll.directionalLockEnabled = YES;

    _scroll.contentSize = CGSizeMake(SCREEN_WIDTH * kPageCount, SCREEN_HEIGHT);
    [self.view addSubview:_scroll];
}

#pragma mark - 设置控制的每一个子控制器
- (void)setupChildViewControll{
    self.vc1 = [[GetTheVC alloc]init];
    self.vc2 = [[SendVC alloc]init];

    //指定该控制器为其子控制器
    [self addChildViewController:_vc1];
    [self addChildViewController:_vc2];


    //将视图加入ScrollView上
    [_scroll addSubview:_vc1.view];
    [_scroll addSubview:_vc2.view];

    //设置两个控制器的尺寸
    _vc1.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _vc2.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);

}
#pragma mark - 设置分页按钮
- (void)setupPageButton{
    //button的index值应当从0开始

    NSArray *array = [NSArray arrayWithObjects:[LangSwitcher switchLang:@"我收到的" key:nil],[LangSwitcher switchLang:@"我发出的" key:nil], nil];
    //初始化UISegmentedControl
    segment = [[UISegmentedControl alloc]initWithItems:array];
    //设置frame
    CGFloat x = SCREEN_WIDTH/2 - 100;
    CGFloat y = 15;
    CGFloat w = 200;
    CGFloat h = 40;

    segment.backgroundColor = HeadBackColor;
    [segment setTintColor:HeadBackColor];
    segment.frame = CGRectMake(x, y, w, h);
    kViewBorderRadius(segment, 5, 2, [UIColor whiteColor]);
    segment.selectedSegmentIndex = 0;
    segment.tintColor = [UIColor whiteColor];
    //添加到视图
    [self.view addSubview:segment];
    [segment addTarget:self action:@selector(pageClick:) forControlEvents:UIControlEventValueChanged];

}


#pragma mark -- 按钮点击方法
- (void)pageClick:(UISegmentedControl *)sender
{
    CGRect frame;
    frame.origin.x = self.scroll.frame.size.width * sender.selectedSegmentIndex;
    frame.origin.y = 0;
    frame.size = _scroll.frame.size;
    [_scroll scrollRectToVisible:frame animated:YES];
}

#pragma mark - ScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = _scroll.frame.size.width;
    self.currentPages = floor((_scroll.contentOffset.x - pageWidth/2)/pageWidth) + 1;
    //设置选中button的样式
    segment.selectedSegmentIndex = self.currentPages;
}


@end
