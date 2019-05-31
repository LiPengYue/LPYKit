//
//  BaseButton.m
//  PYKit
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import "BaseButton.h"
@interface BaseButton()
/// handler
@property (nonatomic,strong) BaseButtonHandler *handler;

@end

@implementation BaseButton

- (void)setHighlighted:(BOOL)highlighted {
    if (self.isShowHighlighted) {
        [super setHighlighted:highlighted];
    }
}
- (void) setupHandler: (void(^)(BaseButtonHandler *handler))block {
    if (block) {
        block(self.handler);
    }
}

- (BaseButtonHandler *)handler {
    if (!_handler) {
        _handler = BaseButtonHandler.handle(self);
    }
    return _handler;
}
@end
