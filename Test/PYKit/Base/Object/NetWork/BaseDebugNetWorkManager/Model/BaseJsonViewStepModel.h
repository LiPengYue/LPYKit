//
//  BaseJsonViewManager.h
//  PYKit
//
//  Created by 李鹏跃 on 2019/9/11.
//  Copyright © 2019年 13lipengyue. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BaseJsonViewStepUIModel.h"
#import "BaseJsonViewStepErrorModel.h"
#import "BaseJsonViewStepSearchModel.h"



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


/**
 创建 一个model

 @param data 原始的子节点数据
 @param key 创建出的model对应的key
 @return model
 */
+ (BaseJsonViewStepModel *) createStepModelWithOriginData: (id) data andKey: (NSString *)key;

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

/// 类型
@property (nonatomic,assign) BaseJsonViewStepModelType type;

/// 编辑状态
@property (nonatomic,assign) BaseJsonViewStepCellStatus status;


/**
 插入一个节点

 @param key 节点的key
 @param originData 节点的原始子节点y数据
 @param index 插入的位置
 @return 插入报错的model
 */
- (BaseJsonViewStepErrorModel *) insertWithKey: (NSString *)key
         andOriginData: (id) originData
              andIndex:(NSInteger) index;


/**
 插入一个Model

 @param model 准备插入的 节点 model
 @param index 插入的位置
 @return 错误信息
 */
- (BaseJsonViewStepErrorModel *) insertWithModel: (BaseJsonViewStepModel *) model
                                        andIndex:(NSInteger) index;


/// 从父节点移除本节点
- (void) removeFromeSuper;


/**
 搜索

 @param key 搜索 关键字
 @param isAccurateSearch 是否为精准搜索（如果选中精准搜索，搜索策略将从`containsString` 变成 `isEqualToString`。不管是否为精准搜索，都区分大小写）
 @param isSearchEditing 是否搜索正在编辑状态的model
 @return 搜索结果
 */
- (NSMutableArray <BaseJsonViewStepModel *>*) searchWithKey:(NSString *)key andIsAccurateSearch: (BOOL) isAccurateSearch andIsSearchEditing:(BOOL) isSearchEditing;

/// 关闭所有子节点
- (void) closeAll;

/// 打开所有子节点
- (void) openAll;

/// 打开被标记为 BaseJsonViewStepCellStatus_Normal 的节点
- (void) openAllNormalStatus;

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

/**
 平铺 self.data
 
 获取到所有的子节点数据，不管是否打开
 */
- (NSArray <BaseJsonViewStepModel *>*) faltSelfData;

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


/**
 两个model的 原始的子节点数据 且 key 是否都相等

 @param model 比较的model
 @return 是否相等
 */
- (BOOL) isEqualToKeyAndOriginDataWithModel: (BaseJsonViewStepModel *)model;
@end

NS_ASSUME_NONNULL_END
