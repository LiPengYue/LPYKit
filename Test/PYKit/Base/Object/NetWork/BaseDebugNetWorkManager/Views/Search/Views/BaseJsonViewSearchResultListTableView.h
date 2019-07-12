//
//  BaseJsonViewSearchResultListTableView.h
//  PYkit
//
//  Created by 衣二三 on 2019/7/5.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseJsonViewStepModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 展示搜索结果
@interface BaseJsonViewSearchResultListTableView : UITableView
@property (nonatomic,strong) NSArray <BaseJsonViewStepModel *>*modelArray;
@property (nonatomic,copy) void(^clickCellBlock)(BaseJsonViewStepModel *model);
 @property (nonatomic,strong) BaseJsonViewStepModel *currentSearchModel;
@end


@interface BaseJsonViewSearchResultListTableViewCell : UITableViewCell
@property (nonatomic,strong) NSAttributedString *titleStr;
+ (CGFloat) getHWithStr: (NSString *)str;
@property (nonatomic,assign) BOOL isCurrentSearch;
@end

NS_ASSUME_NONNULL_END
