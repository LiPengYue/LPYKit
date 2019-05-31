//
//  BaseModalShadowAnimationConfig.h
//  Pods-PYTransitionAnimater_Example
//
//  Created by 李鹏跃 on 2018/11/2.
//

#import <UIKit/UIKit.h>

@interface BaseModalShadowAnimationConfig : NSObject

@property (nonatomic,weak) UIView *shadowAnimationView;
/**
 present 时候 animationView 的 阴影动画 offset
 */
- (BaseModalShadowAnimationConfig *(^)(CGSize size)) setUpPresentShadowOffset;
@property (nonatomic,assign) CGSize presentShadowOffset;
/**
 present 时候 animationView 的 阴影 透明度 动画
 */
- (BaseModalShadowAnimationConfig *(^)(CGFloat opacity)) setUpPresentShadowOpacity;
@property (nonatomic,assign) CGFloat presentShadowOpacity;

/**
 present 时候 animationView 的 阴影 color 动画
 */
- (BaseModalShadowAnimationConfig *(^)(UIColor *color)) setUpPresentShadowColor;
@property (nonatomic,strong) UIColor *presentShadowColor;
/**
 present 时候 animationView 的 阴影 radius 动画
 */
- (BaseModalShadowAnimationConfig *(^)(CGFloat radius)) setUpPresentShadowRadius;
@property (nonatomic,assign) CGFloat presentShadowRadius;

/**
 dismiss 时候 animationView 的 阴影动画 offset
 */
- (BaseModalShadowAnimationConfig *(^)(CGSize size)) setUpDismissShadowOffset;
@property (nonatomic,assign) CGSize dismissShadowOffset;

/**
 dismiss 时候 animationView 的 阴影 透明度 动画
 */
- (BaseModalShadowAnimationConfig *(^)(CGFloat opacity)) setUpDismissShadowOpacity;
@property (nonatomic,assign) CGFloat dismissShadowOpacity;


/**
 dismiss 时候 animationView 的 阴影 color 动画
 */
- (BaseModalShadowAnimationConfig *(^)(UIColor *color)) setUpDismissShadowColor;
@property (nonatomic,strong) UIColor *dismissShadowColor;
/**
 dismiss 时候 animationView 的 阴影 radius 动画
 */
- (BaseModalShadowAnimationConfig *(^)(CGFloat radius)) setUpDismissShadowRadius;
@property (nonatomic,assign) CGFloat dismissShadowRadius;

/// 开启动画 present 阴影动画
- (void) beginPresentAnimationWithDuration: (CGFloat) duration;
/// 开启动画 dismiss 阴影动画
- (void) beginDismissAnimationWithDuration: (CGFloat) duration;


/**
kCAMediaTimingFunctionLinear（线性）：匀速，给你一个相对静态的感觉,这个是默认的动画行为。

kCAMediaTimingFunctionEaseIn（渐进）：动画缓慢进入，然后加速离开

kCAMediaTimingFunctionEaseOut（渐出）：动画全速进入，然后减速的到达目的地

kCAMediaTimingFunctionEaseInEaseOut（渐进渐出）：动画缓慢的进入，中间加速，然后减速的到达目的地。
*/

@end
