//
//  PresentViewController.h
//  Animation
//
//  Created by 李鹏跃 on 2018/8/24.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationBarView.h"
#import "BaseAnimaterHeaders.h"


typedef void(^ BasicAnimationBlock)(CABasicAnimation *animation);

@interface BasePresentViewController : UIViewController

/// 其alpah 默认在present的是self.presentNavigationController 时，naviBarView.alpha = 1, 否则为0
@property (nonatomic,strong) BaseNavigationBarView *navBarView;

/**
 对此赋值 才能执行动画
 */
@property (nonatomic,weak) UIView *animationView;


/**
 * 1. 这个是两个Controller中间的蒙层view
 * 2. 不能被修改
 */
@property (nonatomic,weak,readonly) UIView *containerView;

/// 其他配置
@property (nonatomic,strong) BasePresentViewControllerConfiguration *presentConfig;
@property (nonatomic,strong) BaseModalShadowAnimationConfig *shadowAnimationConfig;


/**
 dismiss 动画开始前
 @param block block
 @warning toView 指的是 self.presentingViewController
 @warning fromeView 指的是 self.animaterView
 */
- (void) dismissAnimationBegin: (void (^)(UIView *toView,UIView *fromeView)) block
                 andCompletion: (void (^)(UIView *toView, UIView *fromeView)) completion;

/**
 * 将要dismiss的时候调用
 * @ return 是否 dismiss
 */
- (void) willDismissFunc: (BOOL(^)(BasePresentViewController *presentVC))willDismissBlock;

/**
 * 已经dismiss的时候调用
 */
- (void) didDismissFunc: (void(^)(BasePresentViewController *presentVC))didDismissBlock;

/**
 * 1. 点击背景的button
 * 2. block中的返回值： 是否需要执行dismiss方法
 */
- (void) clickBackgroundButtonBlockFunc: (BOOL(^)(BasePresentViewController *presentVC))clickCallBack;

/**
 present 动画开始
 @param block block
 @warning toView 指的是 self.animaterView
 @warning fromeView 指的是 self.presentingViewController
 */
- (void) presentAnimationBegin: (void(^)(UIView *toView, UIView *fromeView)) block
                 andCompletion: (void(^)(UIView *toView, UIView *fromeView)) completion;

@property (nonatomic,weak) BasePresentNavigationController *presentNavigationController;
- (BasePresentNavigationController *) addNavigationController;


#pragma mark - 动画自定义
/**
 1. 自定义动画需要继承自 BasePresentViewController 并且重写下面两个自定义函数
 2. 根据自己需求，创建新的int类型的枚举赋值给presentStyle 与dismissStyle，来区分动画类型
 3. 在动画结束后必须调用动画完成函数，否则界面会卡死
    - present ：【self presentCompletionFunc】
    - dismiss ：【self dismissAnimationCompletionFunc】
 4. 其生命周期函数依然生效
    - dismissAnimationBegin (dismiss 动画开始前)（动画完成时）
    - willDismissFunc （将要dismiss）
    - didDismissFunc  （dismiss 完成）
    - presentAnimationBegin
 */



/**
 @brief 自定义动画 ： A跳转B B为toVc A 为fromVc
 @param animaterView 执行动画的view
 @warning 只有 'presentStyle > 5 || presentStyle < 0' 才会执行custom动画
 @bug 在动画结束后，必须要执行 '[self presentCompletionFunc]'函数，否则页面会卡死
 */
- (void)customPresentAnimationFuncWithToVc: (UIViewController *)toVc
                                 andToView: (UIView *)toView
                                 andFromVc: (UIViewController *)fromVc
                               andFromView: (UIView *)fromView
                           andAnimaterView: (UIView *)animaterView;
- (void) presentCompletionFunc;

/**
 @brief 自定义动画 ： A跳转B B为toVc A 为fromVc
 @param animaterView 执行动画的view
 @warning 只有 'presentStyle > 5 || presentStyle < 0' 才会执行custom动画
 @bug 在动画结束后，必须要执行 '[self dismissAnimationCompletionFunc]'函数，否则页面会卡死
 */
- (void) customDismissAnimationFuncWithToVc: (UIViewController *)toVc
                                  andToView: (UIView *)toView
                                  andFromVc: (UIViewController *)fromVc
                                andFromView: (UIView *)fromView
                            andAnimaterView: (UIView *)animaterView;
- (void) dismissAnimationCompletionFunc;
@end


