//
//  BaseJsonViewManager.h
//  PYKit
//
//  Created by 李鹏跃 on 2019/9/11.
//  Copyright © 2019年 13lipengyue. All rights reserved.
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
