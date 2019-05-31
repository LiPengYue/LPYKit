//
//  BasePresentAnimationHandler.h
//  Pods-PYTransitionAnimater_Example
//
//  Created by 李鹏跃 on 2018/11/5.
//

#import "BaseAnimationHandler.h"
/**
 present 动画实现类
 */
@interface BasePresentAnimationHandler : BaseAnimationHandler
- (void) presentNullAnimationFunc;
- (void) presentZoomAnimationFunc;
- (void) presentBottom_upAnimationFunc;
- (void) presentAnimationStyleLeftFunc;
- (void) presentAnimationStyleUp_BottomFunc;
- (void) presentAnimationStyleLeft_rightFunc;
@end
