//
//  MainView.m
//  Test
//
//  Created by 衣二三 on 2019/4/15.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import "MainView.h"
#import "BaseObjectHeaders.h"
#import "BaseViewHeaders.h"
#import "MainTableViewCell.h"

@interface MainView ()
<
BaseTableViewDelegate,
BaseTableViewDataSource
>
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSArray <NSString *>*dataArray;
@end


@implementation MainView


// MARK: - init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViewsFunc];
    }
    return self;
}

- (NSArray<NSString *> *)dataArray {
    if (!_dataArray) {
        _dataArray = @[
                       @"PresentViewController",
                       @"BaseTableViewController",
                       @"BaseTextViewController",
                       @"DeleteCollectionCellViewController",
                       @"ThumbnailImageViewController",
                       @"PresentAnimationVC",
                       @"PYCountDownViewController",
                       @"DebugNetWorkViewController"
                       ];
    }
    return _dataArray;
}
#pragma mark - func
// MARK: reload data


// MARK: handle views
- (void) setupSubViewsFunc {
    [self addSubview: self.tableView];
    
    
}

// MARK: handle event
- (void) registerEventsFunc {
    
}

// MARK: lazy loads
- (BaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[BaseTableView alloc]initWithFrame:self.bounds];
        _tableView.tableViewDelegate = self;
        _tableView.tableViewDataSource = self;
    }
    return _tableView;
}

// MARK: systom functions

// MARK:life cycles


#pragma mark - delegate dataSource
- (SBaseTabelViewData) getTableViewData:(BaseTableView *)baseTableView andCurrentSection:(NSInteger)section andCurrentRow:(NSInteger)row {
    
    SBaseTabelViewData data = SBaseTabelViewDataMakeDefault();
    data.rowCount = self.dataArray.count;
    data.sectionCount = 1;
    data.rowHeight = 60;
    data.rowType = MainTableViewCell.class;
    data.rowIdentifier = @"MainTableViewCell";
    data.key = self.dataArray[row];
    return data;
}

- (void)baseTableView:(BaseTableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath andData:(SBaseTabelViewData)data{
    
    if ([MainTableViewCell.class isEqual: data.rowType]) {
        MainTableViewCell *mainCell = (MainTableViewCell *)cell;
        mainCell.title = self.dataArray[indexPath.row];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath andData:(SBaseTabelViewData)data {
    
    if ([MainTableViewCell.class isEqual:data.rowType]) {
        NSString *classStr = data.key;
        UIViewController *vc = [NSClassFromString(classStr) new];
        [self send:kClickMainView andData:vc];
    }
}
@end


