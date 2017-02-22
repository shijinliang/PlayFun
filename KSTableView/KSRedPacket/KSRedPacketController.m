//
//  KSRedPacketController.m
//  KSTableView
//
//  Created by xiaoshi on 2017/2/22.
//  Copyright © 2017年 xiaoshi. All rights reserved.
//

#import "KSRedPacketController.h"
#import "Masonry.h"

@interface KSRedPacketController ()

@property (nonatomic, strong) UIImageView *bagView;

@property (nonatomic, strong) UIButton *clickButton;

@end

@implementation KSRedPacketController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bagView];
    [self.view addSubview:self.clickButton];
    [self.bagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
    }];
    
    [self.clickButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-20);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    }
    return _clickButton;
}

@end
