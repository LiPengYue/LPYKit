//
//  DebugNetWorkSearchViewController.h
//  PYkit
//
//  Created by 衣二三 on 2019/7/2.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import "BaseDebugNetWorkViewController.h"
#import "BaseDebugNetWorkDataStepModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DebugNetWorkSearchViewController : BaseDebugNetWorkViewController
@property (nonatomic,strong) NSArray <BaseDebugNetWorkDataStepModel *>*searchResult;
@property (nonatomic,strong) BaseDebugNetWorkDataStepModel *currentSearchModel;
@end

NS_ASSUME_NONNULL_END
