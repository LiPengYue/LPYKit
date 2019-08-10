//
//  BaseJsonViewManager.h
//  PYKit
//
//  Created by 李鹏跃 on 2019/9/11.
//  Copyright © 2019年 13lipengyue. All rights reserved.
//


#import "BaseJsonViewStepModel.h"

@class BaseJsonViewStepModel;
NS_ASSUME_NONNULL_BEGIN
/// 和UI有关的model
@interface BaseJsonViewStepUIModel : NSObject


+ (NSAttributedString *(^)(BaseJsonViewStepModel *))getTreeLayerAttriStrWithModel;

+ (NSString *(^)(BaseJsonViewStepModel *))getTreeLayerStringWithModel;

+ (NSString *(^)(BaseJsonViewStepModel *))getSuperPointKeyWithModel;
@end

NS_ASSUME_NONNULL_END
