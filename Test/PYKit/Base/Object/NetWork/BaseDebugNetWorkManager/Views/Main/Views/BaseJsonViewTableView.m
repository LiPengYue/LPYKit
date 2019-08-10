//
//  BaseJsonViewManager.h
//  PYKit
//
//  Created by 李鹏跃 on 2019/9/11.
//  Copyright © 2019年 13lipengyue. All rights reserved.
//


#import "BaseJsonViewTableView.h"
#import "BaseJsonViewTableViewCell.h"
#import "BaseJsonViewSearchView.h"
#import "BaseJsonEditingStatusTableViewCell.h"
#import "BaseJsonViewStepSearchModel.h"

static NSString *const kBaseJsonViewTableViewCellId = @"kBaseJsonViewTableViewCellId";
static NSString *const kBaseJsonEditingStatusTableViewCell = @"kBaseJsonEditingStatusTableViewCell";

@interface BaseJsonViewTableView()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic,strong) NSMutableArray <BaseJsonViewStepModel*>* modelArray;
@property (nonatomic,strong) BaseJsonViewStepModel *currentSearchModel;
@property (nonatomic,strong) NSMutableArray <BaseJsonViewStepModel*>* searchResultModelArray;
/// 剪切板
@property (nonatomic,strong) UIPasteboard *pasteboard;
@property (nonatomic,strong) BaseJsonEditingStatusTableViewCell *currentEdtingCell;
@property (nonatomic,strong) NSMutableArray *editingModelArray;
@end

@implementation BaseJsonViewTableView
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.isAutoClose = true;
        [self addNoticeForKeyboard];
        [self setupViews];
    }
    return self;
}

