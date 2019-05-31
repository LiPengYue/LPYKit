//
//  AnimatedTransition.h
//  PYTransitionAnimation
//
//  Created by 李鹏跃 on 17/3/13.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum
{
    AnimatedTransitionType_Present = 0,
    AnimatedTransitionType_Dismiss = 1,
} AnimatedTransitionType;

@interface AnimatedTransition : NSObject <UIViewControllerAnimatedTransitioning>
/**这是属性一定要设置，否则看 上面解释的“坑1”*/
@property (nonatomic,assign) UIModalPresentationStyle modalPresentationStyle;

//MARK:  -------------------- 动画时长 和类型 ------------------------
/** present动画时长*/
@property (nonatomic,assign) CGFloat presentDuration;
/** dismiss动画时长*/
@property (nonatomic,assign) CGFloat dismissDuration;
/**动画是否完成，在动画完成时候，一定要把这个属性改为YES*/
@property (nonatomic,assign) BOOL isAccomplishAnima;

/**动画类型*/
@property (nonatomic,assign) AnimatedTransitionType animatedTransitionType;


//MARK: ---------------------- dismiss & present ------------------------
/**dismiss动画*/
- (void)dismissAnimaWithBlock: (void(^)(UIViewController *toVC, UIViewController *fromeVC, UIView *toView, UIView *fromeView))dismissAnimaBlock;
/**present动画*/
- (void)presentAnimaWithBlock: (void(^)(UIViewController *toVC, UIViewController *fromeVC, UIView *toView, UIView *fromeView))presentAnimaBlock;


//MARK: ---------------------- setupContainerView ------------------------
- (void)setupContainerViewWithBlock: (void(^)(UIView *containerView))setupContainerViewBlock;
@end
