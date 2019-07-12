//
//  BaseJsonViewManager.h
//  PYKit
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BaseJsonViewManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface BaseJsonViewTableView : UITableView
/// 里面应该放的是字典 或者字符串
@property (nonatomic,strong) BaseJsonViewStepModel *model;
@property (nonatomic,assign) BOOL isAutoClose;


- (NSMutableArray <BaseJsonViewStepModel *>*) searchAndOpenAllWithKey: (NSString *)key;

@property (nonatomic,assign) BOOL isAccurateSearch;

- (void) scrollToModel: (BaseJsonViewStepModel *)model;

@property (nonatomic,copy) void(^doubleClickCellBlock)(BaseJsonViewStepModel *model);
@end

NS_ASSUME_NONNULL_END
