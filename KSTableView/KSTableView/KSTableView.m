//
//  KSTableView.m
//  KSTableView
//
//  Created by xiaoshi on 2017/2/16.
//  Copyright © 2017年 xiaoshi. All rights reserved.
//

#import "KSTableView.h"
#import "KSTableViewCell.h"

static CGFloat space = 10;
static CGFloat leftSpace = 10;
static CGFloat rightSpace = 10;

@interface KSTableView()
@property (nonatomic, strong) NSMutableArray *cellFrames;

@property (nonatomic, strong) NSMutableArray *reuseableCells;

@property (nonatomic, strong) NSMutableDictionary *dispalyingCells;
@end

@implementation KSTableView

- (NSMutableArray *)cellFrames
{
    if (!_cellFrames) {
        _cellFrames = [NSMutableArray array];
    }
    return _cellFrames;
}

- (NSMutableArray *)reuseableCells
{
    if (!_reuseableCells) {
        _reuseableCells = [NSMutableArray array];
    }
    return _reuseableCells;
}

- (NSMutableDictionary *)dispalyingCells
{
    if (!_dispalyingCells) {
        _dispalyingCells = [NSMutableDictionary dictionary];
    }
    return _dispalyingCells;
}

- (void)reloadData
{
    NSInteger numberCount = [self.dataSource numberOfCellInTableView:self];
    NSInteger numCol = [self numberOfColumn];
    CGFloat cellW = (self.frame.size.width - leftSpace - rightSpace - (numCol - 1)*space)/numCol;
    NSMutableArray *heights = [NSMutableArray array];
    for (int i = 0; i < numberCount; i++) {
        CGFloat cellH = [self heightForCell:i];
        if (i < numCol) {
            CGFloat cellX = leftSpace + (cellW + space)*i;
            CGRect frame = CGRectMake(cellX, space, cellW, cellH);
            [self.cellFrames addObject:[NSValue valueWithCGRect:frame]];
            [heights addObject:@(cellH)];
        } else {
            CGFloat minHeight = [self getMinHeight:heights];
            NSInteger minIndex = [self getMinIndex:heights height:minHeight];
            CGFloat cellX = leftSpace + (cellW+space)*minIndex;
            CGFloat cellY = minHeight + space;
            CGRect frame = CGRectMake(cellX, cellY, cellW, cellH);
            [self.cellFrames addObject:[NSValue valueWithCGRect:frame]];
            heights[minIndex] = @(cellH+cellY);
        }
    }
    
    CGFloat contentH = [self getMaxHeight:heights];
    contentH = contentH + space;
    self.contentSize = CGSizeMake(0, contentH);
}

- (KSTableViewCell *)dequeueReuseableCellWithIdentifier:(NSString *)identifier
{
    __block KSTableViewCell *cell = nil;
    [self.reuseableCells enumerateObjectsUsingBlock:^(KSTableViewCell *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.identifier isEqualToString:identifier]) {
            cell = obj;
            *stop = YES;
        }
    }];
    if (cell) {
        [self.reuseableCells removeObject:cell];
    }
    return cell;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSInteger numberOfCells = self.cellFrames.count;
    
    for (int i = 0; i < numberOfCells; i++) {
        CGRect frame = [self.cellFrames[i] CGRectValue];
        KSTableViewCell *cell = self.dispalyingCells[@(i)];
        if ([self isInScreen:frame]) {
            if (!cell) {
                cell = [self.dataSource tableView:self cellAtIndex:i];
                cell.frame = frame;
                [self addSubview:cell];
                self.dispalyingCells[@(i)] = cell;
            }
        } else {
            if (cell) {
                [cell removeFromSuperview];
                [self.dispalyingCells removeObjectForKey:@(i)];
                [self.reuseableCells addObject:cell];
            }
        }
    }
}

- (CGFloat)getMinHeight:(NSArray *)heightArr
{
    CGFloat minHeight = MAXFLOAT;
    for (id height in heightArr) {
        minHeight = MIN(minHeight, [height floatValue]);
    }
    return minHeight;
}

- (CGFloat)getMaxHeight:(NSArray *)heightArr
{
    CGFloat maxHeight = 0;
    for (id height in heightArr) {
        maxHeight = MAX(maxHeight, [height floatValue]);
    }
    return maxHeight;
}

- (NSInteger)getMinIndex:(NSArray *)heightArr height:(CGFloat)minHeight
{
    for (int i = 0; i<heightArr.count; i++) {
        if ([heightArr[i] floatValue] == minHeight) {
            return i;
        }
    }
    return 0;
}

- (BOOL)isInScreen:(CGRect)frame
{
    return (CGRectGetMaxY(frame)>self.contentOffset.y) && (CGRectGetMinY(frame) < self.contentOffset.y+self.frame.size.height);
}

- (NSInteger)numberOfColumn
{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(tableView:numberOfColumnInCell:)]) {
        return [self.dataSource tableView:self numberOfColumnInCell:0];
    } else {
        return 2;
    }
}

- (CGFloat)heightForCell:(NSInteger)index
{
    if (self.tableDelegate &&[self.tableDelegate respondsToSelector:@selector(tableView:heightAtIndex:)]) {
        return [self.tableDelegate tableView:self heightAtIndex:index];
    } else {
        return 10;
    }
}
//- (CGFloat)

@end
