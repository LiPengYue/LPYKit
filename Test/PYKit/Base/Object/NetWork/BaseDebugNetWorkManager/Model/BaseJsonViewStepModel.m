//
//  BaseJsonViewManager.h
//  PYKit
//
//  Created by 李鹏跃 on 2019/9/11.
//  Copyright © 2019年 13lipengyue. All rights reserved.
//


#import "BaseJsonViewStepModel.h"
#import "BaseJsonViewCommon.h"
#import "BaseStringHandler.h"
#import "BaseAttriButedStrHandler+ChangeStyle.h"
#import "BaseJsonViewManager.h"
@implementation BaseJsonViewStepModel
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
+ (BaseJsonViewStepModel *(^)(id)) createWithID {
    return ^(id data) {
        BaseJsonViewStepModel *model;
        if ([data isKindOfClass:BaseJsonViewStepModel.class]) {
            model = data;
        }
        if ([data isKindOfClass:NSString.class]) {
            NSDictionary *dic = BaseJsonViewManager.convertToDicWithJson(data);
            if (dic) {
                model = BaseJsonViewManager.convertToStepModelWithDic(dic);
            }
        }
        if (!model) {
            model = [BaseJsonViewStepModel createStepModelWithOriginData:data andKey:@""];
        }
        return model;
    };
}

+ (BaseJsonViewStepModel *) createStepModelWithOriginData: (id) data andKey: (NSString *)key{
    BaseJsonViewStepModel *model = [BaseJsonViewStepModel new];
    model.originData = data;
    model.key = key;
    return model;
}

+ (instancetype) nullData {
    BaseJsonViewStepModel *model = [BaseJsonViewStepModel new];
    model.isOpen = false;
    model.key = @"🌶 没有数据";
    return model;
}

- (NSMutableArray <BaseJsonViewStepModel *>*) searchWithKey:(NSString *)key andIsAccurateSearch: (BOOL) isAccurateSearch andIsSearchEditing:(BOOL) isSearchEditing {
    SBaseJsonViewStepSearchModelConfig config;
    config.isSearchEditing = isSearchEditing;
    config.isAccurateSearch = isAccurateSearch;
    config.key = key;
    config.model = self;
    return BaseJsonViewStepSearchModel.getResultWithSearchConfig(config);
}

- (void) closeAll {
    self.isOpen = false;
    if ([self.data isKindOfClass:NSArray.class]) {
        NSArray *array = self.data;
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:BaseJsonViewStepModel.class]) {
                BaseJsonViewStepModel *model = obj;
                [model closeAll];
                
            }
        }];
    } else if([self.data isKindOfClass:BaseJsonViewStepModel.class]) {
        BaseJsonViewStepModel *model = self.data;
        model.isOpen = false;
    }else if ([self.data isKindOfClass:NSString.class]) {
    }else {
    }
}

- (void) openAllNormalStatus {
    self.isOpen = true;
    switch (self.status) {

        case BaseJsonViewStepCellStatus_Normal:
            self.isOpen = true;
            break;
        case BaseJsonViewStepCellStatus_EditingSelf:
            self.isOpen = false;
            break;
        case BaseJsonViewStepCellStatus_InsertItem:
            self.isOpen = false;
            break;
    }
    if ([self.data isKindOfClass:NSArray.class]) {
        NSArray *array = self.data;
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:BaseJsonViewStepModel.class]) {
                [obj openAllNormalStatus];
            }
        }];
    } else if([self.data isKindOfClass:BaseJsonViewStepModel.class]) {
        BaseJsonViewStepModel *model = self.data;
        [model openAllNormalStatus];
    }else if ([self.data isKindOfClass:NSString.class]) {
    }else {
    }
}

- (void)openAll {
    self.isOpen = true;
    if ([self.data isKindOfClass:NSArray.class]) {
        NSArray *array = self.data;
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:BaseJsonViewStepModel.class]) {
                [obj openAll];
            }
        }];
    } else if([self.data isKindOfClass:BaseJsonViewStepModel.class]) {
        BaseJsonViewStepModel *model = self.data;
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
    
    if ([_data isKindOfClass:NSArray.class]) {
        NSArray *array = _data;
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:BaseJsonViewStepModel.class]) {
                tempCount+=1;
            }
        }];
    } else if([_data isKindOfClass:BaseJsonViewStepModel.class]) {
        tempCount+=1;
    }else if ([_data isKindOfClass:NSString.class]) {
    }else {
    }
    return tempCount;
}

