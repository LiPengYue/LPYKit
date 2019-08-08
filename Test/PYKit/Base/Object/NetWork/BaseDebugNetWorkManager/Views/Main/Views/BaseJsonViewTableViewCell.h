//
//  BaseJsonViewManager.h
//  PYKit
//
//  Created by 李鹏跃 on 2019/9/11.
//  Copyright © 2019年 13lipengyue. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "BaseJsonViewStepModel.h"
#import "BaseJsonViewCommon.h"
NS_ASSUME_NONNULL_BEGIN

static NSString *const kBaseJsonViewTableViewCell_singleTapAction = @"kBaseJsonViewTableViewCell_singleTapAction";
static NSString *const kBaseJsonViewTableViewCell_doubleTapAction = @"kBaseJsonViewTableViewCell_doubleTapAction";

@interface BaseJsonViewTableViewCell : UITableViewCell

/// 应该是string或者是dic
@property (nonatomic,strong) BaseJsonViewStepModel *model;

/// 是否为搜索结果的cell，如果是则背景色变成
@property (nonatomic,assign) BOOL isSearchReslutCell;

- (void) setUpBackgroundColorWithIsSearchResultColor: (BOOL)iSearchResult andIsCurrentSearchResult: (BOOL) isCurrentSearchResult;

/// 单击事件
@property (nonatomic,copy) void(^singleTapBlock)(BaseJsonViewTableViewCell *cell, NSIndexPath *indexPath);

@property (nonatomic,copy) void(^longAction)(BaseJsonViewTableViewCell *cell, NSIndexPath *indexPath);

@property (nonatomic,copy) void(^doubleAction)(BaseJsonViewTableViewCell *cell, NSIndexPath *indexPath);

@property (nonatomic,copy) void(^clickBottomFoldLineButtonBlock)(BaseJsonViewTableViewCell *cell);

@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,assign) NSInteger levelOffset;


+ (CGFloat) getHeightWithModel: (BaseJsonViewStepModel *)model andLevelOffset: (NSInteger) levelOffset andLeftMaxW: (CGFloat) leftLabelMaxW andCellWidth: (CGFloat) cellW;
@end

NS_ASSUME_NONNULL_END
