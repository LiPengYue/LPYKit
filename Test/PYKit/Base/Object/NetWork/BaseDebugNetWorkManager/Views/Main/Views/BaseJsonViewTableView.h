//
//  BaseJsonViewManager.h
//  PYKit
//
//  Created by 李鹏跃 on 2019/9/11.
//  Copyright © 2019年 13lipengyue. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "BaseJsonViewManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface BaseJsonViewTableView : UITableView
/// 里面应该放的是字典 或者字符串
@property (nonatomic,strong) BaseJsonViewStepModel *model;
@property (nonatomic,assign) BOOL isAutoClose;
@property (nonatomic,assign) NSInteger levelOffset;

- (NSMutableArray <BaseJsonViewStepModel *>*) searchAndOpenAllWithKey: (NSString *)key;

/// 是否为精准搜索
@property (nonatomic,assign) BOOL isAccurateSearch;

/// 是否为搜索正在编辑状态（插入状态）
@property (nonatomic,assign) BOOL isEditingStatusSearch;


- (void) scrollToModel: (BaseJsonViewStepModel *)model;

@property (nonatomic,copy) void(^doubleClickCellBlock)(BaseJsonViewStepModel *model);
@property (nonatomic,copy) void(^longClickCellBlock)(BaseJsonViewStepModel *model);
@property (nonatomic,copy) void (^jumpNextLevelVc)(BaseJsonViewStepModel *model);
@property (nonatomic,copy) void(^clickBottomFoldLineButtonBlock)(BaseJsonViewStepModel *model);
- (void) openAll;
- (void) closeAll;
@end

NS_ASSUME_NONNULL_END
