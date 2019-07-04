//
//  DebugNetWorkSearchTableView.m
//  PYkit
//
//  Created by 衣二三 on 2019/7/2.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import "DebugNetWorkSearchTableView.h"
#import "DebugNetWorkSearchTableViewHeaderView.h"
#import "DebugNetWorkTableViewCell.h"
#import "BaseObjectHeaders.h"
#import "BaseViewHeaders.h"


static NSString *const kDebugNetWorkSearchTableViewHeaderViewID = @"kDebugNetWorkSearchTableViewHeaderViewID";
static NSString *const kDebugNetWorkTableViewCellID = @"kDebugNetWorkTableViewCellID";

@interface DebugNetWorkSearchTableView()
<
BaseTableViewDataSource,
BaseTableViewDelegate
>
@property (nonatomic,strong) NSMutableArray <NSMutableArray <BaseDebugNetWorkDataStepModel *>*>*modelDataArray;
@property (nonatomic,strong) NSMutableArray <NSString *>*titleArray;
@property (nonatomic,strong) NSMutableArray <NSNumber *>*titleHeightArray;
@end

@implementation DebugNetWorkSearchTableView

// MARK: - init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isAutoClose = true;
        [self setupSubViewsFunc];
    }
    return self;
}

#pragma mark - func
// MARK: reload data
- (void)setModelArray:(NSArray<BaseDebugNetWorkDataStepModel *> *)modelArray {
    _modelArray = modelArray;
    self.modelDataArray = [[NSMutableArray alloc]initWithCapacity:modelArray.count];
    [self.modelArray enumerateObjectsUsingBlock:^(BaseDebugNetWorkDataStepModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *modelArrayM = [NSMutableArray new];
        [modelArrayM addObject:obj];
        [self.modelDataArray addObject:modelArrayM];
        
        NSString *title;
        if (self.titleArray.count < idx) {
            NSString *title = [DebugNetWorkSearchTableViewHeaderView getTitleWithModel:self.modelArray[idx]];
            [self.titleArray addObject:title];
        }
        
        title = self.titleArray[idx];
        if (self.titleHeightArray.count < idx) {
            NSNumber *height = @([DebugNetWorkSearchTableViewHeaderView getHWithString:title]);
            [self.titleHeightArray addObject:height];
        }
    }];
    [self.tableView reloadData];
}

// MARK: handle views
- (void) setupSubViewsFunc {
    self.tableViewDelegate = self;
    self.tableViewDataSource = self;
}

// MARK: handle event
- (void) registerEventsFunc {
    
}
// MARK: lazy loads

// MARK: systom functions
- (void)layoutSubviews {
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}
// MARK:life cycles

// MARK: - dataSource && delegate

/// 获取tableView 的布局数据 (将会频繁调用)
- (SBaseTabelViewData) getTableViewData: (BaseTableView *)baseTableView
                      andCurrentSection: (NSInteger) section
                          andCurrentRow: (NSInteger) row {
    SBaseTabelViewData data = SBaseTabelViewDataMakeDefault();
    data.headerType = DebugNetWorkSearchTableViewHeaderView.class;
    data.sectionCount = self.modelArray.count;
    
    data.rowType = DebugNetWorkTableViewCell.class;
    data.rowCount = self.modelDataArray[section].count;
    
    data = [self setUpHeaderViewHeightWithData: data andSection: section];
    return data;
}

- (SBaseTabelViewData) setUpHeaderViewHeightWithData: (SBaseTabelViewData)data andSection: (NSInteger)section {
    NSString *title;
    if (self.titleArray.count < section) {
        NSString *title = [DebugNetWorkSearchTableViewHeaderView getTitleWithModel:self.modelArray[section]];
        [self.titleArray addObject:title];
    }
    
    title = self.titleArray[section];
    if (self.titleHeightArray.count < section) {
        NSNumber *height = @([DebugNetWorkSearchTableViewHeaderView getHWithString:title]);
        [self.titleHeightArray addObject:height];
    }
    data.headerHeight = self.titleHeightArray[section].floatValue;
    return data;
}

- (void) tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section andData:(SBaseTabelViewData)data {
    if ([view.class isKindOfClass:DebugNetWorkSearchTableViewHeaderView.class]) {
        DebugNetWorkSearchTableViewHeaderView *header = (DebugNetWorkSearchTableViewHeaderView *)view;
        if (_titleArray.count < section) {
            [self setUpHeaderViewHeightWithData:data andSection:section];
        }
        header.title = self.titleArray[section];
    }
}

- (void) baseTableView:(BaseTableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath andData: (SBaseTabelViewData)data {
    if ([cell isKindOfClass:DebugNetWorkTableViewCell.class]) {
        DebugNetWorkTableViewCell *netWorkCell = (DebugNetWorkTableViewCell *)cell;
        netWorkCell.indexPath = indexPath;
        [netWorkCell setSingleTapBlock:^(DebugNetWorkTableViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath) {
            [self handleSingleTapActionWithCell:cell andIndexPath:indexPath];
        }];
    }
}

// 单击功能
- (void) handleSingleTapActionWithCell: (DebugNetWorkTableViewCell *)message andIndexPath: (NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
//    NSInteger row = indexPath.row;
    /// 展开 或 收起
    if ([message isKindOfClass:DebugNetWorkTableViewCell.class]) {
        DebugNetWorkTableViewCell *cell = message;
        
        BOOL isOpen = !cell.model.isOpen;
        cell.model.isOpen = isOpen;
        NSArray *array = [cell.model faltSelfDataIfOpen];
        NSInteger index = [self.modelDataArray[section] indexOfObject:cell.model];
        if (isOpen) {
            NSRange range = NSMakeRange(index + 1, [array count]);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            if (self.modelDataArray[index])
            [self.modelDataArray[index] insertObjects:array atIndexes:indexSet];
        }else{
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (self.isAutoClose) {
                    [obj closeAll];
                }
                [self.modelDataArray[section] removeObject:obj];
            }];
            if (self.isAutoClose) {
                [cell.model closeAll];
            }
        }
        [self.tableView reloadData];
    }
}

@end
