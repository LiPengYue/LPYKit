//
//  BaseDismissAnimationHandler.h
//  Pods-PYTransitionAnimater_Example
//
//  Created by 李鹏跃 on 2018/11/5.
//

#import "BaseAnimationHandler.h"

/**
 dismiss 动画实现类
 */
@interface BaseDismissAnimationHandler : BaseAnimationHandler
- (void) dismissNullAnimationFunc;
- (void) dismissZoomAnimationFunc;
- (void) dismissAnimationStyleUp_bottomAnimationFunc;
- (void) dismissAnimationStyleBottom_UpFunc;
- (void) dismissAnimationStyleLeft_RightFunc;
- (void) dismissAnimationStyleRight_LeftFunc;
@end
