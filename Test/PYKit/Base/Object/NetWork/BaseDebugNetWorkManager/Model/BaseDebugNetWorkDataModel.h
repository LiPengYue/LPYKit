//
//  BaseDebugNetWorkManager.h
//  PYKit
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    BaseDebugNetWorkDataModelType_Dictionary,
    BaseDebugNetWorkDataModelType_Array,
    BaseDebugNetWorkDataModelType_Number,
    BaseDebugNetWorkDataModelType_String,
} BaseDebugNetWorkDataModelType;

@interface BaseDebugNetWorkDataModel : NSObject
@property (nonatomic,assign) NSInteger level;
/// 当前需要显示item的个数
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,assign) BOOL isOpenNext;
@property (nonatomic,weak) BaseDebugNetWorkDataModel *superPoint;
@property (nonatomic,strong) id originData;
@property (nonatomic,strong) NSString *key;
@property (nonatomic,strong) id data;
@property (nonatomic,assign) BaseDebugNetWorkDataModelType type;

- (void) removeWithKey: (NSString *)key andModel: (BaseDebugNetWorkDataModel *)model;

- (void) removeFromeSuper;

- (void) reloadData: (id) data;

+ (instancetype) createWithDic: (NSDictionary *) dic;
+ (instancetype) createModelWithId: (id)obj;
+ (instancetype) nullData;

- (NSDictionary *) conversionToDic;

- (void) closeAll;
@end

NS_ASSUME_NONNULL_END