- (void) removeFromeSuper {

    if ([self.superPoint.originData isKindOfClass:NSArray.class]) {
        NSArray *array = self.superPoint.originData;
        NSMutableArray *arrayM = [[NSMutableArray alloc]initWithArray:array];
        [arrayM removeObject:self.originData];
        self.superPoint.originData = arrayM;
    }
    if ([self.superPoint.originData isKindOfClass:NSDictionary.class]) {
        NSDictionary *dic = self.superPoint.originData;
        NSMutableDictionary *dicM = [[NSMutableDictionary alloc]initWithDictionary:dic];
        NSString *key = self.key;
        if (key.length > 0) {
            dicM[self.key] = nil;
        }
        self.superPoint.originData = dicM;
    }
    
    [self.superPoint reloadDataWitOriginDataProperty];
}

- (BaseJsonViewStepErrorModel *) insertWithKey: (NSString *)key
         andOriginData: (id) originData
              andIndex: (NSInteger) index {
    
    BaseJsonViewStepModel *model = BaseJsonViewStepModel.createWithID(originData);
    if (model.key.length <= 0) {
        model.key = key;
    }
    BaseJsonViewStepErrorModel *error = [self insertWithModel:model andIndex:index];
    return error;
}

- (BaseJsonViewStepErrorModel *) insertWithModel: (BaseJsonViewStepModel *) model
              andIndex:(NSInteger) index {
    
    BaseJsonViewStepErrorModel *error = [BaseJsonViewStepErrorModel new];
    switch (self.type) {
            
        case BaseJsonViewStepModelType_Dictionary:
            error = [self dictionaryInsertWithModel:model andIndex:index];
            break;
        case BaseJsonViewStepModelType_Array:
            
            error = [self arrayInsertWitModel:model andIndex:index]; 
            break;
        case BaseJsonViewStepModelType_Number:
            error.errorMessage = @"🌶 类型错误，标记为《BaseJsonViewStepModelType_Number》类型的数据，不能插入数据";
            error.code = BaseJsonViewStepTypeErrorCode404;
            break;
        case BaseJsonViewStepModelType_String:
            error.errorMessage = @"🌶 类型错误，标记为《BaseJsonViewStepModelType_String》类型的数据，不能插入数据";
            error.code = BaseJsonViewStepTypeErrorCode404;
            break;
    }
    [self reloadDataWitOriginDataProperty];
    return error;
}

- (BaseJsonViewStepErrorModel *) arrayInsertWitModel: (BaseJsonViewStepModel *) model andIndex:(NSInteger) index {
    
    BaseJsonViewStepErrorModel *error = [BaseJsonViewStepErrorModel new];
    NSString *originDataClassStr = NSStringFromClass([self.originData class]);
    if (model.key.length > 0) {
        error.errorMessage = @"🌶：数组内部 插入的第一层子对象不能含有key";
        error.code = BaseJsonViewStepTypeErrorCode404;
        return error;
    }
    if ([self.originData isKindOfClass:NSArray.class]) {
        id modelDataAny = model.originData;
        if (modelDataAny) {
            NSMutableArray *selfDataArrayM = ((NSMutableArray *)self.originData);
            if (![selfDataArrayM isKindOfClass:NSMutableArray.class]) {
                selfDataArrayM = ((NSArray *)self.originData).mutableCopy;
            }
            [selfDataArrayM insertObject:modelDataAny atIndex:index];
            self.originData = selfDataArrayM;
        }
    }else {
        error.errorMessage = [NSString stringWithFormat: @"🌶 类型错误，标记为《BaseJsonViewStepModelType_Array》类型的数据实际为：%@",originDataClassStr];
        error.code = BaseJsonViewStepTypeErrorCode404;
    }
    return error;
}

