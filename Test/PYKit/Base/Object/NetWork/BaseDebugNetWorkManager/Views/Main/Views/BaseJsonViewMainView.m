//
//  BaseJsonViewManager.h
//  PYKit
//
//  Created by 李鹏跃 on 2019/9/11.
//  Copyright © 2019年 13lipengyue. All rights reserved.
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
    self.tableView.levelOffset = self.currentLevelOffset;
    [self registerEventsFunc];
}

// MARK: handle event
- (void) registerEventsFunc {
    __weak typeof (self)weakSelf = self;
    [self.tableView setJumpNextLevelVc:^(BaseJsonViewStepModel * _Nonnull model) {
        if (weakSelf.jumpNextLevelVc) {
            weakSelf.jumpNextLevelVc(model);
        }
    }];
    
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

- (void)setIsEditingStatusSearch:(BOOL)isEditingStatusSearch {
    _isEditingStatusSearch = isEditingStatusSearch;
    self.tableView.isEditingStatusSearch = isEditingStatusSearch;
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

- (void)setLongClickCellBlock:(void (^)(BaseJsonViewStepModel * _Nonnull))longClickCellBlock {
    _longClickCellBlock = longClickCellBlock;
    self.tableView.longClickCellBlock = longClickCellBlock;
}

- (void)setCurrentLevelOffset:(NSInteger)currentLevelOffset {
    _currentLevelOffset = currentLevelOffset;
    self.tableView.levelOffset = currentLevelOffset;
}

- (void) openAll {
    [self.tableView openAll];
}

- (void) closeAll {
    [self.tableView closeAll];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}

@end
