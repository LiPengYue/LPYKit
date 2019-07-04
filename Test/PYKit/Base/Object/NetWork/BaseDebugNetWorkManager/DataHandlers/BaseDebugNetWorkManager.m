//
//  BaseDebugNetWorkManager.m
//  PYKit
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import "BaseDebugNetWorkManager.h"
#import "BaseDebugNetWorkDataModel.h"

@implementation BaseDebugNetWorkManager
/// id 转成 step model
+ (BaseDebugNetWorkDataStepModel *(^)(id)) convertToStepModelWithID {
    return ^(id data) {
        BaseDebugNetWorkDataStepModel *model = BaseDebugNetWorkDataStepModel.createWithID(data);
        return model;
    };
}



+ (BaseDebugNetWorkDataStepModel *(^)(NSString *)) convertToStepModelWithJson {
    return ^(NSString *json) {
        return self.convertToStepModelWithDic(self.convertToDicWithJson(json));
    };
}

+ (BaseDebugNetWorkDataStepModel *(^)(NSDictionary *)) convertToStepModelWithDic {
    return ^(NSDictionary *dic) {
        BaseDebugNetWorkDataStepModel *model = [BaseDebugNetWorkDataStepModel new];
        model.originData = dic;
        model.level = 0;
        [model reloadDataWitOriginDataProperty];
        return model;
    };
}

+ (BaseDebugNetWorkDataModel *(^)(NSDictionary *)) convertToModelWithDic {
    return ^(NSDictionary *dic) {
        return [BaseDebugNetWorkDataModel createWithDic:dic];
    };
}

+ (BaseDebugNetWorkDataModel *(^)(NSString *)) convertToModelWithJson {
    return ^(NSString *json) {
        return self.convertToModelWithDic(self.convertToDicWithJson(json));
    };
}

+ (NSString *(^)(NSDictionary *)) convertToJsonWithDic {
    return ^(NSDictionary *dic) {
        return [self convertToJsonData:dic];
    };
}

+ (NSString *(^)(BaseDebugNetWorkDataModel *)) convertToJsonWithModel {
    return ^(BaseDebugNetWorkDataModel *model) {
        return @"";
    };
}

/// 转成 dic
+ (NSDictionary *(^)(NSString *)) convertToDicWithJson {
    return ^(NSString *json) {
        return [self dictionaryWithJsonString:json];
    };
}
+ (NSDictionary *(^)(BaseDebugNetWorkDataModel *)) convertToDicWithModel {
    return ^(BaseDebugNetWorkDataModel *model) {
        return @{};
    };
}


+ (NSString *)convertToJsonData:(NSDictionary *)dict {
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};

    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];

    return mutStr;
}

/// json 转化
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (BaseDebugNetWorkDataModel *)modelWithJsonString:(NSString *)jsonString {
    
    if (jsonString.length <= 0) {
        return [BaseDebugNetWorkDataModel nullData];
    }
    
    NSDictionary *dic = [BaseDebugNetWorkManager dictionaryWithJsonString:jsonString];
    return [BaseDebugNetWorkDataModel createWithDic:dic];
}

@end

