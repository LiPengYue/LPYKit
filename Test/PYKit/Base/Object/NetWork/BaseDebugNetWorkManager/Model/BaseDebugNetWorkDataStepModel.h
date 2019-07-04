//
//  BaseDebugNetWorkManager.h
//  PYKit
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import "BaseDebugNetWorkDataModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    BaseDebugNetWorkDataStepModelType_Dictionary,
    BaseDebugNetWorkDataStepModelType_Array,
    BaseDebugNetWorkDataStepModelType_Number,
    BaseDebugNetWorkDataStepModelType_String,
} BaseDebugNetWorkDataStepModelType;


@interface BaseDebugNetWorkDataStepModel : NSObject
/// 创建一个空的 model
+ (instancetype) nullData;

/// 创建 一个model
+ (BaseDebugNetWorkDataStepModel *(^)(id)) createWithID;

/// 创建 一个model
+ (BaseDebugNetWorkDataStepModel *) createStepModelWithId: (id) data andKey: (NSString *)key;

/// 转成字典
- (NSDictionary *) conversionToDic;

/// 所处层级
@property (nonatomic,assign) NSInteger level;

/// 当前需要显示item的个数
@property (nonatomic,assign) NSInteger count;

/**
 * 是否为打开状态
 */
@property (nonatomic,assign) BOOL isOpen;

/**
 原始数据
 */
@property (nonatomic,strong) id originData;

/**
  如果originData为字典，则key就是originData的key
 */
@property (nonatomic,strong) NSString *key;

/**
 originData 转化成的数据
 
 可能的类型为
 NSString、
 NSArray<BaseDebugNetWorkDataStepModel>、
 BaseDebugNetWorkDataStepModel
 
 会进行懒加载 内部调用的是`reloadDataWitOriginDataProperty`
 */
@property (nonatomic,strong) id data;

/**
 父节点
 在父节点创建子节点时，进行的赋值
 */
@property (nonatomic,weak) BaseDebugNetWorkDataStepModel *superPoint;

@property (nonatomic,assign) BaseDebugNetWorkDataStepModelType type;

- (void) removeWithKey: (NSString *)key andModel: (BaseDebugNetWorkDataStepModel *)model;

- (void) removeFromeSuper;

/// 关闭所有子节点
- (void) closeAll;

/// 打开所有子节点
- (void) openAll;

/**
 重新创建self.data
 
 子节点全部为关闭状态
 */
- (void) reloadDataWitOriginDataProperty;

/**
 平铺 self.data
 
 把 子节点（isOpen == true）放到一个数组中
 */
- (NSArray <BaseDebugNetWorkDataStepModel *>*) faltSelfDataIfOpen;

@end

NS_ASSUME_NONNULL_END
