//
//  BaseJsonViewManager.h
//  PYKit
//
//  Created by 李鹏跃 on 2019/9/11.
//  Copyright © 2019年 13lipengyue. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseJsonViewStepModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseJsonViewManager : NSObject

/// id 转成 step model
+ (BaseJsonViewStepModel *(^)(id)) convertToStepModelWithID;

/// 字典 转成 step model
+ (BaseJsonViewStepModel *(^)(NSDictionary *)) convertToStepModelWithDic;

/// json 转成 step model
+ (BaseJsonViewStepModel *(^)(NSString *)) convertToStepModelWithJson;


/// 转成 json
+ (NSString *(^)(NSDictionary *)) convertToJsonWithDic;

/// 转成 dic
+ (NSDictionary *(^)(NSString *)) convertToDicWithJson;
@end

NS_ASSUME_NONNULL_END
