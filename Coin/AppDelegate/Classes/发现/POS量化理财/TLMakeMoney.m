//
//  TLMakeMoney.m
//  Coin
//
//  Created by shaojianfei on 2018/8/10.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLMakeMoney.h"
#import "CoinHeader.h"
#import "AppColorMacro.h"
#import "BillCell.h"
#import "questionListCells.h"
#import "MakeMoneyCell.h"
#import "MoneyAndTreasureHeadView.h"
@interface TLMakeMoney()<UITableViewDelegate, UITableViewDataSource>


@end
@implementation TLMakeMoney
static NSString *identifierCell = @"MakeMoneyCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
//        [self setContentInset:UIEdgeInsetsMake(5, 0.0, -5, 0.0)];
        self.backgroundColor = kBackgroundColor;
        
        [self registerClass:[MakeMoneyCell class] forCellReuseIdentifier:identifierCell];
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;

        MoneyAndTreasureHeadView *headView = [[MoneyAndTreasureHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160 - 64 + kNavigationBarHeight)];
        self.tableHeaderView = headView;
    }
    
    return self;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.Moneys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MakeMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    cell.model = self.Moneys[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 155;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableView:didSelectRowAtIndexPath:)]) {
        [self.refreshDelegate refreshTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *view = [UIView new];
    
    return view;
}

- (void)clickFilter:(UIButton *)sender {
    
    if (self.addBlock) {
        self.addBlock();
    }
    NSLog(@"ready");
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
