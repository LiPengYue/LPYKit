//
//  BaseProxyWeakHandler.m
//  Pods-PYTransitionAnimater_Example
//
//  Created by 李鹏跃 on 2018/11/5.
//

#import "BaseProxyWeakHandler.h"
#import <objc/runtime.h>

@implementation BaseProxyWeakHandler

- (BaseProxyWeakHandler *) initWithTarget: (id)target {
    _target = target;
   objc_setAssociatedObject(target, (__bridge const void *)(self), self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return self;
}

+ (BaseProxyWeakHandler *(^)(id))createWithTarget {
    return ^(id target) {
        return [[self alloc] initWithTarget:target];
    };
}

- (BOOL)respondsToSelector:(SEL)aSelector{
    return [self.target respondsToSelector:aSelector];
}

/**
 根据Invocation 调用方法
 @param invocation 消息发送的核心类
 */
- (void)forwardInvocation:(NSInvocation *)invocation{
    SEL sel = invocation.selector;
    if ([self.target respondsToSelector:sel]) {
        [invocation invokeWithTarget:self.target];
    } else {
        [super forwardInvocation:invocation];
    }
}


/**
 根据selector 生成方法签名，为创建NSInvocation做准备
 @param sel selector 选择器
 @return 方法签名
 */
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    if (self.target && [self.target respondsToSelector:sel]) {
        return [self.target methodSignatureForSelector:sel];
    } else {
        return [super methodSignatureForSelector:sel];
    }
}
@end