- (void) insertDataIfNeededWithIndex:(NSInteger)idx andModel:(BaseJsonViewStepModel *)model {
    NSArray *data = self.data;
    if ([data isKindOfClass:NSArray.class]) {
        NSMutableArray *dataM = (NSMutableArray *)data;
        if (![data isKindOfClass:NSMutableArray.class]) {
            dataM = data.copy;
        }
        if (dataM.count > idx) {
            [dataM insertObject:model atIndex:idx];
        }else{
            [dataM addObject:model];
        }
        _data = dataM;
    }
}

- (BaseJsonViewStepErrorModel *) dictionaryInsertWithModel: (BaseJsonViewStepModel *) model andIndex:(NSInteger) index {
    NSString *key = model.key;
    BaseJsonViewStepErrorModel *error = [BaseJsonViewStepErrorModel new];
    NSString *originDataClassStr = NSStringFromClass([self.originData class]);
    if (key.length <= 0) {
        error.code = BaseJsonViewStepTypeErrorCode404;
        error.errorMessage = @"🌶：字典内部必须插入字典，传入的key不能为nil";
        return error;
    }
    if([self.originData isKindOfClass:NSDictionary.class]) {
        NSMutableDictionary *originData = ((NSMutableDictionary *)self.originData);
        if(![originData isKindOfClass:NSMutableDictionary.class]) {
            originData = originData.mutableCopy;
        }
        id value = model.originData;
        value = value ? value :[BaseJsonViewStepNilModel new];
        if ([originData valueForKey:model.key]) {
            error.errorMessage = [NSString stringWithFormat: @"🌶: 已有【%@】,不能强行覆盖",model.key];
            error.code = BaseJsonViewStepErrorCode500;
        }else{
            [originData setValue: value forKey:model.key];
            self.originData = originData;
        }
    }else{
        
        error.errorMessage = [NSString stringWithFormat: @"🌶 类型错误，标记为《BaseJsonViewStepModelType_Dictionary》类型的数据实际为：%@",originDataClassStr];
        error.code = BaseJsonViewStepTypeErrorCode404;
    }
    return error;
}

- (id)toDic {
    id data;
    switch (self.type) {
        case BaseJsonViewStepModelType_Dictionary: {
            NSMutableDictionary *dicM = [NSMutableDictionary new];
            NSArray *array = self.data;
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:BaseJsonViewStepModel.class]) {
                    BaseJsonViewStepModel *model = obj;
                    if (model.key > 0) {
                        dicM[model.key] =  [model toDic];
                    }
                }
            }];
            data = dicM;
        }
            break;
        case BaseJsonViewStepModelType_Array:{
            NSMutableArray *arrayM = [[NSMutableArray alloc]init];
            NSArray *array = self.data;
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:BaseJsonViewStepModel.class]) {
                    BaseJsonViewStepModel *model = obj;
                    [arrayM addObject:[model toDic]];
                }
            }];
            data = arrayM;
        }
            break;
        case BaseJsonViewStepModelType_Number:{
            NSString *numberStr = self.data;
            BOOL isNumber = BaseStringHandler.handler(numberStr).isNumber;
            if (isNumber) {
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = NSNumberFormatterDecimalStyle;
                data = [formatter numberFromString:numberStr];
            } else {
                data = numberStr;
            }
        }
            break;
        case BaseJsonViewStepModelType_String:
            data = self.data;
            break;
    }
    return data;
}


