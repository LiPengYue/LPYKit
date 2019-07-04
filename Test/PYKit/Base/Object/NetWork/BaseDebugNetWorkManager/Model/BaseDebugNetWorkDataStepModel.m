//
//  BaseDebugNetWorkManager.h
//  PYKit
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//


#import "BaseDebugNetWorkDataStepModel.h"
#import "BaseStringHandler.h"
#import "BaseDebugNetWorkManager.h"
@implementation BaseDebugNetWorkDataStepModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _isOpen = false;
        _key = @"";
    }
    return self;
}

/// id 转成 step model
+ (BaseDebugNetWorkDataStepModel *(^)(id)) createWithID {
    return ^(id data) {
        BaseDebugNetWorkDataStepModel *model;
        
        if ([data isKindOfClass:NSString.class]) {
            NSDictionary *dic = BaseDebugNetWorkManager.convertToDicWithJson(data);
            if (dic) {
                model = BaseDebugNetWorkManager.convertToStepModelWithDic(dic);
            }
        }
        
        if (!model) {
            model = [BaseDebugNetWorkDataStepModel createStepModelWithId:data andKey:@""];
        }
        return model;
    };
}

+ (BaseDebugNetWorkDataStepModel *) createStepModelWithId: (id) data andKey: (NSString *)key{
    BaseDebugNetWorkDataStepModel *model = [BaseDebugNetWorkDataStepModel new];
    model.originData = data;
    model.key = key;
    [model reloadDataWitOriginDataProperty];
    return model;
}

+ (instancetype) nullData {
    BaseDebugNetWorkDataStepModel *model = [BaseDebugNetWorkDataStepModel new];
    model.isOpen = false;
    model.key = @"🌶 没有数据";
    return model;
}


- (void) closeAll {
    self.isOpen = false;
    if ([self.data isKindOfClass:NSArray.class]) {
        NSArray *array = self.data;
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:BaseDebugNetWorkDataStepModel.class]) {
                BaseDebugNetWorkDataStepModel *model = obj;
                [model closeAll];
                
            }
        }];
    } else if([self.data isKindOfClass:BaseDebugNetWorkDataStepModel.class]) {
        BaseDebugNetWorkDataStepModel *model = self.data;
        model.isOpen = false;
    }else if ([self.data isKindOfClass:NSString.class]) {
    }else {
    }
}

- (void)openAll {
    self.isOpen = true;
    if ([self.data isKindOfClass:NSArray.class]) {
        NSArray *array = self.data;
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:BaseDebugNetWorkDataStepModel.class]) {
                [obj openAll];
            }
        }];
    } else if([self.data isKindOfClass:BaseDebugNetWorkDataStepModel.class]) {
        BaseDebugNetWorkDataStepModel *model = self.data;
        [model isOpen];
    }else if ([self.data isKindOfClass:NSString.class]) {
    }else {
    }
}

- (NSInteger) count {
    if (_count <= 0) {
        _count = [self getCount:0];
    }
    return _count;
}

- (NSInteger) getCount: (NSInteger) count {
    __block NSInteger tempCount = count;
    
    if ([self.data isKindOfClass:NSArray.class]) {
        NSArray *array = self.data;
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:BaseDebugNetWorkDataStepModel.class]) {
                tempCount+=1;
            }
        }];
    } else if([self.data isKindOfClass:BaseDebugNetWorkDataStepModel.class]) {
        tempCount+=1;
    }else if ([self.data isKindOfClass:NSString.class]) {
    }else {
    }
    return tempCount;
}

- (void) removeWithKey: (NSString *)key andModel: (BaseDebugNetWorkDataStepModel *)model {
    switch (self.type) {
            
        case BaseDebugNetWorkDataModelType_Dictionary:
        case BaseDebugNetWorkDataModelType_Array:
            if([self.data isKindOfClass:NSArray.class]) {
                NSArray *array = (NSArray *)self.data;
                NSMutableArray *arrayM = array.mutableCopy;
                [arrayM removeObject:model];
                self.data = arrayM;
            }
            break;
        case BaseDebugNetWorkDataStepModelType_Number:
            break;
        case BaseDebugNetWorkDataStepModelType_String:
            break;
    }
    
}

- (void) removeFromeSuper {
    [self.superPoint removeWithKey:self.key andModel:self];
}

