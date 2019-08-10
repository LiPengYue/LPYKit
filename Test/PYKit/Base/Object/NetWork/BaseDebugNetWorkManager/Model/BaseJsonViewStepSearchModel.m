//
//  BaseJsonViewStepSearchModel.m
//  PYkit
//
//  Created by 衣二三 on 2019/8/10.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import "BaseJsonViewStepSearchModel.h"
#import "BaseJsonViewStepModel.h"

@implementation BaseJsonViewStepSearchModel

+ (NSMutableArray <BaseJsonViewStepModel *>*(^)(SBaseJsonViewStepSearchModelConfig)) getResultWithSearchConfig {
    return ^(SBaseJsonViewStepSearchModelConfig config) {
        BaseJsonViewStepModel *model = config.model;
        NSString *key = config.key;
        BOOL isEditingStatusSearch = config.isSearchEditing;
        
        NSMutableArray <BaseJsonViewStepModel *>*modelArray;
        
        switch (model.type) {
            case BaseJsonViewStepModelType_Dictionary:
            case BaseJsonViewStepModelType_Array:
                modelArray = [model faltSelfData].mutableCopy;
                break;
            case BaseJsonViewStepModelType_Number:
            case BaseJsonViewStepModelType_String:
                modelArray = [NSMutableArray new];
                [modelArray addObject:model];
                break;
        }
        
        NSMutableArray <BaseJsonViewStepModel *>*arrayM = [NSMutableArray new];
        if (key.length > 0 || isEditingStatusSearch) {
            [modelArray enumerateObjectsUsingBlock:^(BaseJsonViewStepModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                BOOL isSearchModel = [self isSearchDataWithModel:obj andKey:key andConfig:config];
                if (isSearchModel) {
                    [arrayM addObject:obj];
                }
            }];
        }
        
        [arrayM enumerateObjectsUsingBlock:^(BaseJsonViewStepModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BaseJsonViewStepModel *model = obj;
            obj.isOpen = true;
            while (model.superPoint) {
                model.isOpen = true;
                model = model.superPoint;
            }
        }];
        return arrayM;
    };
}

+ (BOOL) isSearchDataWithModel: (BaseJsonViewStepModel *) model andKey: (NSString *)key andConfig: (SBaseJsonViewStepSearchModelConfig) config {
    BOOL isAccurateSearch = config.isAccurateSearch;
    BOOL isSearchEditing = config.isSearchEditing;
    
    BOOL isTrue = isAccurateSearch ? [model.key isEqualToString:key]: [model.key containsString:key];
    if (!isTrue && [model.data isKindOfClass:NSString.class]) {
        NSString *data = model.data;
        isTrue = isAccurateSearch ? [data isEqualToString:key]: [data containsString:key];
    }
    
    if (isSearchEditing) {
        switch (model.status) {
            case BaseJsonViewStepCellStatus_Normal:
                isTrue = false;
                break;
            case BaseJsonViewStepCellStatus_EditingSelf:
            case BaseJsonViewStepCellStatus_InsertItem:
                if (key.length <= 0) {
                    isTrue = true;
                }else{
                    isTrue = isTrue;
                }
                break;
        }
    }
    return isTrue;
}

@end
