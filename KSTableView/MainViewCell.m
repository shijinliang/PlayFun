//
//  MainViewCell.m
//  KSTableView
//
//  Created by xiaoshi on 2017/2/17.
//  Copyright © 2017年 xiaoshi. All rights reserved.
//

#import "MainViewCell.h"

@implementation MainViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        self.imageView.frame = self.bounds;
    }
    return self;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

@end
