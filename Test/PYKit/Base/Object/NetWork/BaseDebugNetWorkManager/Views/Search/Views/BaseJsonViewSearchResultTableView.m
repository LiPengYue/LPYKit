//
//  BaseJsonViewManager.h
//  PYKit
//
//  Created by 李鹏跃 on 2019/9/11.
//  Copyright © 2019年 13lipengyue. All rights reserved.
//


#import "BaseJsonViewSearchResultTableView.h"
#import "BaseJsonViewSearchResultTableViewHeaderView.h"
#import "BaseJsonViewTableViewCell.h"
#import "BaseObjectHeaders.h"
#import "BaseViewHeaders.h"


static NSString *const kBaseJsonViewSearchResultTableViewHeaderViewID = @"kBaseJsonViewSearchResultTableViewHeaderViewID";
static NSString *const kBaseJsonViewTableViewCellID = @"kBaseJsonViewTableViewCellID";

@interface BaseJsonViewSearchResultTableView()
<
PYBaseTableViewDataSource,
PYBaseTableViewDelegate
>
@property (nonatomic,strong) NSMutableArray <NSMutableArray <BaseJsonViewStepModel *>*>*modelDataArray;
@property (nonatomic,strong) NSMutableArray <NSString *>*titleArray;
@property (nonatomic,strong) NSMutableArray <NSNumber *>*titleHeightArray;

/// 剪切板
@property (nonatomic,strong) UIPasteboard *pasteboard;
@end

@implementation BaseJsonViewSearchResultTableView

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
- (void)setModelArray:(NSArray<BaseJsonViewStepModel *> *)modelArray {
    _modelArray = modelArray;
    self.modelDataArray = [[NSMutableArray alloc]initWithCapacity:modelArray.count];
    [self.modelArray enumerateObjectsUsingBlock:^(BaseJsonViewStepModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *modelArrayM = [NSMutableArray new];
        [modelArrayM addObject:obj];
        [self.modelDataArray addObject:modelArrayM];
        
        NSString *title;
        if (self.titleArray.count < idx) {
            NSString *title = [BaseJsonViewSearchResultTableViewHeaderView getTitleWithModel:self.modelArray[idx]];
            [self.titleArray addObject:title];
        }
        
        title = self.titleArray[idx];
        if (self.titleHeightArray.count < idx) {
            NSNumber *height = @([BaseJsonViewSearchResultTableViewHeaderView getHWithString:title]);
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
- (SBaseTabelViewData) getTableViewData: (PYTableMainView *)baseTableView
                      andCurrentSection: (NSInteger) section
                          andCurrentRow: (NSInteger) row {
    SBaseTabelViewData data = SBaseTabelViewDataMakeDefault();
    data.headerType = BaseJsonViewSearchResultTableViewHeaderView.class;
    data.sectionCount = self.modelArray.count;
    
    data.rowType = BaseJsonViewTableViewCell.class;
    data.rowCount = self.modelDataArray[section].count;
    
    data = [self setUpHeaderViewHeightWithData: data andSection: section];
    return data;
}

- (SBaseTabelViewData) setUpHeaderViewHeightWithData: (SBaseTabelViewData)data andSection: (NSInteger)section {
    NSString *title;
    if (self.titleArray.count < section) {
        NSString *title = [BaseJsonViewSearchResultTableViewHeaderView getTitleWithModel:self.modelArray[section]];
        [self.titleArray addObject:title];
    }
    
    title = self.titleArray[section];
    if (self.titleHeightArray.count < section) {
        NSNumber *height = @([BaseJsonViewSearchResultTableViewHeaderView getHWithString:title]);
        [self.titleHeightArray addObject:height];
    }
    data.headerHeight = self.titleHeightArray[section].floatValue;
    return data;
}

- (void) tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section andData:(SBaseTabelViewData)data {
    if ([view.class isKindOfClass:BaseJsonViewSearchResultTableViewHeaderView.class]) {
        BaseJsonViewSearchResultTableViewHeaderView *header = (BaseJsonViewSearchResultTableViewHeaderView *)view;
        if (_titleArray.count < section) {
            [self setUpHeaderViewHeightWithData:data andSection:section];
        }
        header.title = self.titleArray[section];
    }
}

- (void) baseTableView:(PYTableMainView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath andData: (SBaseTabelViewData)data {
    if ([cell isKindOfClass:BaseJsonViewTableViewCell.class]) {
        BaseJsonViewTableViewCell *netWorkCell = (BaseJsonViewTableViewCell *)cell;
        netWorkCell.indexPath = indexPath;
        __weak typeof(self) weakSelf = self;
        [netWorkCell setSingleTapBlock:^(BaseJsonViewTableViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath) {
            [weakSelf handleSingleTapActionWithCell:cell andIndexPath:indexPath];
        }];
        
        [netWorkCell setLongAction:^(BaseJsonViewTableViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath) {
            [weakSelf handleLongActionWithCell: cell andIndexPath: indexPath];
        }];
    }
}

// 单击功能
- (void) handleSingleTapActionWithCell: (BaseJsonViewTableViewCell *)message andIndexPath: (NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
//    NSInteger row = indexPath.row;
    /// 展开 或 收起
    if ([message isKindOfClass:BaseJsonViewTableViewCell.class]) {
        BaseJsonViewTableViewCell *cell = message;
        
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


- (void) handleLongActionWithCell:(BaseJsonViewTableViewCell *)cell andIndexPath: (NSIndexPath *)indexPath {
    BaseJsonViewStepModel *model = self.modelArray[indexPath.row];
    [self.pasteboard setString: [model conversionToJson]];
}

- (UIPasteboard *)pasteboard {
    if (!_pasteboard) {
        _pasteboard = [UIPasteboard generalPasteboard];
    }
    return _pasteboard;
}
@end
