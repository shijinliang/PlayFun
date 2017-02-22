//
//  KSRedPacketController.m
//  KSTableView
//
//  Created by xiaoshi on 2017/2/22.
//  Copyright © 2017年 xiaoshi. All rights reserved.
//

#import "KSRedPacketController.h"
#import "Masonry.h"

static const NSInteger CoinTotalCount = 300;
static const NSInteger redPacketTopWidth = 20;

static const CGFloat bagOffsetX = 10;

@interface KSRedPacketController ()<CAAnimationDelegate>

@property (nonatomic, strong) UIImageView *bagView;

@property (nonatomic, strong) UIButton *clickButton;

@property (nonatomic, strong) NSMutableArray *coinArray;

@end

@implementation KSRedPacketController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bagView];
    [self.view addSubview:self.clickButton];
    [self.bagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(bagOffsetX);
        make.centerY.mas_equalTo(self.view.mas_centerY).mas_offset(-50);
    }];
    
    [self.clickButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-20);
    }];
    
}

static NSInteger coinNum = 0;

- (void)redPacketStart
{
    coinNum = 0;
    [self.clickButton setHidden:YES];
    for (int i=0; i<CoinTotalCount; i++) {
        [self performSelector:@selector(initCoinWith:) withObject:@(i) afterDelay:i*0.01];
    }
}

- (void)initCoinWith:(NSNumber *)coinTag
{
    NSInteger tag = [coinTag integerValue];
    UIImageView *coin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_coin_%d", (tag%2)+1]]];
    coin.tag = 100+tag;
    //红包口宽度 随机0-20之间的数
    NSInteger rand = arc4random()%redPacketTopWidth;
    CGFloat x = self.view.center.x - redPacketTopWidth/2 + rand;
    coin.center = CGPointMake(x, self.view.center.y-50);
    [self.view addSubview:coin];
    [self.coinArray addObject:@(coin.tag)];
    [self addAnimationWithCoin:coin];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addAnimationWithCoin:(UIView *)coin
{
    //屏幕宽度中间取250宽度，用于随机硬币出现的初始位置
    NSInteger randX = arc4random()%250;
    CGFloat offsetX = self.view.center.x-250/2+randX;
    //计算曲线的最高点
    CGFloat cpx = (offsetX+self.view.center.x)/2;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, offsetX, [UIScreen mainScreen].bounds.size.height);
    
    CGPathAddQuadCurveToPoint(path, NULL, cpx, -50, coin.frame.origin.x, coin.frame.origin.y);
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.duration = 1.5f;
    animation.path = path;
    animation.delegate = self;
    [coin.layer addAnimation:animation forKey:@"position"];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        UIView *coin = [self.view viewWithTag:[[self.coinArray firstObject] integerValue]];
        [coin removeFromSuperview];
        [self.coinArray removeObjectAtIndex:0];
    }
}

- (UIImageView *)bagView
{
    if (!_bagView) {
        _bagView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_hongbao_bags"]];
    }
    return _bagView;
}

- (UIButton *)clickButton
{
    if (!_clickButton) {
        _clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _clickButton.backgroundColor = [UIColor redColor];
        [_clickButton setTitle:@"发红包喽" forState:UIControlStateNormal];
        [_clickButton addTarget:self action:@selector(redPacketStart) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clickButton;
}

- (NSMutableArray *)coinArray
{
    if (!_coinArray) {
        _coinArray = [NSMutableArray array];
    }
    return _coinArray;
}

@end
