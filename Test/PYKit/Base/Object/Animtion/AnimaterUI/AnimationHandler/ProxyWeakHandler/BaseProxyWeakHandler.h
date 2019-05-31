//
//  BaseProxyWeakHandler.h
//  Pods-PYTransitionAnimater_Example
//
//  Created by 李鹏跃 on 2018/11/5.
//

#import <Foundation/Foundation.h>

/**
 有些delegate 用strong修饰，所以会产生循环引用问题，用此类来解决
 1. CAAnimation.delegate 用的就是strong
 2. NSTimer 用的Strong
 */
@interface BaseProxyWeakHandler : NSProxy

@property (weak,nonatomic,readonly)id target;

- (BaseProxyWeakHandler *) initWithTarget: (id)target;

+ (BaseProxyWeakHandler *(^)(id target)) createWithTarget;
@end
