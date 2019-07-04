//
//  BaseDebugNetWorkManager.h
//  PYKit
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BaseDebugNetWorkDataStepModel.h"
#import "BaseDebugNetWorkCommon.h"
NS_ASSUME_NONNULL_BEGIN

static NSString *const kDebugNetWorkTableViewCell_singleTapAction = @"kDebugNetWorkTableViewCell_singleTapAction";
static NSString *const kDebugNetWorkTableViewCell_doubleTapAction = @"kDebugNetWorkTableViewCell_doubleTapAction";

@interface DebugNetWorkTableViewCell : UITableViewCell

/// 应该是string或者是dic
@property (nonatomic,strong) BaseDebugNetWorkDataStepModel *model;

/// 是否为搜索结果的cell，如果是则背景色变成
@property (nonatomic,assign) BOOL isSearchReslutCell;

/// 单击事件
@property (nonatomic,copy) void(^singleTapBlock)(DebugNetWorkTableViewCell *cell, NSIndexPath *indexPath);

@property (nonatomic,strong) NSIndexPath *indexPath;
@end

NS_ASSUME_NONNULL_END
