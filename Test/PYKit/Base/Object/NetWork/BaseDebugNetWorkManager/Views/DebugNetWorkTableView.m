//
//  BaseDebugNetWorkManager.h
//  PYKit
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//


#import "DebugNetWorkTableView.h"
#import "DebugNetWorkTableViewCell.h"
#import "BaseObjectHeaders.h"
#import "DebugNetWorkSearchView.h"
#import "BaseObjectHeaders.h"
#import "BaseViewHeaders.h"
#import "BaseSize.h"

static NSString *const kDebugNetWorkTableViewCellId = @"kDebugNetWorkTableViewCellId";

@interface DebugNetWorkTableView()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic,strong) NSMutableArray <BaseDebugNetWorkDataStepModel*>* modelArray;
@property (nonatomic,strong) BaseDebugNetWorkDataStepModel *currentSearchModel;
@property (nonatomic,strong) NSMutableArray <BaseDebugNetWorkDataStepModel*>* searchResultModelArray;
@end

@implementation DebugNetWorkTableView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.isAutoClose = true;
        [self setupViews];
    }
    return self;
}

- (void) setupViews {
    self.delegate = self;
    self.dataSource = self;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self registerClass:DebugNetWorkTableViewCell.class forCellReuseIdentifier:kDebugNetWorkTableViewCellId];
}

- (NSMutableArray<BaseDebugNetWorkDataStepModel *> *)modelArray {
    if (!_modelArray) {
        _modelArray = [[NSMutableArray alloc]init];
    }
    return _modelArray;
}

- (void) scrollToModel: (BaseDebugNetWorkDataStepModel *)model {
    NSInteger row = [self.modelArray indexOfObject:model];
    if (row > self.modelArray.count) {
        return;
    }
    if (row < 0) {
        return;
    }
    self.currentSearchModel = model;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self reloadData];
    [self scrollToRowAtIndexPath:indexPath  atScrollPosition:UITableViewScrollPositionTop animated:true];
   
}

// MARK: - get && set
- (void)setModel:(BaseDebugNetWorkDataStepModel *)model {
    _model = model;
    self.modelArray = [model faltSelfDataIfOpen].mutableCopy;
    [self reloadData];
}

- (NSMutableArray <BaseDebugNetWorkDataStepModel *>*) searchAndOpenAllWithKey: (NSString *)key {
    
    [self.model openAll];
    self.model = self.model;
    NSMutableArray <BaseDebugNetWorkDataStepModel *>*arrayM = [NSMutableArray new];
    if (key.length > 0) {
        [self.modelArray enumerateObjectsUsingBlock:^(BaseDebugNetWorkDataStepModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BOOL isTrue = self.isAccurateSearch ? [obj.key isEqualToString:key]: [obj.key containsString:key];
            if (isTrue) {
                [arrayM addObject:obj];
            }else{
                if ([obj.data isKindOfClass:NSString.class]) {
                    NSString *data = obj.data;
                    BOOL isTrue = self.isAccurateSearch ? [data isEqualToString:key]: [data containsString:key];
                    if (isTrue) {
                        [arrayM addObject:obj];
                    }
                }
            }
        }];
    }
    self.searchResultModelArray = arrayM;
    [self.model closeAll];
    
    [arrayM enumerateObjectsUsingBlock:^(BaseDebugNetWorkDataStepModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BaseDebugNetWorkDataStepModel *model = obj;
        obj.isOpen = true;
        while (model.superPoint) {
            model.isOpen = true;
            model = model.superPoint;
        }
    }];
    self.model = self.model;
    return arrayM;
}

#pragma mark - dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
       return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cellAny = [tableView dequeueReusableCellWithIdentifier:kDebugNetWorkTableViewCellId forIndexPath:indexPath];
    if ([cellAny isKindOfClass:DebugNetWorkTableViewCell.class]) {
        DebugNetWorkTableViewCell *cell = cellAny;
        cell.model = self.modelArray[indexPath.row];
        BOOL isSearchReulst = [self.searchResultModelArray containsObject:self.modelArray[indexPath.row]];
        BOOL isCurrentSearchResult = [cell.model isEqual:self.currentSearchModel];
        [cell setUpBackgroundColorWithIsSearchResultColor:isSearchReulst andIsCurrentSearchResult: isCurrentSearchResult];
        
        [self registerCellEventsWithCell: cell];
        
    }
    return cellAny;
}

- (void) registerCellEventsWithCell: (DebugNetWorkTableViewCell *) cell {
    __weak typeof(self)weakSelf = self;
    [cell setSingleTapBlock:^(DebugNetWorkTableViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath) {
        [weakSelf handleSingleTapActionWithMessage: cell];
    }];
}

// 单击功能
- (void) handleSingleTapActionWithMessage: (id)message {
    /// 展开 或 收起
    if ([message isKindOfClass:DebugNetWorkTableViewCell.class]) {
        DebugNetWorkTableViewCell *cell = message;
        [self closeWithModel:cell.model andIsOpen:!cell.model.isOpen];
    }
}

- (void) closeWithModel: (BaseDebugNetWorkDataStepModel *)model andIsOpen:(BOOL)isOpen {
    model.isOpen = isOpen;
    NSArray *array = [model faltSelfDataIfOpen];
    NSInteger index = [self.modelArray indexOfObject:model];
    if (isOpen) {
        NSRange range = NSMakeRange(index + 1, [array count]);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.modelArray insertObjects:array atIndexes:indexSet];
    }else{
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (self.isAutoClose) {
                [obj closeAll];
            }
            [self.modelArray removeObject:obj];
        }];
        if (self.isAutoClose) {
            [model closeAll];
        }
    }
    [self reloadData];
}

#pragma mark - delegate

@end
