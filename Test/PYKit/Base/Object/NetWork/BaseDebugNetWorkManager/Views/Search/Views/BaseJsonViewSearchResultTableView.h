//
//  BaseJsonViewManager.h
//  PYKit
//
//  Created by 李鹏跃 on 2019/9/11.
//  Copyright © 2019年 13lipengyue. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BaseTableView.h"
#import "BaseJsonViewStepModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseJsonViewSearchResultTableView : BaseTableView
@property (nonatomic,assign) BOOL isAutoClose;
@property (nonatomic,assign) BOOL isAccurateSearch;
@property (nonatomic,strong) NSArray <BaseJsonViewStepModel *>*modelArray;
@end

NS_ASSUME_NONNULL_END
