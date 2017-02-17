//
//  KSTableViewCell.h
//  KSTableView
//
//  Created by xiaoshi on 2017/2/16.
//  Copyright © 2017年 xiaoshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSTableViewCell : UIView

@property (nonatomic, copy) NSString *identifier;

- (instancetype)initWithRequeReuseIdentifier:(NSString *)identifier;

@end
