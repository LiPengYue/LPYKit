//
//  DebugNetWorkSearchResultViewController.h
//  PYkit
//
//  Created by 衣二三 on 2019/7/5.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseJsonViewStepModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseJsonViewSearchResultViewController : BaseViewController
@property (nonatomic,strong) NSString *searchKey;
@property (nonatomic,strong) NSArray <BaseJsonViewStepModel *>*modelArray;
@property (nonatomic,strong) BaseJsonViewStepModel *currentSearchModel;
@property (nonatomic,copy) void(^clickCellBlock)(BaseJsonViewStepModel *model);
@end

NS_ASSUME_NONNULL_END
