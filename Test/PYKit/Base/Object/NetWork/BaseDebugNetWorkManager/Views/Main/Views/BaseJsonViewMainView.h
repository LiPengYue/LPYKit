//
//  BaseJsonViewMainView.h
//  PYkit
//
//  Created by 衣二三 on 2019/7/1.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseJsonViewStepModel.h"
#import "BaseJsonViewTableView.h"

NS_ASSUME_NONNULL_BEGIN
/// 索引功能
@interface BaseJsonViewMainView : UIView

/// 收起根节点时，是否自动收起子节点
@property (nonatomic,assign) BOOL isCloseChildPointWhenCloseSelf;

/// data 可以为数组、字典、json、或 oc string
- (void) reloadWithData:(id) data;

/// 当调用 reloadWithData 后 才会有数据
- (BaseJsonViewStepModel *) getCurrentModel;

/// 对data转化成json
@property (nonatomic,readonly,copy) NSString *jsonStr;


@property (nonatomic,strong) BaseJsonViewTableView *tableView;

@property (nonatomic,assign) BOOL isAccurateSearch;

- (void) scrollToModel: (BaseJsonViewStepModel *)model;

@property (nonatomic,copy) void(^doubleClickCellBlock)(BaseJsonViewStepModel *model);
@property (nonatomic,copy) void(^longClickCellBlock)(BaseJsonViewStepModel *model);
@property (nonatomic,copy) void (^jumpNextLevelVc)(BaseJsonViewStepModel *model);

@property (nonatomic,assign) NSInteger currentLevelOffset;

- (void) openAll;
- (void) closeAll;
@end

NS_ASSUME_NONNULL_END
