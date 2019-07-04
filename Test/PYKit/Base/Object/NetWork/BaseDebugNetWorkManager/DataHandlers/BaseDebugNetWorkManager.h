//
//  BaseDebugNetWorkManager.h
//  PYKit
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDebugNetWorkDataModel.h"
#import "BaseDebugNetWorkDataStepModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseDebugNetWorkManager : NSObject

/// id 转成 step model
+ (BaseDebugNetWorkDataStepModel *(^)(id)) convertToStepModelWithID;

/// 字典 转成 step model
+ (BaseDebugNetWorkDataStepModel *(^)(NSDictionary *)) convertToStepModelWithDic;

/// json 转成 step model
+ (BaseDebugNetWorkDataStepModel *(^)(NSString *)) convertToStepModelWithJson;


// 转成 model 对应的子节点已经全部赋值成功
+ (BaseDebugNetWorkDataModel *(^)(NSDictionary *)) convertToModelWithDic;
// 转成 model 对应的子节点已经全部赋值成功
+ (BaseDebugNetWorkDataModel *(^)(NSString *)) convertToModelWithJson;


/// 转成 json
+ (NSString *(^)(NSDictionary *)) convertToJsonWithDic;
+ (NSString *(^)(BaseDebugNetWorkDataModel *)) convertToJsonWithModel;

/// 转成 dic
+ (NSDictionary *(^)(NSString *)) convertToDicWithJson;
+ (NSDictionary *(^)(NSString *)) convertToDicWithModel;


@end

NS_ASSUME_NONNULL_END