- (void) setupViews {
    self.delegate = self;
    self.dataSource = self;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self registerClass:BaseJsonViewTableViewCell.class forCellReuseIdentifier:kBaseJsonViewTableViewCellId];
    [self registerNib:[UINib nibWithNibName:@"BaseJsonEditingStatusTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kBaseJsonEditingStatusTableViewCell];
}

- (NSMutableArray<BaseJsonViewStepModel *> *)modelArray {
    if (!_modelArray) {
        _modelArray = [[NSMutableArray alloc]init];
    }
    return _modelArray;
}

- (void) scrollToModel: (BaseJsonViewStepModel *)model {
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
- (void)setModel:(BaseJsonViewStepModel *)model {
    _model = model;
    switch (model.type) {
        case BaseJsonViewStepModelType_Dictionary:
        case BaseJsonViewStepModelType_Array:
              self.modelArray = [model faltSelfDataIfOpen].mutableCopy;
            break;
        case BaseJsonViewStepModelType_Number:
        case BaseJsonViewStepModelType_String:
            [self.modelArray removeAllObjects];
            [self.modelArray addObject:model];
            break;
    }

    [self reloadData];
}

- (NSMutableArray <BaseJsonViewStepModel *>*) searchAndOpenAllWithKey: (NSString *)key {

    SBaseJsonViewStepSearchModelConfig config;
    config.key = key;
    config.model = self.model;
    config.isSearchEditing = self.isEditingStatusSearch;
    config.isAccurateSearch = self.isAccurateSearch;
    self.searchResultModelArray = BaseJsonViewStepSearchModel.getResultWithSearchConfig(config);

    [self.model closeAll];
    
    [self.searchResultModelArray enumerateObjectsUsingBlock:^(BaseJsonViewStepModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BaseJsonViewStepModel *model = obj;
        obj.isOpen = true;
        while (model.superPoint) {
            model.isOpen = true;
            model = model.superPoint;
        }
    }];
    self.model = self.model;
    return self.searchResultModelArray;
}

- (BOOL) isSearchDataWithModel: (BaseJsonViewStepModel *) obj andKey: (NSString *)key {
    
    BOOL isTrue = self.isAccurateSearch ? [obj.key isEqualToString:key]: [obj.key containsString:key];
    if (!isTrue && [obj.data isKindOfClass:NSString.class]) {
        NSString *data = obj.data;
        isTrue = self.isAccurateSearch ? [data isEqualToString:key]: [data containsString:key];
    }
    
    if (self.isEditingStatusSearch) {
        switch (obj.status) {
            case BaseJsonViewStepCellStatus_Normal:
                isTrue = false;
                break;
            case BaseJsonViewStepCellStatus_EditingSelf:
            case BaseJsonViewStepCellStatus_InsertItem:
                if (key.length <= 0) {
                    isTrue = true;
                }else{
                    isTrue = isTrue;
                }
                break;
        }
    }
    return isTrue;
}


#pragma mark - dataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseJsonViewStepModel *model = self.modelArray[indexPath.row];
    if (model.status != BaseJsonViewStepCellStatus_Normal) {
        return [BaseJsonEditingStatusTableViewCell getHeithWithModel:model];
    }
    CGFloat h = 0;
    CGFloat normalH = tableViewCellFoldLineMaxHeight;
    
    h = [BaseJsonViewTableViewCell getHeightWithModel:model andLevelOffset:self.levelOffset andLeftMaxW:self.width/2.0 andCellWidth:self.width] + tableViewCellTopMinSpacing + tableViewCellBottomMinSpacing;
    
    model.isShowFoldLineButton = h > normalH;
    
    if (model.isShowFoldLineButton) {
        normalH += tableViewCellBottomFoldLineButtonH;
        h += tableViewCellBottomFoldLineButtonH;
    }
    
    if (model.isOpenFoldLine) {
       return MAX(h,normalH);
    }else{
        return normalH;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *str = kBaseJsonViewTableViewCellId;
    if (self.modelArray[indexPath.row].status != BaseJsonViewStepCellStatus_Normal) {
        str = kBaseJsonEditingStatusTableViewCell;
    }
    UITableViewCell *cellAny = [tableView dequeueReusableCellWithIdentifier:str forIndexPath:indexPath];
    cellAny.selectionStyle = UITableViewCellSelectionStyleNone;
    return cellAny;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:BaseJsonViewTableViewCell.class]) {
        BaseJsonViewTableViewCell *jsonCell = (BaseJsonViewTableViewCell *)cell;
        jsonCell.levelOffset = self.levelOffset;
        jsonCell.model = self.modelArray[indexPath.row];
        jsonCell.indexPath = indexPath;
        BOOL isSearchReulst = [self.searchResultModelArray containsObject:self.modelArray[indexPath.row]];
        BOOL isCurrentSearchResult = [jsonCell.model isEqual:self.currentSearchModel];
        [jsonCell setUpBackgroundColorWithIsSearchResultColor:isSearchReulst andIsCurrentSearchResult: isCurrentSearchResult];
        
        [self registerCellEventsWithCell: jsonCell];
    }
    if ([cell isKindOfClass:BaseJsonEditingStatusTableViewCell.class]) {
        BaseJsonEditingStatusTableViewCell *editCell = (BaseJsonEditingStatusTableViewCell *)cell;
        editCell.editingModel = self.modelArray[indexPath.row];
        NSInteger row = [self.modelArray indexOfObject:editCell.editingModel.superPoint];
        NSIndexPath *superPointIndex = [NSIndexPath indexPathForRow:row inSection:0];
        editCell.superPointIndexPath = superPointIndex;
        editCell.indexPath = indexPath;
        
        [self registerEditingCellEventWith:editCell];
    }
}

