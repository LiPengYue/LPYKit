//
//  BaseJsonViewManager.h
//  PYKit
//
//  Created by 李鹏跃 on 2019/9/11.
//  Copyright © 2019年 13lipengyue. All rights reserved.
//


#import "BaseJsonViewSearchResultViewController.h"
#import "BaseJsonViewSearchResultListTableView.h"
#import "BaseJsonViewCommon.h"

@interface BaseJsonViewSearchResultViewController ()
@property (nonatomic,strong) BaseJsonViewSearchResultListTableView *tableView;
@end

@implementation BaseJsonViewSearchResultViewController

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
    self.tableView = [[BaseJsonViewSearchResultListTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.width = self.view.width;
    self.tableView.top = BaseSize.screen_navH;
    self.tableView.height = BaseSize.screenH - self.tableView.top;
    __weak typeof(self)weakSelf = self;
    [self.tableView setClickCellBlock:^(BaseJsonViewStepModel * _Nonnull model) {
        if (weakSelf.clickCellBlock) {
            weakSelf.clickCellBlock(model);
        }
    }];
}

- (BaseJsonViewSearchResultListTableView *)tableView {
    if (!_tableView) {
        _tableView = [[BaseJsonViewSearchResultListTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        __weak typeof(self)weakSelf = self;
        [_tableView setClickCellBlock:^(BaseJsonViewStepModel * _Nonnull model) {
            if (weakSelf.clickCellBlock) {
                weakSelf.clickCellBlock(model);
            }
        }];
    }
    return _tableView;
}

- (void)setModelArray:(NSArray<BaseJsonViewStepModel *> *)modelArray {
    _modelArray = modelArray;
    self.tableView.modelArray = modelArray;
    [self setupNavBar];
}

- (void)setCurrentSearchModel:(BaseJsonViewStepModel *)currentSearchModel {
    _currentSearchModel = currentSearchModel;
    self.tableView.currentSearchModel = currentSearchModel;
    [self.tableView reloadData];
}

@end
