//
//  BaseJsonViewMainView.m
//  PYkit
//
//  Created by 衣二三 on 2019/7/1.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import "BaseJsonViewMainView.h"
#import "BaseJsonViewTableView.h"
#import "BaseJsonViewSearchView.h"
#import "BaseObjectHeaders.h"
#import "BaseViewHeaders.h"
#import "BaseSize.h"


@interface BaseJsonViewMainView()

@property (nonatomic,strong) BaseJsonViewStepModel *model;
@end


@implementation BaseJsonViewMainView

// MARK: - init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViewsFunc];
    }
    return self;
}

#pragma mark - func
// MARK: reload data

// MARK: handle views
- (void) setupSubViewsFunc {
    [self addSubview:self.tableView];
}

// MARK: handle event
- (void) registerEventsFunc {
    
}

- (void) scrollToModel: (BaseJsonViewStepModel *)model {
    [self.tableView scrollToModel:model];
}

// MARK: get && set

- (void) reloadWithData:(id) data {
    if ([data isEqual:BaseJsonViewStepModel.class]) {
        self.model = data;
    } else{
        self.model = BaseJsonViewStepModel.createWithID(data);
    }
}

- (void) setModel:(BaseJsonViewStepModel *)model {
    _model = model;
    self.tableView.model = model;
    [self.tableView reloadData];
}

- (BaseJsonViewTableView *)tableView {
    if (!_tableView) {
        _tableView = [[BaseJsonViewTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return _tableView;
}

- (BaseJsonViewStepModel *) getCurrentModel {
    return self.model;
}

- (void)setIsAccurateSearch:(BOOL)isAccurateSearch {
    _isAccurateSearch = isAccurateSearch;
    self.tableView.isAccurateSearch = isAccurateSearch;
}

- (void)setDoubleClickCellBlock:(void (^)(BaseJsonViewStepModel * _Nonnull))doubleClickCellBlock {
    _doubleClickCellBlock = doubleClickCellBlock;
    self.tableView.doubleClickCellBlock = doubleClickCellBlock;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}

@end
