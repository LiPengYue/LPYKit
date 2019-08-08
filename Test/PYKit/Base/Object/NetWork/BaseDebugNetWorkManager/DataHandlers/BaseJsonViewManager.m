//
//  BaseJsonViewManager.h
//  PYKit
//
//  Created by 李鹏跃 on 2019/9/11.
//  Copyright © 2019年 13lipengyue. All rights reserved.
//


#import "BaseJsonViewManager.h"
#import "BaseJsonViewStepModel.h"
#import "BaseJsonViewCommon.h"

@implementation BaseJsonViewManager
/// id 转成 step model
+ (BaseJsonViewStepModel *(^)(id)) convertToStepModelWithID {
    return ^(id data) {
        BaseJsonViewStepModel *model = BaseJsonViewStepModel.createWithID(data);
        return model;
    };
}



+ (BaseJsonViewStepModel *(^)(NSString *)) convertToStepModelWithJson {
    return ^(NSString *json) {
        return self.convertToStepModelWithDic(self.convertToDicWithJson(json));
    };
}

+ (BaseJsonViewStepModel *(^)(NSDictionary *)) convertToStepModelWithDic {
    return ^(NSDictionary *dic) {
        BaseJsonViewStepModel *model = [BaseJsonViewStepModel new];
        model.originData = dic;
        model.level = 0;
        [model data];
        return model;
    };
}

+ (NSString *(^)(NSDictionary *)) convertToJsonWithDic {
    return ^(NSDictionary *dic) {
        return [self convertToJsonData:dic];
    };
}

/// 转成 dic
+ (NSDictionary *(^)(NSString *)) convertToDicWithJson {
    return ^(NSString *json) {
        return [self dictionaryWithJsonString:json];
    };
}


+ (NSString *)convertToJsonData:(NSDictionary *)dict {
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        BaseJsonViewCommonDLog(@"%@",error);
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
        BaseJsonViewCommonDLog(@"   🌶🌶🌶\n   json解析失败：\n %@\n\n",err);
        return nil;
    }
    return dic;
}

@end

