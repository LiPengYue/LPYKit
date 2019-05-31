//
//  AnimatedTransition.m
//  PYTransitionAnimation
//
//  Created by 李鹏跃 on 17/3/13.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

#import "AnimatedTransition.h"

@interface AnimatedTransition ()
@property (nonatomic,weak) id <UIViewControllerContextTransitioning> transitionContext;
//动画时长
@property (nonatomic,assign) CGFloat animaDuration;

//MARK: ---------------------- dismiss & present ------------------------
/**dismiss动画*/
@property (nonatomic,copy) void(^dismissAnimaBlock)(UIViewController *toVC, UIViewController *fromeVC, UIView *toView, UIView *fromeView);

/**present动画*/
@property (nonatomic,copy) void(^presentAnimaBlock)(UIViewController *toVC, UIViewController *fromeVC, UIView *toView, UIView *fromeView);

/**containerView*/
@property (nonatomic,copy) void(^setupContainerViewBlock)(UIView *containerView);

/**告诉系统停止动画*/
@property (nonatomic,copy) void(^completeTransitionBlock)(BOOL isompleteTransition);
@end

@implementation AnimatedTransition

//MARK -------------------- setter 方法 ----------------------------------
- (void)setIsAccomplishAnima:(BOOL)isAccomplishAnima {
    _isAccomplishAnima = isAccomplishAnima;
    if (isAccomplishAnima) {
        //执行完成动画
        [self.transitionContext completeTransition:isAccomplishAnima];
    }
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


#pragma mark - 动画核心方法
//MARK: 返回一个动画时长，这个时长尽量要与实际动画时长一直，因为系统会以此来作为转场参考时间
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    //0 是present 1是dismiss
    self.animaDuration = self.animatedTransitionType? self.dismissDuration : self.presentDuration;
    return self.animaDuration;
}

//MARK: 提供了transitionContext，里面能拿到fromeVC与toVC，以及对应的View
//注意，这里对应的View不能直接fromeVC.view获取
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    self.transitionContext = transitionContext;
    
    //1. 获取到当前VC 目标VC
    UIViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //2. 获取当前的容器视图
    UIView * contentView = [transitionContext containerView];
    
    //3. 添加fromView,与toView（不能直接fromeVC.view获取）
    UIView *toView = [transitionContext viewForKey:(UITransitionContextToViewKey)];

    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    // 这里有坑：看（下面的）坑1，
    //[contentView addSubview:fromView];
//    [contentView addSubview:toView];
    
//    //5. 动画实现 分为present动画和dismiss动画 （可以在animater的代理方法中区分并传进来）
//    if(present){
//        [UIView animateWithDuration:0.3 animations:^{
//            
//        }completion:^(BOOL finished) {
//            //注意：完成动画要调用[transitionContext completeTransition:YES];告诉系统完成动画了，否则就会造成toView不能相应点击的情况，可能在执行完动画后，系统回到了主线程，一直在等待完成命令，所以没有办法执行点击事件
//            [transitionContext completeTransition:YES];
//        }];
//    }else if(dismiss){
//        [UIView animateWithDuration:0.3 animations:^{
//            
//        } completion:^(BOOL finished) {
//            //注意：同present如果不告诉系统完成动画了就会直接dismiss掉fromeVC不会有任何动画，（这里的dismiss只是把present时候的toVC与fromeVC颠倒了）
//            [transitionContext completeTransition:YES];
//        }];
//    }
//    __weak typeof(toVC) wakeToVC = toVC;
//    __weak typeof(fromVC) wakeFromVC = fromVC;
//    __weak typeof(toView) wakeToView = toView;
//    __weak typeof(fromView) wakeFromView = fromView;
//    __weak typeof(contentView) wakeContentView = contentView;
//    __weak typeof(self) wakeSelf = self;
    //4. contentView 设置蒙版
    if (self.setupContainerViewBlock) {
        self.setupContainerViewBlock(toView);
    }
    
    //5. 动画执行
    switch (self.animatedTransitionType) {
        case AnimatedTransitionType_Present:{
            if (self.presentAnimaBlock){
                [contentView addSubview:toView];
                self.presentAnimaBlock(toVC,fromVC,toView,fromView);
            }
        }
            break;
        case AnimatedTransitionType_Dismiss:{
            if (!toView) toView = toVC.view;//如果没有toView 那么就用toVC.View
            if (self.dismissAnimaBlock) {
                //这里有坑，看下面的坑1
                if (self.modalPresentationStyle != UIModalPresentationCustom){
                    [contentView addSubview:fromView];
                }
                self.dismissAnimaBlock(toVC,fromVC,toView,fromView);
            }
        }
            break;
    }
    
    //最后如果不做动画完成处理，就会造成toView不能相应点击的情况，可能在执行完动画后，系统回到了主线程，一直在等待完成命令，所以没有办法执行点击事件
    //等待这个方法执行完毕才能进行下一波操作，否则会出现还没有执行完动画就被结束了（调度组不行）
    //最后还是弄了个属性记录了一下，当外界完成动画后一定要把isAccomplishAnima 设置成yes
//    if (self.dismissDuration) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.animaDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [transitionContext completeTransition:YES];
//        });
//    }
    //如果实现了这个方法，那么告诉系统，动画停止了
//    if (self.completeTransitionBlock) {
//        [self setCompleteTransitionBlock:^(BOOL isComplete) {
//            [transitionContext completeTransition: isComplete];
//        }];
//    }
}

// ------------------------- 关于一些坑：-----------------------------------
/**
 我的简书：《iOS CAAnimation之CATransition（自定义转场动画）》
 http://www.jianshu.com/p/fb0d6b0f8008
 
 //坑1. dismiss后黑屏了？？？
 Custom 模式：presentation 结束后，presentingView(fromView) 未被主动移出视图结构，在 dismissal 中，注意不要像其他转场中那样将 presentingView(toView) 加入 containerView 中，否则 dismissal 结束后本来可见的 presentingView 将会随着 containerView 一起被移除。如果你在 Custom 模式下没有注意到这点，很容易出现黑屏之类的现象而不知道问题所在。
 在 Custom 模式下的dismissal 转场（在present中要添加）中不要像其他的转场那样将 toView(presentingView) 加入 containerView，否则 presentingView 将消失不见，而应用则也很可能假死。而 FullScreen 模式下可以使用与前面的容器类 VC 转场同样的代码。因此，上一节里示范的 Slide 动画控制器不适合在 Custom 模式下使用，放心好了，Demo 里适配好了，具体的处理措施，请看下一节的处理
 
 //坑2. dismiss时 toView为nil
 iOS 8 为<UIViewControllerContextTransitioning>协议添加了viewForKey:方法以方便获取 fromView 和 toView，但是在 Modal 转场里要注意：在 Custom 模式下通过viewForKey:方法来获取 presentingView 得到的是 nil，必须通过viewControllerForKey:得到 presentingVC 后来间接获取，FullScreen 模式下没有这个问题。(原来这里没有限定是在 Custom 模式，导致 @JiongXing 浪费了些时间，抱歉)。因此在 Modal 转场中，较稳妥的方法是从 fromVC 和 toVC 中获取 fromView 和 toView。
 */

@end
