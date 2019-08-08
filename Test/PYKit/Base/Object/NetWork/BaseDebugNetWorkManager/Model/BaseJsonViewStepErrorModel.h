//
//  BaseJsonViewManager.h
//  PYKit
//
//  Created by 李鹏跃 on 2019/9/11.
//  Copyright © 2019年 13lipengyue. All rights reserved.
//


#import <Foundation/Foundation.h>

/// 没有匹配的类型
static NSInteger const BaseJsonViewStepTypeErrorCode404 = 404;
/// 解析出现错误
static NSInteger const BaseJsonViewStepErrorCode500 = 500;
/// 成功
static NSInteger const BaseJsonViewStepErrorCode_Success200 = 200;

NS_ASSUME_NONNULL_BEGIN

@interface BaseJsonViewStepErrorModel : NSObject
@property (nonatomic,copy) NSString *errorMessage;
@property (nonatomic,assign) NSInteger errorCode;
@property (nonatomic,assign) BOOL isSuccess;
@property (nonatomic,assign) NSInteger code;
@end

NS_ASSUME_NONNULL_END
