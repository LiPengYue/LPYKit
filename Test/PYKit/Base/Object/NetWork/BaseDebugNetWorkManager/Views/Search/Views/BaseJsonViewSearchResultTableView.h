//
//  BaseJsonViewSearchResultTableView.h
//  PYkit
//
//  Created by 衣二三 on 2019/7/2.
//  Copyright © 2019 衣二三. All rights reserved.
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
