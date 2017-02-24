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
        coinNum++;
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
    //这里使用组动画，统一管理
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[[self positionAnimation:coin], [self scaleAnimation1]];
    group.duration = 1.5f;
    group.delegate = self;
    //动画结束的时候移除动画，默认是YES，目前没有实际用到过，这里设为NO是为了玩耍
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    [coin.layer addAnimation:group forKey:@"grouop"];
    
}

- (CAAnimation *)positionAnimation:(UIView *)coin
{
    //屏幕宽度中间取250宽度，用于随机硬币出现的初始位置
    NSInteger randX = arc4random()%250;
    CGFloat offsetX = self.view.center.x-250/2+randX;
    //计算曲线的最高点
    CGFloat cpx = (offsetX+self.view.center.x)/2;
    CGFloat cpy = arc4random()%50-coin.center.y/3; 
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, offsetX, [UIScreen mainScreen].bounds.size.height);
    CGPathAddQuadCurveToPoint(path, NULL, cpx, cpy, coin.layer.position.x, coin.layer.position.y);
    
    //移动的帧动画
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path;
    CFRelease(path);
    path = nil;
    //使用组动画，此部分会在组动画里面设置，如果不是用组动画，需要设置下面
    //animation.duration = 10.5f;
    //animation.delegate = self;
    return animation;
}

- (CAAnimation *)scaleAnimation1
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    CGFloat fromScale = 1 + (arc4random()%10*0.1f);
    animation.fromValue = @(fromScale);
    animation.toValue = @(fromScale/2);
    return animation;
}

- (CAAnimation *)scaleAnimation2
{
    CGFloat fromScale = 1 + arc4random()%10*0.1f;
    //帧动画的缩放的好处,一堆value
    NSLog(@"fromScale %f", fromScale);
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.values = @[[self scaleValue:fromScale], [self scaleValue:fromScale*1.5], [self scaleValue:fromScale], [self scaleValue:fromScale/2], [self scaleValue:fromScale/3], [self scaleValue:fromScale/4], [self scaleValue:fromScale/5]];
    return animation;
}

- (NSValue *)scaleValue:(CGFloat)scale
{
    return [NSValue valueWithCATransform3D:CATransform3DMakeScale(scale, scale, scale)];
}

- (void)congratAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @(0);
    animation.toValue = @(M_PI);
    animation.duration = 0.2;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    //animation.autoreverses = YES;
    //animation.repeatCount = 10;
    [self.bagView.layer addAnimation:animation forKey:@"waggle"];
    
    [self performSelector:@selector(nextAnimation) withObject:self afterDelay:0.21];
    [self performSelector:@selector(YAnimation) withObject:self afterDelay:0.42];
}

- (void)nextAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    animation.fromValue = @(0);
    animation.toValue = @(M_PI);
    animation.duration = 0.2;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    //animation.autoreverses = YES;
    //animation.repeatCount = 10;
    [self.bagView.layer addAnimation:animation forKey:@"fangun"];
}

- (void)YAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    animation.fromValue = @(0);
    animation.toValue = @(M_PI);
    animation.duration = 0.2;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    //animation.autoreverses = YES;
    //animation.repeatCount = 10;
    [self.bagView.layer addAnimation:animation forKey:@"zhuanquan"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        UIView *coin = [self.view viewWithTag:[[self.coinArray firstObject] integerValue]];
        [coin removeFromSuperview];
        [self.coinArray removeObjectAtIndex:0];
        if (--coinNum == 0) {
            [self.clickButton setHidden:NO];
            [self.clickButton setTitle:@"再来一发" forState:UIControlStateNormal];
            [self congratAnimation];
        }
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
