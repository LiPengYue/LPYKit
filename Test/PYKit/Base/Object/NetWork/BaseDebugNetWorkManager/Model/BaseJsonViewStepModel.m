//
//  BaseJsonViewManager.h
//  PYKit
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
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
        
        if ([data isKindOfClass:NSString.class]) {
            NSDictionary *dic = BaseJsonViewManager.convertToDicWithJson(data);
            if (dic) {
                model = BaseJsonViewManager.convertToStepModelWithDic(dic);
            }
        }
        
        if (!model) {
            model = [BaseJsonViewStepModel createStepModelWithId:data andKey:@""];
        }
        return model;
    };
}

+ (BaseJsonViewStepModel *) createStepModelWithId: (id) data andKey: (NSString *)key{
    BaseJsonViewStepModel *model = [BaseJsonViewStepModel new];
    model.originData = data;
    model.key = key;
    [model reloadDataWitOriginDataProperty];
    return model;
}

+ (instancetype) nullData {
    BaseJsonViewStepModel *model = [BaseJsonViewStepModel new];
    model.isOpen = false;
    model.key = @"🌶 没有数据";
    return model;
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
    
    if ([self.data isKindOfClass:NSArray.class]) {
        NSArray *array = self.data;
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:BaseJsonViewStepModel.class]) {
                tempCount+=1;
            }
        }];
    } else if([self.data isKindOfClass:BaseJsonViewStepModel.class]) {
        tempCount+=1;
    }else if ([self.data isKindOfClass:NSString.class]) {
    }else {
    }
    return tempCount;
}

- (void) removeWithKey: (NSString *)key andModel: (BaseJsonViewStepModel *)model {
    switch (self.type) {
            
        case BaseJsonViewStepModelType_Dictionary:
        case BaseJsonViewStepModelType_Array:
            if([self.data isKindOfClass:NSArray.class]) {
                NSArray *array = (NSArray *)self.data;
                NSMutableArray *arrayM = array.mutableCopy;
                [arrayM removeObject:model];
                self.data = arrayM;
            }
            break;
        case BaseJsonViewStepModelType_Number:
            break;
        case BaseJsonViewStepModelType_String:
            break;
    }
    
}

- (void) removeFromeSuper {
    [self.superPoint removeWithKey:self.key andModel:self];
}

