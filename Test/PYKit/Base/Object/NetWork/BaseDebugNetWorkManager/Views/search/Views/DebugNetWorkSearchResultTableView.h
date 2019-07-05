//
//  DebugNetWorkSearchResultTableView.h
//  PYkit
//
//  Created by 衣二三 on 2019/7/5.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseDebugNetWorkDataStepModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 展示搜索结果
@interface DebugNetWorkSearchResultTableView : UITableView
@property (nonatomic,strong) NSArray <BaseDebugNetWorkDataStepModel *>*modelArray;
@property (nonatomic,copy) void(^clickCellBlock)(BaseDebugNetWorkDataStepModel *model);
 @property (nonatomic,strong) BaseDebugNetWorkDataStepModel *currentSearchModel;
@end


@interface DebugNetWorkSearchResultTableViewCell : UITableViewCell
@property (nonatomic,strong) NSAttributedString *titleStr;
+ (CGFloat) getHWithStr: (NSString *)str;
@property (nonatomic,assign) BOOL isCurrentSearch;
@end

NS_ASSUME_NONNULL_END
