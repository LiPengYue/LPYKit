//
//  animater.h
//  PYTransitionAnimation
//
//  Created by 李鹏跃 on 17/3/13.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//




#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// ------------------------------- readMe -------------------------------
/**
//使用注意，
 // 1. dismissDuration 与presentDuration的动画事件尽量与动画时间一直，否则内存会受影响
 // 2. 最后还是弄了个属性记录了一下，当外界完成动画后一定要把isAccomplishAnima 设置成yes
 
 // 一、a跳转b，
 -----------a: a可以什么都不用做，直接present，
 -----------b: b要在init方法里面 写这两个方法，
 这个方法保证fromView才不会被移除(及可以在modal后看到a控制器的view)
 self.modalPresentationStyle = UIModalPresentationCustom;
 这个属性表示在modal、dismiss的时候会走自定义的方法
 self.transitioningDelegate = self.animater;
 
 // 二、在执行动画类（AnimatedTransition）中：在完成动画后一定要调用[transitionContext completeTransition:YES];
 最后如果不做动画完成处理，就会造成toView不能相应点击的情况，可能在执行完动画后，系统回到了主线程，一直在等待完成命令，所以没有办法执行点击事件
 
// 三、在dismiss的时候，其实是拿不到toView的（这时候其实相当于是b-》a，用枚举记录区分一下就好）
 可以用toVC.view

// 四、在present的时候，不能用toVC.View表示toView，因为这之间有个动画的时间差，会出问题的老铁
 

 /**
 我的简书：《iOS CAAnimation之CATransition（自定义转场动画）》
 http://www.jianshu.com/p/fb0d6b0f8008
 
 //坑1. dismiss后黑屏了？？？
 Custom 模式：presentation 结束后，presentingView(fromView) 未被主动移出视图结构，在 dismissal 中，注意不要像其他转场中那样将 presentingView(toView) 加入 containerView 中，否则 dismissal 结束后本来可见的 presentingView 将会随着 containerView 一起被移除。如果你在 Custom 模式下没有注意到这点，很容易出现黑屏之类的现象而不知道问题所在。
 在 Custom 模式下的dismissal 转场（在present中要添加）中不要像其他的转场那样将 toView(presentingView) 加入 containerView，否则 presentingView 将消失不见，而应用则也很可能假死。而 FullScreen 模式下可以使用与前面的容器类 VC 转场同样的代码。因此，上一节里示范的 Slide 动画控制器不适合在 Custom 模式下使用，放心好了，Demo 里适配好了，具体的处理措施，请看下一节的处理
 
 //坑2. dismiss时 toView为nil
 iOS 8 为<UIViewControllerContextTransitioning>协议添加了viewForKey:方法以方便获取 fromView 和 toView，但是在 Modal 转场里要注意：在 Custom 模式下通过viewForKey:方法来获取 presentingView 得到的是 nil，必须通过viewControllerForKey:得到 presentingVC 后来间接获取，FullScreen 模式下没有这个问题。(原来这里没有限定是在 Custom 模式，导致 @JiongXing 浪费了些时间，抱歉)。因此在 Modal 转场中，较稳妥的方法是从 fromVC 和 toVC 中获取 fromView 和 toView。
 */



@interface Animater : NSObject <UIViewControllerTransitioningDelegate>

+ (instancetype)animaterWithModalPresentationStyle: (UIModalPresentationStyle)modalPresentationStyle;
- (instancetype)initWithModalPresentationStyle: (UIModalPresentationStyle)modalPresentationStyle;

/**这是属性一定要设置，否则看 上面解释的“坑1”*/
@property (nonatomic,assign) UIModalPresentationStyle modalPresentationStyle;

//MARK:  -------------------- 动画时长 和类型 ------------------------
/** present动画时长*/
@property (nonatomic,assign) CGFloat presentDuration;
/** dismiss动画时长*/
@property (nonatomic,assign) CGFloat dismissDuration;
/**动画是否完成，在动画完成时候，一定要把这个属性改为YES*/
@property (nonatomic,assign) BOOL isAccomplishAnima;


//MARK: ---------------------- dismiss & present ------------------------
/**dismiss动画*/
- (void)dismissAnimaWithBlock: (void(^)(UIViewController *toVC, UIViewController *fromeVC, UIView *toView, UIView *fromeView))dismissAnimaBlock;
/**present动画*/
- (void)presentAnimaWithBlock: (void(^)(UIViewController *toVC, UIViewController *fromeVC, UIView *toView, UIView *fromeView))presentAnimaBlock;
//MARK: ---------------------- setupContainerView ------------------------
- (void)setupContainerViewWithBlock: (void(^)(UIView *containerView))setupContainerViewBlock;

@end
