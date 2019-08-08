//
//  BaseJsonViewManager.h
//  PYKit
//
//  Created by 李鹏跃 on 2019/9/11.
//  Copyright © 2019年 13lipengyue. All rights reserved.
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
