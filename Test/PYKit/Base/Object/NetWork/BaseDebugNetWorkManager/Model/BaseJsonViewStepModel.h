//
//  BaseJsonViewManager.h
//  PYKit
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseJsonViewStepUIModel.h"
#import "BaseJsonViewStepErrorModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    BaseJsonViewStepModelType_Dictionary,
    BaseJsonViewStepModelType_Array,
    BaseJsonViewStepModelType_Number,
    BaseJsonViewStepModelType_String,
} BaseJsonViewStepModelType;

typedef enum : NSUInteger {
    BaseJsonViewStepCellStatus_Normal,
    BaseJsonViewStepCellStatus_EditingSelf,
    BaseJsonViewStepCellStatus_InsertItem,
} BaseJsonViewStepCellStatus;

@interface BaseJsonViewStepModel : NSObject
/// 创建一个空的 model
+ (instancetype) nullData;

/// 创建 一个model
+ (BaseJsonViewStepModel *(^)(id)) createWithID;

/// 创建 一个model
+ (BaseJsonViewStepModel *) createStepModelWithId: (id) data andKey: (NSString *)key;

/// 转成字典
- (NSDictionary *) conversionToDic;

/// 转成String
- (NSString *) conversionToJson;

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
 NSArray<BaseJsonViewStepModel>、
 BaseJsonViewStepModel
 
 会进行懒加载 内部调用的是`reloadDataWitOriginDataProperty`
 */
@property (nonatomic,strong) id data;

/**
 父节点
 在父节点创建子节点时，进行的赋值
 */
@property (nonatomic,weak) BaseJsonViewStepModel *superPoint;

@property (nonatomic,assign) BaseJsonViewStepModelType type;

- (void) removeWithKey: (NSString *)key andModel: (BaseJsonViewStepModel *)model;

- (void) removeFromeSuper;

- (BaseJsonViewStepErrorModel *) insertWithKey: (NSString *)key
         andOriginData: (id) originData
              andIndex:(NSInteger) index;

- (BaseJsonViewStepErrorModel *) insertWithKey: (NSString *)key
              andModel: (BaseJsonViewStepModel *) model
              andIndex:(NSInteger) index;

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
- (NSArray <BaseJsonViewStepModel *>*) faltSelfDataIfOpen;

/// 到self的视图结构
- (NSString *) getTreeLayer;

/// 到self的视图结构
- (NSAttributedString *)getTreeLayerAttriStr;

/// 返回一个父节点的key，如果父节点的key为nil，那么继续向上查找
- (NSString *) getSuperPointKey;

/// 打开 right 折行 如果最大行高不足以显示right信息的时候
@property (nonatomic,assign) BOOL isOpenFoldLine;
/// 是否需要显示折行按钮
@property (nonatomic,assign) BOOL isShowFoldLineButton;

/// 编辑状态
@property (nonatomic,assign) BaseJsonViewStepCellStatus status;

///
- (BOOL) isEqualToKeyAndOriginDataWithModel: (BaseJsonViewStepModel *)model;
@end

NS_ASSUME_NONNULL_END
