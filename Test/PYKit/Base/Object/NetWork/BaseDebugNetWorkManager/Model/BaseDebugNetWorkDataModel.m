//
//  BaseDebugNetWorkManager.h
//  PYKit
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//


#import "BaseDebugNetWorkDataModel.h"
#import "BaseStringHandler.h"

@implementation BaseDebugNetWorkDataModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isOpenNext = false;
        self.key = @"";
    }
    return self;
}

+ (instancetype) createWithDic: (NSDictionary *) dic {
    BaseDebugNetWorkDataModel *model1 = [BaseDebugNetWorkDataModel new];
    
    NSMutableArray <BaseDebugNetWorkDataModel *>*array = [[NSMutableArray alloc] initWithCapacity:dic.count];
    
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        BaseDebugNetWorkDataModel *model = [self createModelWithId: obj];
        model.superPoint = model1;
        model.key = key;
        [array addObject:model];
    }];
    
    //    if (array.count == 1) {
    //        model1.data = array.firstObject.data;
    //        model1.key = array.firstObject.key;
    //    }
    model1.data = array;
    return model1;
}

+ (BaseDebugNetWorkDataModel *) createModelWithId: (id)obj {
    BaseDebugNetWorkDataModel *model = [BaseDebugNetWorkDataModel new];
    model.originData = obj;
    if ([obj isKindOfClass:NSArray.class]) {
        model.type = BaseDebugNetWorkDataModelType_Array;
        model.data = [self createWithArray:obj andSuperPiont:model];
        
    } else if ([obj isKindOfClass:NSDictionary.class]){
        model = [self createWithDic:obj];
        model.type = BaseDebugNetWorkDataModelType_Dictionary;
        
    }else if ([obj isKindOfClass:NSNumber.class]){
        model.data = [NSString stringWithFormat:@"%@",obj];
        model.type = BaseDebugNetWorkDataModelType_Number;
        
    }else if ([obj isKindOfClass:NSString.class]) {
        model.data = [NSString stringWithFormat:@"%@",obj];
        model.type = BaseDebugNetWorkDataModelType_String;
        
    } else {
        model = [BaseDebugNetWorkDataModel nullData];
    }
    return model;
}

+ (NSArray <BaseDebugNetWorkDataModel *>*) createWithArray: (NSArray *)array andSuperPiont: (BaseDebugNetWorkDataModel *)superPoint{
    if (![array isKindOfClass:NSArray.class] && array.count <= 0) {
        return nil;
    }
    
    NSMutableArray *arrayM = [[NSMutableArray alloc]initWithCapacity:array.count];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BaseDebugNetWorkDataModel *model = [self createWithDic:obj];
        model.superPoint = superPoint;
        model.originData = obj;
        [arrayM addObject:model];
    }];
    return arrayM;
}

+ (instancetype) nullData {
    BaseDebugNetWorkDataModel *model = [BaseDebugNetWorkDataModel new];
    model.isOpenNext = false;
    model.key = @"🌶 没有数据";
    return model;
}


- (void)setData:(id)data {
    _data = data;
}

- (void)setIsOpenNext:(BOOL)isOpenNext {
    _isOpenNext = isOpenNext;
    [self reloadCount];
}

- (void) closeAll {
    if ([self.data isKindOfClass:NSArray.class]) {
        NSArray *array = self.data;
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:BaseDebugNetWorkDataModel.class]) {
                BaseDebugNetWorkDataModel *model = obj;
                model.isOpenNext = false;
            }
        }];
    } else if([self.data isKindOfClass:BaseDebugNetWorkDataModel.class]) {
        BaseDebugNetWorkDataModel *model = self.data;
        model.isOpenNext = false;
    }else if ([self.data isKindOfClass:NSString.class]) {
    }else {
    }
}

- (void) reloadCount {
    if (self.superPoint) {
        [self.superPoint reloadCount];
    }else{
       _count = [self getCount:1];
    }
}

- (NSInteger) count {
    if (_count <= 0) {
        _count = [self getCount:1];
    }
    return _count;
}

- (NSInteger) getCount: (NSInteger) count {
    __block NSInteger tempCount = count;
    
//    if (!self.isOpenNext) return tempCount;
    
    if ([self.data isKindOfClass:NSArray.class]) {
        NSArray *array = self.data;
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:BaseDebugNetWorkDataModel.class]) {
//                BaseDebugNetWorkDataModel *model = obj;
                tempCount+=1;
//                if (model.isOpenNext) {
//                  tempCount += [model getCount:tempCount];
//                }
            }
        }];
    } else if([self.data isKindOfClass:BaseDebugNetWorkDataModel.class]) {
//        BaseDebugNetWorkDataModel *model = self.data;
        tempCount+=1;
//        [model getCount:tempCount];
    }else if ([self.data isKindOfClass:NSString.class]) {
    }else {
    }
    return tempCount;
}

- (void) removeWithKey: (NSString *)key andModel: (BaseDebugNetWorkDataModel *)model {
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
        case BaseDebugNetWorkDataModelType_Number:
        case BaseDebugNetWorkDataModelType_String:
            break;
    }
    
}

- (void) removeFromeSuper {
    [self.superPoint removeWithKey:self.key andModel:self];
}

- (void) reloadData: (id) data {
    self.data = [BaseDebugNetWorkDataModel createModelWithId:data];
    self.originData = data;
}

- (id) toDicWithKey: (NSString *)key andDic: (NSMutableDictionary *)dictionary {
    id value;
    NSMutableDictionary *dicM = [NSMutableDictionary new];
    if ([self.data isKindOfClass:NSArray.class]) {
        NSArray *array = self.data;
        NSMutableArray *arrayM = [[NSMutableArray alloc]initWithCapacity:array.count];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:BaseDebugNetWorkDataModel.class]) {
                BaseDebugNetWorkDataModel *model = obj;
                [arrayM addObject: [model toDicWithKey:self.key andDic:dicM]];
            }
        }];
        value = arrayM.copy;
    } else if([self.data isKindOfClass:BaseDebugNetWorkDataModel.class]) {
        BaseDebugNetWorkDataModel *model = self.data;
        value = [model toDicWithKey:self.key andDic:dicM];
    }else if ([self.data isKindOfClass:NSString.class]) {
        if (self.type == BaseDebugNetWorkDataModelType_Number) {
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



@end

