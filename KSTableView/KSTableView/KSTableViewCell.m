//
//  KSTableViewCell.m
//  KSTableView
//
//  Created by xiaoshi on 2017/2/16.
//  Copyright © 2017年 xiaoshi. All rights reserved.
//

#import "KSTableViewCell.h"

@implementation KSTableViewCell

- (instancetype)initWithRequeReuseIdentifier:(NSString *)identifier
{
    if (self = [super init]) {
        self.identifier = identifier;
    }
    return self;
}

@end
