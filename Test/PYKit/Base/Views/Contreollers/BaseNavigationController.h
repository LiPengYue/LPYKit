//
//  BaseNavigationController.h
//  PYKit
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseNavigationController : UINavigationController
<
UIGestureRecognizerDelegate,
UINavigationControllerDelegate
>

/// 跳转到 堆栈 从上向下遍历 第一次出现的 class为 viewControllerClass 的vc
- (NSArray <UIViewController *> *) popToTopVCWithClass: (Class) viewControllerClass andAnimated: (BOOL) animated;

/// 进制手势返回的 数组
@property (nonatomic,strong) NSArray <NSString *>*closeInteractivePopClassStrArray;
@end

NS_ASSUME_NONNULL_END
