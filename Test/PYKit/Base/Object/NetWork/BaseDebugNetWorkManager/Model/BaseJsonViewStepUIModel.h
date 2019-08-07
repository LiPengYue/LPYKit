//
//  BaseJsonViewStepUIModel.h
//  PYkit
//
//  Created by 衣二三 on 2019/7/24.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import "BaseJsonViewStepModel.h"
NS_ASSUME_NONNULL_BEGIN
/// 和UI有关的model
@interface BaseJsonViewStepUIModel : NSObject
/// 是否展开
@property (nonatomic,assign) BOOL isUnfoldLine;
/// 是否需要显示折行按钮
@property (nonatomic,assign) BOOL isOverflow;
@end

NS_ASSUME_NONNULL_END
