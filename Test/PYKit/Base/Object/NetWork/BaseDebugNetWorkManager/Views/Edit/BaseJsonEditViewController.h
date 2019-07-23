//
//  BaseJsonEditViewController.h
//  PYkit
//
//  Created by 衣二三 on 2019/7/8.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseJsonViewStepModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseJsonEditViewController : BaseViewController

@property (nonatomic,strong) BaseJsonViewStepModel *originModel;
- (BaseJsonViewStepModel *) getChangedModel;
@end

NS_ASSUME_NONNULL_END
