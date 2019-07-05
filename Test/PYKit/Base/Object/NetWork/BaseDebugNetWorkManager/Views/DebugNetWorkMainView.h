//
//  DebugNetWorkMainView.h
//  PYkit
//
//  Created by 衣二三 on 2019/7/1.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseDebugNetWorkDataStepModel.h"
#import "DebugNetWorkTableView.h"

NS_ASSUME_NONNULL_BEGIN
/// 索引功能
@interface DebugNetWorkMainView : UIView

/// 收起根节点时，是否自动收起子节点
@property (nonatomic,assign) BOOL isCloseChildPointWhenCloseSelf;

/// data 可以为数组、字典、json、或 oc string
- (void) reloadWithData:(id) data;

/// 当调用 reloadWithData 后 才会有数据
- (BaseDebugNetWorkDataStepModel *) getCurrentModel;

/// 对data转化成json
@property (nonatomic,readonly,copy) NSString *jsonStr;

/// 查找
@property (nonatomic,copy) BaseDebugNetWorkDataModel *(^searchBlock)(NSString *searchKey);

@property (nonatomic,strong) DebugNetWorkTableView *tableView;

@property (nonatomic,assign) BOOL isAccurateSearch;

- (void) scrollToModel: (BaseDebugNetWorkDataStepModel *)model;
@end

NS_ASSUME_NONNULL_END
