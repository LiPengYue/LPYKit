//
//  BaseJsonViewStepErrorModel.h
//  PYkit
//
//  Created by 衣二三 on 2019/8/5.
//  Copyright © 2019 衣二三. All rights reserved.
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
