//
//  DebugNetWorkSearchResultViewController.m
//  PYkit
//
//  Created by 衣二三 on 2019/7/5.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import "DebugNetWorkSearchResultViewController.h"
#import "DebugNetWorkSearchResultTableView.h"
#import "BaseDebugNetWorkCommon.h"

@interface DebugNetWorkSearchResultViewController ()
@property (nonatomic,strong) DebugNetWorkSearchResultTableView *tableView;
@end

@implementation DebugNetWorkSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.tableView.width = self.view.width;
    self.tableView.top = BaseSize.navTotalH;
    self.tableView.height = BaseSize.screenH - _tableView.top;
    [self setupNavBar];
}

- (void) setupNavBar {
    NSString *str =
    BaseStringHandler
    .handler(self.searchKey)
    .addObjc(@"共有：")
    .addInt(self.modelArray.count <= 0 ? 0 : self.modelArray.count)
    .addObjc(@" 条数据")
    .getStr;
    [self.navBarView.titleButton setTitle:str forState:UIControlStateNormal];
}

- (void) setupTableView {
    self.tableView = [[DebugNetWorkSearchResultTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.width = self.view.width;
    self.tableView.top = BaseSize.screen_navH;
    self.tableView.height = BaseSize.screenH - self.tableView.top;
    __weak typeof(self)weakSelf = self;
    [self.tableView setClickCellBlock:^(BaseDebugNetWorkDataStepModel * _Nonnull model) {
        if (weakSelf.clickCellBlock) {
            weakSelf.clickCellBlock(model);
        }
    }];
}

- (DebugNetWorkSearchResultTableView *)tableView {
    if (!_tableView) {
        _tableView = [[DebugNetWorkSearchResultTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        __weak typeof(self)weakSelf = self;
        [_tableView setClickCellBlock:^(BaseDebugNetWorkDataStepModel * _Nonnull model) {
            if (weakSelf.clickCellBlock) {
                weakSelf.clickCellBlock(model);
            }
        }];
    }
    return _tableView;
}

- (void)setModelArray:(NSArray<BaseDebugNetWorkDataStepModel *> *)modelArray {
    _modelArray = modelArray;
    self.tableView.modelArray = modelArray;
    [self setupNavBar];
}

- (void)setCurrentSearchModel:(BaseDebugNetWorkDataStepModel *)currentSearchModel {
    _currentSearchModel = currentSearchModel;
    self.tableView.currentSearchModel = currentSearchModel;
    [self.tableView reloadData];
}

@end