- (id) selfDataSerialization {
    id value;
    if ([self.data isKindOfClass:NSArray.class]) {
        NSArray *array = self.data;
        NSMutableArray *arrayM = [[NSMutableArray alloc]initWithCapacity:array.count];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:BaseJsonViewStepModel.class]) {
                BaseJsonViewStepModel *model = obj;
                [arrayM addObject:[model toDic]];
            }
        }];
        value = arrayM.copy;
    } else if ([self.data isKindOfClass:NSString.class]) {
        if (self.type == BaseJsonViewStepModelType_Number) {
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
    return value;
}

- (id) toDicWithKey: (NSString *)key andDic: (NSMutableDictionary *)dictionary {
    id value;
    NSMutableDictionary *dicM = [NSMutableDictionary new];
    if ([self.data isKindOfClass:NSArray.class]) {
        NSArray *array = self.data;
        NSMutableArray *arrayM = [[NSMutableArray alloc]initWithCapacity:array.count];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:BaseJsonViewStepModel.class]) {
                BaseJsonViewStepModel *model = obj;
                [arrayM addObject: [model toDicWithKey:self.key andDic:dicM]];
            }
        }];
        value = arrayM.copy;
    } else if ([self.data isKindOfClass:NSString.class]) {
        if (self.type == BaseJsonViewStepModelType_Number) {
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
    self.data = nil;
    [self data];
}

- (void) reloadDataWitOriginData {
    
    NSInteger level = self.level;
    id obj = self.originData;
    
    if ([obj isKindOfClass:NSArray.class]) {

        NSArray *array = obj;
        NSMutableArray *arrayM = [[NSMutableArray alloc]initWithCapacity:array.count];
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BaseJsonViewStepModel *model = [BaseJsonViewStepModel createStepModelWithOriginData:obj andKey:@""];
            model.superPoint = self;
            model.level = level+1;
            [arrayM addObject:model];
        }];
        _data = arrayM;
        
    } else if ([obj isKindOfClass:NSDictionary.class]){
        
        NSDictionary *dic = obj;
        NSMutableArray *arrayM = [[NSMutableArray alloc] initWithCapacity:dic.count];
        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            BaseJsonViewStepModel *model = [BaseJsonViewStepModel createStepModelWithOriginData:obj andKey:key];
            model.superPoint = self;
            model.level = level+1;
            [arrayM addObject:model];
        }];
        _data = arrayM;
        
    }else if ([obj isKindOfClass:NSNumber.class]){
        _data = [NSString stringWithFormat:@"%@",obj];
    }else if ([obj isKindOfClass:NSString.class]) {
        _data = [NSString stringWithFormat:@"%@",obj];
    } else {

    }
}


- (void) deleteDataIfNeededWithBehindCount:(NSInteger) count {
    if ([_data isKindOfClass:NSArray.class]) {
        NSMutableArray *arrayM = _data;
        if (arrayM.count > count) {
            if (![arrayM isKindOfClass:NSMutableArray.class]) {
                arrayM = arrayM.mutableCopy;
            }
             arrayM = [arrayM subarrayWithRange:NSMakeRange(count-1, arrayM.count - count)].mutableCopy;
        }
        
    }
}

- (BaseJsonViewStepModel *) createItemModelIfNeededWithIndex:(NSInteger) idx {
    BaseJsonViewStepModel *model;
    switch (self.type) {
        case BaseJsonViewStepModelType_Dictionary:
        case BaseJsonViewStepModelType_Array: {
            
            if(!_data) {
                _data = [NSMutableArray new];
            }
            NSArray *dataArray = nil;
            if([_data isKindOfClass:NSArray.class]) {
                dataArray = _data;
            }
            if(dataArray.count > idx && [dataArray[idx] isKindOfClass: BaseJsonViewStepModel.class]) {
                model = dataArray[idx];
            }else{
                model = [BaseJsonViewStepModel new];
                NSMutableArray *dataArrayM = dataArray.mutableCopy;
                if (![dataArray isKindOfClass:NSMutableArray.class]) {
                     dataArrayM = dataArray.mutableCopy;
                }
                [dataArrayM addObject:model];
                _data = dataArrayM;
            }
        }
            break;
        case BaseJsonViewStepModelType_Number:
        case BaseJsonViewStepModelType_String: {
        }
            break;
    }
    return model;
}

- (BaseJsonViewStepModel *) createWithDic: (NSDictionary *) dic {
    BaseJsonViewStepModel *model1 = [BaseJsonViewStepModel new];
    
    NSMutableArray <BaseJsonViewStepModel *>*array = [[NSMutableArray alloc] initWithCapacity:dic.count];
    
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        BaseJsonViewStepModel *model;
        model.superPoint = model1;
        model.key = key;
        [array addObject:model];
    }];
    return model1;
}

- (BaseJsonViewStepModelType)type {
    [self setupType];
    return _type;
}

- (void) setupType {
    id obj = self.originData;
    if ([obj isKindOfClass:NSArray.class]) {
        _type = BaseJsonViewStepModelType_Array;
    } else if ([obj isKindOfClass:NSDictionary.class]){
        _type = BaseJsonViewStepModelType_Dictionary;
    }else if ([obj isKindOfClass:NSNumber.class]){
        _type = BaseJsonViewStepModelType_Number;
    }else if ([obj isKindOfClass:NSString.class]) {
        _type = BaseJsonViewStepModelType_String;
    }
}