- (void) registerEditingCellEventWith:(BaseJsonEditingStatusTableViewCell *)editCell {
    __weak typeof (self)weakSelf = self;
    __weak typeof(editCell)weakEditCell = editCell;
    
    [editCell setClickInsertDownBlock:^{
        
        [weakSelf.editingModelArray removeObject: weakEditCell.editingModel];
        
        NSIndexPath *index = [weakSelf indexPathForCell:weakEditCell];
        
        [weakSelf.modelArray replaceObjectAtIndex:index.row withObject:weakEditCell.editingModel];

        NSInteger row = [weakSelf.modelArray indexOfObject:weakEditCell.editingModel.superPoint];
        NSIndexPath *superPointIndex = [NSIndexPath indexPathForRow:row inSection:0];
        [weakSelf reloadRowsAtIndexPaths:@[index,superPointIndex] withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    [editCell setClickCancellButtonBlock:^{
        
        [weakSelf.editingModelArray removeObject: weakEditCell.editingModel];
        
        NSIndexPath *index = [weakSelf indexPathForCell:weakEditCell];
        switch(weakEditCell.editingModel.status) {
            case BaseJsonViewStepCellStatus_Normal:
                break;
            case BaseJsonViewStepCellStatus_EditingSelf: {
                weakEditCell.editingModel.status = BaseJsonViewStepCellStatus_Normal;
                [weakSelf.modelArray replaceObjectAtIndex:index.row withObject:weakEditCell.editingModel];
                NSInteger row = [weakSelf.modelArray indexOfObject:weakEditCell.editingModel.superPoint];
                NSIndexPath *superPointIndex = [NSIndexPath indexPathForRow:row inSection:0];
                [weakSelf beginUpdates];
                [weakSelf reloadRowsAtIndexPaths:@[index,superPointIndex] withRowAnimation:UITableViewRowAnimationFade];
                [weakSelf endUpdates];
            }
                break;
            case BaseJsonViewStepCellStatus_InsertItem:{
                weakEditCell.editingModel.status = BaseJsonViewStepCellStatus_Normal;
                [weakSelf.modelArray removeObjectAtIndex:index.row];
                [weakSelf beginUpdates];
                [weakSelf deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
                [weakSelf endUpdates];
            }
                break;
        }
    }];
    
    [editCell setTextViewShouldBeginEditingBlock:^BOOL(BaseJsonEditingStatusTableViewCell * _Nonnull cell) {
        weakSelf.currentEdtingCell = cell;
        return true;
    }];
}

- (void) registerCellEventsWithCell: (BaseJsonViewTableViewCell *) cell {
    __weak typeof(self)weakSelf = self;
    [cell setSingleTapBlock:^(BaseJsonViewTableViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath) {
        [weakSelf handleSingleTapActionWithMessage: cell];
    }];
    [cell setLongAction:^(BaseJsonViewTableViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath) {
        [weakSelf handleLongActionWithCell: cell andIndexPath: indexPath];
    }];
    [cell setDoubleAction:^(BaseJsonViewTableViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath) {
        [weakSelf handleDoubleActionWithCell:cell andIndexPath: indexPath];
    }];
    
    [cell setClickBottomFoldLineButtonBlock:^(BaseJsonViewTableViewCell * _Nonnull cell) {
        BaseJsonViewStepModel *model = cell.model;
        model.isOpenFoldLine = !model.isOpenFoldLine;
        
        [weakSelf beginUpdates];
        [weakSelf endUpdates];
    }];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseJsonViewStepModel *model = self.modelArray[indexPath.row];
    UITableViewRowAction *copyAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"复制json" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self.pasteboard setString:[model conversionToJson]];
    }];
    UITableViewRowAction *copyStrAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"复制value" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if ([model.data isKindOfClass:NSString.class]) {
            [self.pasteboard setString: (NSString *)model.data];
        }
    }];
    
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        model.status = BaseJsonViewStepCellStatus_EditingSelf;
        
        if(model.isOpen) {
            [self closeWithModel:model andIsOpen:false andIndex:indexPath];
        }
        [self.editingModelArray addObject:model];
        [self beginUpdates];
        [self reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.modelArray indexOfObject:model]  inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [self endUpdates];
         
    }];
    
    UITableViewRowAction *insertFormSuperAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"父节点插入" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        if (model.isOpen) {
            [self closeWithModel:model andIsOpen:false andIndex:indexPath];
        }
        
        BaseJsonViewStepModel *itemModel = [BaseJsonViewStepModel new];
        itemModel.level = model.level;
        itemModel.status = BaseJsonViewStepCellStatus_InsertItem;
        
        [self.editingModelArray addObject:itemModel];
        
        [self.modelArray insertObject:itemModel atIndex:[self.modelArray indexOfObject:model] + 1];
        itemModel.superPoint = model.superPoint;
        
        [self beginUpdates];
        [self insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.modelArray indexOfObject:model] + 1  inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [self endUpdates];
        
    }];
    
    UITableViewRowAction *insertChildAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"插入子节点" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if(!model.isOpen) {
            [self closeWithModel:model andIsOpen:true andIndex:indexPath];
        }
        
        BaseJsonViewStepModel *itemModel = [BaseJsonViewStepModel new];
        itemModel.level = model.level + 1;
        itemModel.status = BaseJsonViewStepCellStatus_InsertItem;
        [self.modelArray insertObject:itemModel atIndex:[self.modelArray indexOfObject:model] + 1];
        itemModel.superPoint = model;
        [self.editingModelArray addObject:itemModel];
        [self beginUpdates];
        [self insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.modelArray indexOfObject:model] + 1  inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [self endUpdates];
    }];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [self deleteWithModel:model];
        
    }];
    
    editAction.backgroundColor = editActionBackgroundColor;
    copyAction.backgroundColor = copyActionBackgroundColor;
    copyStrAction.backgroundColor = copyStrActionBackgroundColor;
    deleteAction.backgroundColor = deleteActionBackgroundColor;
    
    insertFormSuperAction.backgroundColor = insertFormSuperPointActionBackgroundColor;
    insertChildAction.backgroundColor = insertFormChildPointActionBackgroundColor;
    
    if(model.status != BaseJsonViewStepCellStatus_Normal) {
        return @[deleteAction];
    }
    
    switch (model.type) {
        
        case BaseJsonViewStepModelType_Dictionary:
        case BaseJsonViewStepModelType_Array:{
            return @[copyAction, editAction,
                     insertChildAction,insertFormSuperAction,deleteAction];
        }
            break;
        case BaseJsonViewStepModelType_Number:
        case BaseJsonViewStepModelType_String:
            return @[copyStrAction,copyAction,editAction,insertFormSuperAction,deleteAction];
            break;
    }
    
    return @[copyAction, editAction,insertChildAction,insertFormSuperAction,deleteAction];
}