- (id) parsingData {
    id data;
    switch (self.type) {
        case BaseJsonViewStepModelType_Dictionary: {
            NSMutableDictionary *dicM = [NSMutableDictionary new];
            NSArray *array = self.data;
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:BaseJsonViewStepModel.class]) {
                    BaseJsonViewStepModel *model = obj;
                    if (model.key > 0) {
                        dicM[model.key] =  [model parsingData];
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
- (id)toDic {
   
    id data = [self parsingData];
    if (self.key) {
        NSMutableDictionary *dic = [NSMutableDictionary new];
         dic[self.key] = data;
        return dic;
    }else{
        return data;
    }
}


- (id) selfDataSerialization {
    id value;
    if ([self.data isKindOfClass:NSArray.class]) {
        NSArray *array = self.data;
        NSMutableArray *arrayM = [[NSMutableArray alloc]initWithCapacity:array.count];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:BaseJsonViewStepModel.class]) {
                BaseJsonViewStepModel *model = obj;
                [arrayM addObject:[model parsingData]];
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
    
    NSInteger level = self.level;
    id obj = self.originData;
    
    if ([obj isKindOfClass:NSArray.class]) {
        self.type = BaseJsonViewStepModelType_Array;
        NSArray *array = obj;
        NSMutableArray *arrayM = [[NSMutableArray alloc]initWithCapacity:array.count];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BaseJsonViewStepModel *model = [BaseJsonViewStepModel new];
            model.superPoint = self;
            model.originData = obj;
            [model setupType];
            model.level = level+1;
            [arrayM addObject:model];
        }];
        _data = arrayM;
        
    } else if ([obj isKindOfClass:NSDictionary.class]){
        NSDictionary *dic = obj;
        NSMutableArray *arrayM = [[NSMutableArray alloc] initWithCapacity:dic.count];
        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            BaseJsonViewStepModel *model = [BaseJsonViewStepModel new];
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
        self.type = BaseJsonViewStepModelType_Number;
        
    }else if ([obj isKindOfClass:NSString.class]) {
        _data = [NSString stringWithFormat:@"%@",obj];
        self.type = BaseJsonViewStepModelType_String;
        
    } else {
        _data = [BaseJsonViewStepModel nullData];
    }
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

- (void) setupType {
    id obj = self.originData;
    if ([obj isKindOfClass:NSArray.class]) {
        self.type = BaseJsonViewStepModelType_Array;
    } else if ([obj isKindOfClass:NSDictionary.class]){
        self.type = BaseJsonViewStepModelType_Dictionary;
    }else if ([obj isKindOfClass:NSNumber.class]){
        self.type = BaseJsonViewStepModelType_Number;
        
    }else if ([obj isKindOfClass:NSString.class]) {
        self.type = BaseJsonViewStepModelType_String;
        
    }
}

- (NSArray<BaseJsonViewStepModel *> *)faltSelfDataIfOpen {
    NSMutableArray *array = [NSMutableArray new];
    [self faltSelfDataIfOpenWithModelArray:array];
    return array;
}

- (void)faltSelfDataIfOpenWithModelArray: (NSMutableArray <BaseJsonViewStepModel *>*) modelArray{
    if (!self.data) {
        [self reloadDataWitOriginDataProperty];
    }
    
    if ([self.data isKindOfClass:NSArray.class]) {
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
        [self reloadDataWitOriginDataProperty];
    }
    return _data;
}

- (void)setIsOpen:(BOOL)isOpen {
    _isOpen = isOpen;
    _count = [self getCount:0];
}

- (NSString *) getTreeLayer {
    NSMutableArray <BaseJsonViewStepModel *>*arrayM = [NSMutableArray new];
    
    BaseJsonViewStepModel *modelTemp = self;
    
    while (1) {
        [arrayM addObject:modelTemp];
        if (modelTemp.superPoint == nil) {
            break;
        }
        modelTemp = modelTemp.superPoint;
    }
    
    BaseStringHandler *handler = BaseStringHandler.handler(@"");
    for (NSInteger i = arrayM.count-1; i >= 0; i--) {
        BaseJsonViewStepModel *model = arrayM[i];
        if(model.superPoint) {
            handler.addObjc(@"→");
        }
        switch (model.type) {
                
            case BaseJsonViewStepModelType_Dictionary: {
                NSString *key = model.key;
                if (key.length <= 0) {
                    key = @"obj";
                }
                handler
                .addObjc(key)
                .setDefaultIfNull(@"obj")
                .addObjc(@"{")
                .addInt(model.count)
                .addObjc(@"}");
            }
                break;
            case BaseJsonViewStepModelType_Array: {
                NSString *key = model.key;
                if (key.length <= 0) {
                    key = @"obj";
                }
                handler
                .addObjc(key)
                .setDefaultIfNull(@"arr")
                .addObjc(@"[")
                .addInt(model.count)
                .addObjc(@"]");
            }
                break;
            case BaseJsonViewStepModelType_Number:
            case BaseJsonViewStepModelType_String:
                handler
                .addObjc(model.key)
                .addObjc(@":")
                .addObjc(model.data);
                break;
        }
    }
    return handler.getStr;
}

- (NSAttributedString *)getTreeLayerAttriStr {
    NSMutableArray <BaseJsonViewStepModel *>*arrayM = [NSMutableArray new];
    
    BaseJsonViewStepModel *modelTemp = self;
    
    while (1) {
        [arrayM addObject:modelTemp];
        if (modelTemp.superPoint == nil) {
            break;
        }
        modelTemp = modelTemp.superPoint;
    }
    
    BaseAttributedStrHandler*handler = BaseAttributedStrHandler.handle(@"");
    for (NSInteger i = arrayM.count-1; i >= 0; i--) {
        BaseJsonViewStepModel *model = arrayM[i];
        if(model.superPoint) {
            //            handler.addObjc(@"→");
            handler.append(
                           BaseAttributedStrHandler
                           .handle(@"→")
                           );
        }
        switch (model.type) {
                
            case BaseJsonViewStepModelType_Dictionary: {
                NSString *key = model.key;
                if (key.length <= 0) {
                    key = @"obj";
                }
                
                key =
                BaseStringHandler
                .handler(key)
                .addObjc(@"{")
                .addInt(model.count)
                .addObjc(@"}")
                .getStr;
                
                handler
                .append(
                        BaseAttributedStrHandler
                        .handle(key)
                        );
                handler
                .setUpColor(normalColor);
            }
                break;
            case BaseJsonViewStepModelType_Array: {
                NSString *key = model.key;
                if (key.length <= 0) {
                    key = @"array";
                }
                key =
                BaseStringHandler
                .handler(key)
                .addObjc(@"[")
                .addInt(model.count)
                .addObjc(@"]")
                .getStr;
                
                handler
                .append(
                        BaseAttributedStrHandler
                        .handle(key)
                        );
                
                handler
                .setUpColor(normalColor);
            }
                break;
            case BaseJsonViewStepModelType_Number:
            case BaseJsonViewStepModelType_String:
                handler
                .append(
                        BaseAttributedStrHandler
                        .handle(BaseStringHandler.handler(@"\n").addObjc(model.key))
                        .setUpColor(searchResultCellKeyColor)
                        )
                .append(
                        BaseAttributedStrHandler
                        .handle(@":")
                        .setUpColor(normalColor)
                        )
                .append(
                        BaseAttributedStrHandler
                        .handle(model.data)
                        .setUpColor(BaseJsonViewStepModelType_Number == model.type ? numberColor : stringColor)
                        );
                break;
        }
    }
    handler.setUpFont(BaseFont.fontSCR(12));
    return handler.str;
}

- (NSString *) conversionToJson {
    NSDictionary *dic = [self toDic];
    return [BaseJsonViewStepModel convertToJsonData:dic];
}

+ (NSString *)convertToJsonData:(id) value{
    NSError *error;
    if (!value) return nil;
    if (![value isKindOfClass:NSDictionary.class]) {
        return [NSString stringWithFormat:@"%@",value];
    }
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

@end
