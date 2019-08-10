//
//  BaseJsonViewStepSearchModel.h
//  PYkit
//
//  Created by 衣二三 on 2019/8/10.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class BaseJsonViewStepModel;

struct SBaseJsonViewStepSearchModelConfig {
    BaseJsonViewStepModel *model;
    BOOL isAccurateSearch;
    BOOL isSearchEditing;
    NSString *key;
};

typedef struct SBaseJsonViewStepSearchModelConfig SBaseJsonViewStepSearchModelConfig;

@interface BaseJsonViewStepSearchModel : NSObject

+ (NSMutableArray <BaseJsonViewStepModel *>*(^)(SBaseJsonViewStepSearchModelConfig)) getResultWithSearchConfig;
@end

NS_ASSUME_NONNULL_END