- (void) deleteWithModel: (BaseJsonViewStepModel *)model {
    if (!model) return;
    
    [self.editingModelArray removeObject:model];
    
    NSMutableArray <NSIndexPath *>*indexPaths = [[NSMutableArray alloc]init];
    NSMutableArray <BaseJsonViewStepModel *>*deleteModelArray = [[NSMutableArray alloc]init];
    [deleteModelArray addObject:model];
    [deleteModelArray addObjectsFromArray:[model faltSelfDataIfOpen]];
    
    [deleteModelArray enumerateObjectsUsingBlock:^(BaseJsonViewStepModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self.modelArray containsObject:obj]) {  NSInteger index = [self.modelArray indexOfObject:obj];
            [indexPaths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
        }
    }];
    
    [self.modelArray removeObjectsInArray:deleteModelArray];
    [model removeFromeSuper];
    
    BaseJsonViewStepModel *superPointModel = model.superPoint;
    
    [self beginUpdates];
    [self deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self endUpdates];
    
    if ([superPointModel isKindOfClass:BaseJsonViewStepModel.class]) {
        NSInteger row = [self.modelArray indexOfObject:superPointModel];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void) handleSingleTapActionWithMessage: (id)message {
    /// 展开 或 收起
    if ([message isKindOfClass:BaseJsonViewTableViewCell.class]) {
        BaseJsonViewTableViewCell *cell = message;
        BOOL overflowMaxLevle = cell.model.level - self.levelOffset > tableViewCellMaxLevel;
        BOOL isNeededOpen = [cell.model.data isKindOfClass:NSArray.class];
        switch (cell.model.type) {
            case BaseJsonViewStepModelType_Dictionary:
            case BaseJsonViewStepModelType_Array:
                break;
            case BaseJsonViewStepModelType_Number:
            case BaseJsonViewStepModelType_String:
                return;
                break;
        }
        
        if (overflowMaxLevle
            && self.jumpNextLevelVc
            && isNeededOpen) {
            //跳转一个新的控制器
            self.jumpNextLevelVc(cell.model);
        }else{
            NSIndexPath *index = [self indexPathForCell:cell];
            [self closeWithModel:cell.model andIsOpen:!cell.model.isOpen andIndex:index];
        }
    }
}

