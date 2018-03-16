//
//  HomeHeaderView.m
//  OGC
//
//  Created by 蔡卓越 on 2018/3/13.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import "HomeHeaderView.h"

//Macro
#import "TLUIHeader.h"
#import "AppColorMacro.h"
#import "UIColor+theme.h"
//Category
#import "UIButton+EnLargeEdge.h"
#import "NSString+Extension.h"
#import "CoinUtil.h"
//V
#import "TLBannerView.h"

@interface HomeHeaderView()

//轮播图
@property (nonatomic,strong) TLBannerView *bannerView;
//统计
@property (nonatomic, strong) UIView *statisticsView;
//数据
@property (nonatomic, strong) UILabel *dataLbl;

@end

@implementation HomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        //轮播图
        [self initBannerView];
        //统计
        [self initStatisticsView];
    }
    return self;
}

#pragma mark - Init
- (void)initBannerView {
    
    CoinWeakSelf;
    
    //顶部轮播
    TLBannerView *bannerView = [[TLBannerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kWidth(185))];
    
    bannerView.selected = ^(NSInteger index) {
        
        if (weakSelf.headerBlock) {
            
            weakSelf.headerBlock(HomeEventsTypeBanner, index);
        }
    };
    
    [self addSubview:bannerView];
    
    self.bannerView = bannerView;
}

- (void)initStatisticsView {
    
    CGFloat h = 120;
    
    self.statisticsView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bannerView.yy, kScreenWidth, h)];
    
    self.statisticsView.backgroundColor = kWhiteColor;
    
    [self addSubview:self.statisticsView];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookFlowList:)];
    
    [self.statisticsView addGestureRecognizer:tapGR];
    
    UIImageView *iconIV = [[UIImageView alloc] initWithImage:kImage(@"分发统计")];
    
    [self.statisticsView addSubview:iconIV];
    [iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.top.equalTo(@15);
    }];
    //右箭头
    CGFloat arrowW = 6;
    CGFloat arrowH = 10;
    CGFloat rightMargin = 10;
    
    UIImageView *arrowIV = [[UIImageView alloc] initWithImage:kImage(@"更多-灰色")];
    
    [self.statisticsView addSubview:arrowIV];
    [arrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(arrowW));
        make.height.equalTo(@(arrowH));
        make.centerY.equalTo(iconIV.mas_centerY);
        make.right.equalTo(@(-rightMargin));
    }];
    
    //空投统计
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor
                                                    font:15.0];
    textLbl.text = [LangSwitcher switchLang:@"空投统计" key:nil];
    
    [self.statisticsView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(iconIV.mas_right).offset(10);
        make.centerY.equalTo(iconIV.mas_centerY);
    }];
    //比例
    CGFloat scaleH = 7;
    
    UIView *scaleBgView = [[UIView alloc] init];
    
    scaleBgView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    scaleBgView.tag = 1301;
    scaleBgView.layer.cornerRadius = scaleH/2.0;
    scaleBgView.clipsToBounds = YES;
    
    [self.statisticsView addSubview:scaleBgView];
    [scaleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(textLbl.mas_bottom).offset(20);
        make.left.equalTo(iconIV.mas_left);
        make.right.equalTo(arrowIV.mas_right);
        make.height.equalTo(@(scaleH));
    }];
    
    UIView *scaleView = [[UIView alloc] init];
    
    scaleView.tag = 1300;
    scaleView.backgroundColor = kAppCustomMainColor;
    scaleView.layer.cornerRadius = scaleH/2.0;
    scaleView.clipsToBounds = YES;
    
    [scaleBgView addSubview:scaleView];
    //数据
    self.dataLbl = [UILabel labelWithBackgroundColor:kClearColor
                                           textColor:[UIColor colorWithHexString:@"#7a7a7a"]
                                                font:13.0];
    
    self.dataLbl.numberOfLines = 0;
    
    [self.statisticsView addSubview:self.dataLbl];
    [self.dataLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(iconIV.mas_left);
        make.top.equalTo(scaleBgView.mas_bottom).offset(15);
    }];
    
    //bottomLine
    UIView *bottomLine = [[UIView alloc] init];
    
    bottomLine.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
    
    [self.statisticsView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@10);
    }];
    
}

#pragma mark - Events
- (void)lookFlowList:(UITapGestureRecognizer *)tapGR {
    
    if (_headerBlock) {
        
        _headerBlock(HomeEventsTypeStatistics, 0);
    }
}

#pragma mark - Setting
- (void)setBanners:(NSMutableArray<BannerModel *> *)banners {
    
    _banners = banners;
    
    NSMutableArray *imgUrls = [NSMutableArray array];
    
    [banners enumerateObjectsUsingBlock:^(BannerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.pic) {
            
            [imgUrls addObject:obj.pic];
        }
    }];
    self.bannerView.imgUrls = imgUrls;
    
}

- (void)setCountInfo:(CountInfoModel *)countInfo {
    
    _countInfo = countInfo;
    
    UIView *scaleBgView = [self viewWithTag:1301];

    NSString *initialBalance = [CoinUtil convertToRealCoin:countInfo.initialBalance coin:kOGC];
    
    NSString *useBalance = [CoinUtil convertToRealCoin:countInfo.useBalance coin:kOGC];

    CGFloat scaleH = 7;
    CGFloat lineW = [useBalance doubleValue]/[initialBalance doubleValue]*scaleBgView.width;
    
    UIView *scaleView = [self viewWithTag:1300];
    
    scaleView.frame = CGRectMake(0, 0, lineW, scaleH);

    NSString *rate = [CoinUtil mult1:countInfo.useRate mult2:@"100" scale:20];
//    CGFloat rate = [countInfo.useRate doubleValue]*100;
    
    NSString *data = [NSString stringWithFormat:@"总量: %@   已投: %@   占比: %@%%", initialBalance, useBalance, rate];
    
    self.dataLbl.text = [LangSwitcher switchLang:data key:nil];;

}

@end