- (id) toDicWithKey: (NSString *)key andDic: (NSMutableDictionary *)dictionary {
    id value;
    NSMutableDictionary *dicM = [NSMutableDictionary new];
    if ([self.data isKindOfClass:NSArray.class]) {
        NSArray *array = self.data;
        NSMutableArray *arrayM = [[NSMutableArray alloc]initWithCapacity:array.count];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:BaseDebugNetWorkDataStepModel.class]) {
                BaseDebugNetWorkDataStepModel *model = obj;
                [arrayM addObject: [model toDicWithKey:self.key andDic:dicM]];
            }
        }];
        value = arrayM.copy;
    } else if([self.data isKindOfClass:BaseDebugNetWorkDataStepModel.class]) {
        BaseDebugNetWorkDataStepModel *model = self.data;
        value = [model toDicWithKey:self.key andDic:dicM];
    }else if ([self.data isKindOfClass:NSString.class]) {
        if (self.type == BaseDebugNetWorkDataStepModelType_Number) {
            NSString *numberStr = self.data;
            BOOL isNumber = BaseStringHandler.handler(numberStr).isNumber;
            if (isNumber) {
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = NSNumberFormatterDecimalStyle;
                value = [formatter numberFromString:numberStr];
            } else {
                value = numberStr;
            }
        }else{
            value = self.data;
        }
    }else {
        value = [NSString stringWithFormat:@"%@",self.data];
    }
    if (self.key.length <= 0 && key.length > 0) {
        dictionary[key] = value;
    }else if (key.length > 0 && self.key.length > 0){
        dicM[self.key] = value;
        dictionary[key] = dicM;
    }else if (key.length <= 0 && self.key.length > 0){
        dictionary[self.key] = value;
    }
    return dicM;
}

- (NSDictionary *) conversionToDic {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic = [self toDicWithKey:self.key andDic:dic];
    return dic;
}


- (void) reloadDataWitOriginDataProperty {
    
    NSInteger level = self.level;
    id obj = self.originData;

    if ([obj isKindOfClass:NSArray.class]) {
        self.type = BaseDebugNetWorkDataStepModelType_Array;
        NSArray *array = obj;
        NSMutableArray *arrayM = [[NSMutableArray alloc]initWithCapacity:array.count];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BaseDebugNetWorkDataStepModel *model = [BaseDebugNetWorkDataStepModel new];
            model.superPoint = self;
            model.originData = obj;
            model.level = level+1;
            [arrayM addObject:model];
        }];
        _data = arrayM;
        
    } else if ([obj isKindOfClass:NSDictionary.class]){
        NSDictionary *dic = obj;
        NSMutableArray *arrayM = [[NSMutableArray alloc] initWithCapacity:dic.count];
        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            BaseDebugNetWorkDataStepModel *model = [BaseDebugNetWorkDataStepModel new];
            model.originData = obj;
            model.superPoint = self;
            model.key = key;
            [model setupType];
            model.level = level+1;
            [arrayM addObject:model];
        }];
        _data = arrayM;
        
    }else if ([obj isKindOfClass:NSNumber.class]){
        _data = [NSString stringWithFormat:@"%@",obj];
        self.type = BaseDebugNetWorkDataStepModelType_Number;
        
    }else if ([obj isKindOfClass:NSString.class]) {
        _data = [NSString stringWithFormat:@"%@",obj];
        self.type = BaseDebugNetWorkDataStepModelType_String;
        
    } else {
        _data = [BaseDebugNetWorkDataStepModel nullData];
    }
}

- (BaseDebugNetWorkDataStepModel *) createWithDic: (NSDictionary *) dic {
    BaseDebugNetWorkDataStepModel *model1 = [BaseDebugNetWorkDataStepModel new];
    
    NSMutableArray <BaseDebugNetWorkDataStepModel *>*array = [[NSMutableArray alloc] initWithCapacity:dic.count];
    
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        BaseDebugNetWorkDataStepModel *model;
        model.superPoint = model1;
        model.key = key;
        [array addObject:model];
    }];
    return model1;
}

- (void) setupType {
    id obj = self.originData;
    if ([obj isKindOfClass:NSArray.class]) {
        self.type = BaseDebugNetWorkDataStepModelType_Array;
    } else if ([obj isKindOfClass:NSDictionary.class]){
        self.type = BaseDebugNetWorkDataStepModelType_Dictionary;
    }else if ([obj isKindOfClass:NSNumber.class]){
        self.type = BaseDebugNetWorkDataStepModelType_Number;
        
    }else if ([obj isKindOfClass:NSString.class]) {
        self.type = BaseDebugNetWorkDataStepModelType_String;
        
    }
}

- (NSArray<BaseDebugNetWorkDataStepModel *> *)faltSelfDataIfOpen {
    NSMutableArray *array = [NSMutableArray new];
    [self faltSelfDataIfOpenWithModelArray:array];
    return array;
}

- (void)faltSelfDataIfOpenWithModelArray: (NSMutableArray <BaseDebugNetWorkDataStepModel *>*) modelArray{
    if (!self.data) {
        [self reloadDataWitOriginDataProperty];
    }
    
    if ([self.data isKindOfClass:NSArray.class]) {
        NSArray *array = self.data;
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj isKindOfClass:BaseDebugNetWorkDataStepModel.class]){
                BaseDebugNetWorkDataStepModel *model = obj;
                if(model.isOpen) {
                    [modelArray addObject:model];
                    [model faltSelfDataIfOpenWithModelArray:modelArray];
                }else{
                    if (!model.data) {
                        [model reloadDataWitOriginDataProperty];
                    }
                    [modelArray addObject:obj];
                }
            }
        }];
    }
}

// MARK: get && set
- (id)data {
    if (!_data && self.originData) {
        [self reloadDataWitOriginDataProperty];
    }
    return _data;
}

- (void)setIsOpen:(BOOL)isOpen {
    _isOpen = isOpen;
    _count = [self getCount:0];
}

@end
