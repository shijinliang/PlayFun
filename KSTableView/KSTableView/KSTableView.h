//
//  KSTableView.h
//  KSTableView
//
//  Created by xiaoshi on 2017/2/16.
//  Copyright © 2017年 xiaoshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSTableViewCell.h"

@class KSTableView;

@protocol KSTableViewDelegate <NSObject>

@required //必须实现

@optional
- (void)tableView:(KSTableView *)tableView didSelectAtIndex:(NSInteger)index;

- (CGFloat)tableView:(KSTableView *)tableView heightAtIndex:(NSInteger)index;

//- (CGFloat)tableView:(KSTableView *)tableView spaceForType:()
@end

@protocol KSTableViewDataSource <NSObject>

@required
- (NSInteger)numberOfCellInTableView:(KSTableView *)tableView;

- (NSInteger)tableView:(KSTableView *)tableView numberOfColumnInCell:(NSInteger)cell;

- (KSTableViewCell *)tableView:(KSTableView *)tableView cellAtIndex:(NSInteger)index;
@optional

@end

@interface ksd : UITableView

@end

@interface KSTableView : UIScrollView

@property (nonatomic, weak) id<KSTableViewDelegate> tableDelegate;
@property (nonatomic, strong) id<KSTableViewDataSource> dataSource;

- (void)reloadData;

- (KSTableViewCell *)dequeueReuseableCellWithIdentifier:(NSString *)identifier;

@end
