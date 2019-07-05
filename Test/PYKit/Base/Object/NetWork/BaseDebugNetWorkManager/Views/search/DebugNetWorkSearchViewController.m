//
//  DebugNetWorkSearchViewController.m
//  PYkit
//
//  Created by 衣二三 on 2019/7/2.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import "DebugNetWorkSearchViewController.h"
#import "DebugNetWorkSearchTableView.h"
#import "BaseViewHeaders.h"
#import "BaseObjectHeaders.h"

@interface DebugNetWorkSearchViewController ()
@property (nonatomic,strong) DebugNetWorkSearchTableView *tableView;
@end

@implementation DebugNetWorkSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNetWork];
    [self setupViews];
    [self registerEvents];
}

// MARK: - init

#pragma mark - func

// MARK: setupTable

// MARK: network
- (void) loadNetWork {
    
}

// MARK: handle views
- (void) setupViews {
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
    self.tableView.modelArray = self.searchResult;
}

// MARK: handle event
- (void) registerEvents {
}

// MARK: get && set
- (void)setSearchResult:(NSArray<BaseDebugNetWorkDataStepModel *> *)searchResult {
    _searchResult = searchResult;
    self.tableView.modelArray = searchResult;
    self.titleStr =
    BaseStringHandler
    .handler(@"共有：")
    .addInt(self.searchResult.count <= 0 ? 0 : self.searchResult.count)
    .addObjc(@" 条数据")
    .getStr;
    
}

- (DebugNetWorkSearchTableView *)tableView {
    if (!_tableView) {
        _tableView = [[DebugNetWorkSearchTableView alloc]initWithFrame:CGRectZero];
    }
    return _tableView;
}

// MARK: systom functions

// MARK:life cycles

@end