- (void) closeWithModel: (BaseJsonViewStepModel *)model andIsOpen:(BOOL)isOpen andIndex: (NSIndexPath *)indexPath{
    
    NSArray *array = [model faltSelfDataIfOpen];
    model.isOpen = isOpen;
    
    NSInteger index = [self.modelArray indexOfObject:model];
    NSRange range = NSMakeRange(index + 1, [array count]);
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    
    NSMutableArray <NSIndexPath *>*indexPaths = [[NSMutableArray alloc]initWithCapacity:array.count];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:index + 1 + idx inSection:0]];
    }];
    
    NSMutableArray *updataIndexArrayM = [NSMutableArray new];
    NSIndexPath *cellIndex = indexPath;
    if (cellIndex) {
        [updataIndexArrayM addObject:cellIndex];
    }
 
    if (isOpen) {
        [self.modelArray insertObjects:array atIndexes:indexSet];
        [self beginUpdates];
        [self reloadRowsAtIndexPaths:updataIndexArrayM withRowAnimation:UITableViewRowAnimationNone];
        [self insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self endUpdates];
    }else{
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (self.isAutoClose) {
                [obj closeAll];
            }
        }];
        
        [self.modelArray removeObjectsAtIndexes:indexSet];
        
        if (self.isAutoClose) {
            [model closeAll];
        }
        [self beginUpdates];
        [self reloadRowsAtIndexPaths:updataIndexArrayM withRowAnimation:UITableViewRowAnimationNone];
        [self deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self endUpdates];
    }
}

- (void) handleLongActionWithCell:(BaseJsonViewTableViewCell *)cell andIndexPath: (NSIndexPath *)indexPath {
    if (self.longClickCellBlock) {
        if (@available(iOS 10.0, *)) {
            UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
            [feedBackGenertor impactOccurred];
        } else {
        }
        self.longClickCellBlock([self.modelArray objectAtIndex:indexPath.row]);
    }
}

- (void) handleDoubleActionWithCell:(BaseJsonViewTableViewCell *)cell andIndexPath: (NSIndexPath *)indexPath {
    if (self.doubleClickCellBlock) {
        self.doubleClickCellBlock(cell.model);
    }
}

- (UIPasteboard *)pasteboard {
    if (!_pasteboard) {
        _pasteboard = [UIPasteboard generalPasteboard];
    }
    return _pasteboard;
}

- (void)addNoticeForKeyboard {
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void) keyboardWillShow:(NSNotification *)notification {
   
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    CGFloat offsetY = self.contentOffset.y + self.height + kbHeight - self.currentEdtingCell.bottom;
    CGFloat offsetH = offsetY;
    CGRect rect = [self convertRect:self.currentEdtingCell.frame toView:[self superview]];
    offsetH = self.height - CGRectGetMaxY(rect);
    offsetH = kbHeight - offsetY;
    
    self.contentInset = UIEdgeInsetsMake(0, 0, kbHeight, 0);

    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if(offsetH > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.contentOffset = CGPointMake(0, self.contentOffset.y + offsetH);
        }];
    }
}

- (void) keyboardWillHide:(NSNotification *)notify {
    self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (NSMutableArray *)editingModelArray {
    if (!_editingModelArray) {
        _editingModelArray = [NSMutableArray new];
    }
    return _editingModelArray;
}

- (void) openAll {
    [self.model openAllNormalStatus];
    self.modelArray = [self.model faltSelfDataIfOpen].mutableCopy;
    [self reloadData];
}

- (void) closeAll {
    [self.model closeAll];
    self.modelArray = [self.model faltSelfDataIfOpen].mutableCopy;
    [self reloadData];
}
@end
