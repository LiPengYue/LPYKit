//
//  BaseJsonViewStepErrorModel.m
//  PYkit
//
//  Created by 衣二三 on 2019/8/5.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import "BaseJsonViewStepErrorModel.h"

@implementation BaseJsonViewStepErrorModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.code = BaseJsonViewStepErrorCode_Success200;
    }
    return self;
}
- (BOOL)isSuccess {
    return self.code == BaseJsonViewStepErrorCode_Success200;
}

@end