- (NSArray<BaseJsonViewStepModel *> *)faltSelfDataIfOpen {
    NSMutableArray *array = [NSMutableArray new];
    [self faltSelfDataIfOpenWithModelArray:array];
    return array;
}

- (NSArray <BaseJsonViewStepModel *>*) faltSelfData {
    NSMutableArray *array = [NSMutableArray new];
    [self faltSelfDataWithModelArray:array];
    return array;
}


- (void) faltSelfDataWithModelArray: (NSMutableArray <BaseJsonViewStepModel *>*) modelArray {
    if (!self.data) {
        [self reloadDataWitOriginDataProperty];
    }
    
    if ([self.data isKindOfClass:NSArray.class]) {
        
        if (((NSArray *)self.data).count <= 0) {
            [self reloadDataWitOriginDataProperty];
        }
        
        NSArray *array = self.data;
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj isKindOfClass:BaseJsonViewStepModel.class]){
                BaseJsonViewStepModel *model = obj;
                    [modelArray addObject:model];
                    [model faltSelfDataWithModelArray:modelArray];
            }
        }];
    }
}

- (void)faltSelfDataIfOpenWithModelArray: (NSMutableArray <BaseJsonViewStepModel *>*) modelArray{
    if (!self.data) {
        [self reloadDataWitOriginDataProperty];
    }

    if ([self.data isKindOfClass:NSArray.class]) {
        
        if (((NSArray *)self.data).count <= 0) {
            [self reloadDataWitOriginDataProperty];
        }
        
        NSArray *array = self.data;
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj isKindOfClass:BaseJsonViewStepModel.class]){
                BaseJsonViewStepModel *model = obj;
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
        [self reloadDataWitOriginData];
        _count = [self getCount:0];
    }
    return _data;
}

- (void)setIsOpen:(BOOL)isOpen {
    _isOpen = isOpen;
    _count = [self getCount:0];
}

- (NSString *) getTreeLayer {
    
    return BaseJsonViewStepUIModel.getTreeLayerStringWithModel(self);
}

- (NSAttributedString *)getTreeLayerAttriStr {
    return BaseJsonViewStepUIModel.getTreeLayerAttriStrWithModel(self);
}

- (NSString *)getSuperPointKey {
    return BaseJsonViewStepUIModel.getSuperPointKeyWithModel(self);
}

- (NSString *) conversionToJson {
    id dic = [self toDic];
    NSMutableDictionary *dicM = [NSMutableDictionary new];
    
    if (!dic) {
        dic = @"";
    }
    
    if (![dic isKindOfClass:NSDictionary.class]) {
        if (self.key.length > 0) {
            dicM[self.key] = dic;
        }else{
            return [NSString stringWithFormat:@"%@",dic];
        }
    }else{
        if (self.key.length > 0) {
            dicM[self.key] = dic;
        }else{
            dicM = ((NSDictionary *)dic).mutableCopy;
        }
    }
    
    return [BaseJsonViewStepModel convertToJsonData:dicM];
}

+ (NSString *)convertToJsonData:(id) value{
    NSError *error;
    if (!value) return nil;
    
    id jsonData = [NSJSONSerialization dataWithJSONObject:value options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    
//    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};

    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}

- (BOOL) isEqualToKeyAndOriginDataWithModel: (BaseJsonViewStepModel *)model {
    BOOL isEqual_Key = false;
    BOOL isEqual_Data = false;
    if (self.key.length <= 0 && model.key.length <= 0) {
        isEqual_Key = true;
    }else {
        isEqual_Key = [self.key isEqualToString:model.key];
    }
    if (!self.originData && !model.originData) {
        isEqual_Data = true;
    }else{
        isEqual_Data = [self.originData isEqual:model.originData];
    }
    return isEqual_Data && isEqual_Key;
}

- (void)dealloc { BaseJsonViewCommonDLog(@"✅BaseJsonViewStepModel销毁： %@",self.key);
}
@end
