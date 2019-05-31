//
//  animater.m
//  PYTransitionAnimation
//
//  Created by 李鹏跃 on 17/3/13.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

#import "Animater.h"
#import "AnimatedTransition.h"


@interface Animater ()
//MARK: ---------------------- dismiss & present ------------------------
/**dismiss动画*/
@property (nonatomic,copy) void(^dismissAnimaBlock)(UIViewController *toVC, UIViewController *fromeVC, UIView *toView, UIView *fromeView);

/**present动画*/
@property (nonatomic,copy) void(^presentAnimaBlock)(UIViewController *toVC, UIViewController *fromeVC, UIView *toView, UIView *fromeView);

/**containerView*/
@property (nonatomic,copy) void(^setupContainerViewBlock)(UIView *containerView);

/**非交互式 转场动画执行者*/
@property (nonatomic,strong) AnimatedTransition *animatedTransition;
@end



@implementation Animater

+ (instancetype)animaterWithModalPresentationStyle: (UIModalPresentationStyle)modalPresentationStyle{
    return [[self alloc]initWithModalPresentationStyle:modalPresentationStyle];
}
- (instancetype)initWithModalPresentationStyle: (UIModalPresentationStyle)modalPresentationStyle{
    if (self = [super init]) {
        self.modalPresentationStyle = modalPresentationStyle;
    }
    return self;
}




- (void)setIsAccomplishAnima:(BOOL)isAccomplishAnima {
    _isAccomplishAnima = isAccomplishAnima;
    self.animatedTransition.isAccomplishAnima = isAccomplishAnima;
}
- (void)setModalPresentationStyle:(UIModalPresentationStyle)modalPresentationStyle {
    _modalPresentationStyle = modalPresentationStyle;
    self.animatedTransition.modalPresentationStyle = modalPresentationStyle;
}

//MARK: --------------- 懒加载 -----------------------
- (AnimatedTransition *)animatedTransition {
    if (!_animatedTransition) {
        _animatedTransition = [[AnimatedTransition alloc]init];
    }
    return _animatedTransition;
}



//MAKR: --------------- dismiss & present 方法实现 ------------------
- (void)presentAnimaWithBlock:(void (^)(UIViewController *, UIViewController *, UIView *, UIView *))presentAnimaBlock {
    self.presentAnimaBlock = presentAnimaBlock;
}

- (void)dismissAnimaWithBlock:(void (^)(UIViewController *, UIViewController *, UIView *, UIView *))dismissAnimaBlock {
    self.dismissAnimaBlock = dismissAnimaBlock;
}


//MARK: ---------------------- setupContainerView ------------------------
- (void)setupContainerViewWithBlock: (void(^)(UIView *containerView))setupContainerViewBlock{
    self.setupContainerViewBlock = setupContainerViewBlock;
}


//MARK: ----------------- present --------------------------
///前两个方法是针对动画切换的，我们需要分别在呈现VC和解散VC时，给出一个实现了UIViewControllerAnimatedTransitioning接口的对象（其中包含切换时长和如何切换）。
- (id<UIViewControllerAnimatedTransitioning>) animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    __weak typeof(self)weakSelf = self;
    //动画类型
    self.animatedTransition.animatedTransitionType = AnimatedTransitionType_Present;
    //动画时长
    self.animatedTransition.presentDuration = weakSelf.presentDuration;
    //容器视图
    [weakSelf.animatedTransition setupContainerViewWithBlock:^(UIView *containerView) {
        if (weakSelf.setupContainerViewBlock) {
            weakSelf.setupContainerViewBlock(containerView);
        }
    }];
    //动画传递
    [weakSelf.animatedTransition presentAnimaWithBlock:^(UIViewController *toVC, UIViewController *fromeVC, UIView *toView, UIView *fromeView) {
        if (weakSelf.presentAnimaBlock) {
            weakSelf.presentAnimaBlock(toVC,fromeVC,toView,fromeView);
        }
    }];
    return weakSelf.animatedTransition;
}


//MARK: ------------------- Dismissed -------------------
-(id< UIViewControllerAnimatedTransitioning >)animationControllerForDismissedController:(UIViewController *)dismissed{
     __weak typeof (self)weakSelf = self;
    //动画类型
    weakSelf.animatedTransition.animatedTransitionType = AnimatedTransitionType_Dismiss;
    //动画时长
    weakSelf.animatedTransition.dismissDuration = weakSelf.dismissDuration;
    //容器视图
    [weakSelf.animatedTransition setupContainerViewWithBlock:^(UIView *containerView) {
        if (weakSelf.setupContainerViewBlock) {
            weakSelf.setupContainerViewBlock(containerView);
        }
    }];
    //动画传递
    [weakSelf.animatedTransition dismissAnimaWithBlock:^(UIViewController *toVC, UIViewController *fromeVC, UIView *toView, UIView *fromeView) {
        if (weakSelf.dismissAnimaBlock) {
            weakSelf.dismissAnimaBlock(toVC,fromeVC,toView,fromeView);
        }
    }];
    return weakSelf.animatedTransition;
}

////MARK: -------------------- 3 -------------------
////交互类型的动画
-(id< UIViewControllerInteractiveTransitioning >)interactionControllerForPresentation:(id < UIViewControllerAnimatedTransitioning >)animator{

    
    return nil;
}

-(id< UIViewControllerInteractiveTransitioning >)interactionControllerForDismissal:(id < UIViewControllerAnimatedTransitioning >)animator {
    return nil;
}

@end
