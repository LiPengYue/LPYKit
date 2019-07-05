//
//  DebugNetWorkSearchResultViewController.h
//  PYkit
//
//  Created by 衣二三 on 2019/7/5.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseDebugNetWorkDataStepModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DebugNetWorkSearchResultViewController : BaseViewController
@property (nonatomic,strong) NSString *searchKey;
@property (nonatomic,strong) NSArray <BaseDebugNetWorkDataStepModel *>*modelArray;
@property (nonatomic,strong) BaseDebugNetWorkDataStepModel *currentSearchModel;
@property (nonatomic,copy) void(^clickCellBlock)(BaseDebugNetWorkDataStepModel *model);
@end

NS_ASSUME_NONNULL_END
