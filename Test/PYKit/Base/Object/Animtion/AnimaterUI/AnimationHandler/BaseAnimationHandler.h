//
//  BaseAnimationHandler.h
//  Pods-PYTransitionAnimater_Example
//
//  Created by 李鹏跃 on 2018/11/5.
//

#import <UIKit/UIKit.h>

@class BasePresentViewControllerConfiguration;
@class BasePresentViewController;

/**
 动画 实现类
 */
@interface BaseAnimationHandler : NSObject
@property (nonatomic,weak) UIViewController *fromVc;
@property (nonatomic,weak) UIView *fromView;

@property (nonatomic,weak) UIViewController *toVc;
@property (nonatomic,weak) UIView *toView;
@property (nonatomic,weak) UIView *animationView;
@property (nonatomic,weak) BasePresentViewControllerConfiguration *presentConfig;
@property (nonatomic,weak,readonly) BasePresentViewController *presentViewController;
/// A跳到B A 原始的frame
@property (nonatomic,assign) CGRect originFromViewFrame;
- (BOOL) isZeroRect: (CGRect)rect;
- (CGRect) presentFromViewFrame;
- (CGRect) getAnimationViewFrame;
@end
