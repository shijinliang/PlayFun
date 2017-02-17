//
//  KSTableViewController.m
//  KSTableView
//
//  Created by xiaoshi on 2017/2/16.
//  Copyright © 2017年 xiaoshi. All rights reserved.
//

#import "KSTableViewController.h"
#import "KSTableView.h"

@interface KSTableViewController ()<KSTableViewDelegate, KSTableViewDataSource>
@property (nonatomic, strong)KSTableView *tableView;
@end

@implementation KSTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfCellInTableView:(KSTableView *)tableView
{
    return 100;
}
-(NSInteger)tableView:(KSTableView *)tableView numberOfColumnInCell:(NSInteger)cell
{
    return 3;
}

-(KSTableViewCell *)tableView:(KSTableView *)tableView cellAtIndex:(NSInteger)index
{
    KSTableViewCell *cell = [tableView dequeueReuseableCellWithIdentifier:@"KSTableView"];
    if (cell == nil) {
        cell = [[KSTableViewCell alloc] initWithRequeReuseIdentifier:@"KSTableView"];
    }
    cell.backgroundColor = [UIColor grayColor];
    return cell;
}

- (CGFloat)tableView:(KSTableView *)tableView heightAtIndex:(NSInteger)index
{
    return (random()%50+50) * (random()%5);
    /*
    switch (index%5) {
        case 0:
            return 20;
            break;
        case 1:
            return 300;
            break;
        case 2:
            return 60;
            break;
        case 3:
            return 100;
            break;
        default:
            return 150;
            break;
    }*/
}

- (KSTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[KSTableView alloc]initWithFrame:self.view.bounds];
        _tableView.backgroundColor = [UIColor greenColor];
        _tableView.tableDelegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


@end
