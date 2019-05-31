//
//  BasePresentViewControllerConfiguration.h
//  Animation
//
//  Created by 李鹏跃 on 2018/8/24.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//



// MARK: - UIViewAnimationOptions
/**
 UIViewAnimationOptionLayoutSubviews            //提交动画的时候布局子控件，表示子控件将和父控件一同动画。
 
 UIViewAnimationOptionAllowUserInteraction      //动画时允许用户交流，比如触摸
 
 UIViewAnimationOptionBeginFromCurrentState     //从当前状态开始动画
 
 UIViewAnimationOptionRepeat                    //动画无限重复
 
 UIViewAnimationOptionAutoreverse               //执行动画回路,前提是设置动画无限重复
 
 UIViewAnimationOptionOverrideInheritedDuration //忽略外层动画嵌套的执行时间
 
 UIViewAnimationOptionOverrideInheritedCurve    //忽略外层动画嵌套的时间变化曲线
 
 UIViewAnimationOptionAllowAnimatedContent      //通过改变属性和重绘实现动画效果，如果key没有提交动画将使用快照
 
 UIViewAnimationOptionShowHideTransitionViews   //用显隐的方式替代添加移除图层的动画效果
 
 UIViewAnimationOptionOverrideInheritedOptions  //忽略嵌套继承的选项
 
 //时间函数曲线相关
 
 UIViewAnimationOptionCurveEaseInOut            //时间曲线函数，缓入缓出，中间快
 
 UIViewAnimationOptionCurveEaseIn               //时间曲线函数，由慢到特别快（缓入快出）
 
 UIViewAnimationOptionCurveEaseOut              //时间曲线函数，由快到慢(快入缓出)
 
 UIViewAnimationOptionCurveLinear               //时间曲线函数，匀速
 
 //转场动画相关的
 
 UIViewAnimationOptionTransitionNone            //无转场动画
 
 UIViewAnimationOptionTransitionFlipFromLeft    //转场从左翻转
 
 UIViewAnimationOptionTransitionFlipFromRight   //转场从右翻转
 
 UIViewAnimationOptionTransitionCurlUp          //上卷转场
 
 UIViewAnimationOptionTransitionCurlDown        //下卷转场
 
 UIViewAnimationOptionTransitionCrossDissolve   //转场交叉消失
 
 UIViewAnimationOptionTransitionFlipFromTop     //转场从上翻转
 
 UIViewAnimationOptionTransitionFlipFromBottom  //转场从下翻转
 */


#import <UIKit/UIKit.h>
/// 动画样式
typedef enum : NSUInteger {
    /// 无动画
    PresentAnimationStyleNull = 0,
    /// 位置不动 进行 缩放与透明度 动画
    PresentAnimationStyleZoom,
    /// 从下到上
    PresentAnimationStyleBottom_up,
    /// 从上到下
    PresentAnimationStyleUp_Bottom,
    /// 右向左滑动
    PresentAnimationStyleRight_left,
    /// 左向右滑动
    PresentAnimationStyleLeft_right
    
} PresentAnimationStyle;

typedef enum : NSUInteger {
    /// 无动画
    DismissAnimationStyleNull = 0,
    /// 位置不动 进行 缩放与透明度 动画
    DismissAnimationStyleZoom,
    /// 从上到下
    DismissAnimationStyleUp_bottom,
    /// 从下到上
    DismissAnimationStyleBottom_Up,
    /// 左向右滑动
    DismissAnimationStyleLeft_Right,
    /// 右向左滑动
    DismissAnimationStyleRight_Left
    
}DismissAnimationStyle;


@interface BasePresentViewControllerConfiguration : NSObject

/**
 * present 动画样式
 * 默认为 PresentAnimationStyleNull
 */
- (BasePresentViewControllerConfiguration *(^)(NSInteger style))setUpPresentStyle;
@property (nonatomic,assign) NSInteger presentStyle;
/**
 * dismiss 动画样式
 * 默认为 ModalAnimationStyleNull
 */
- (BasePresentViewControllerConfiguration *(^)(NSInteger style)) setUpDismissStyle;
@property (nonatomic,assign) NSInteger dismissStyle;

/// 默认0.3
- (BasePresentViewControllerConfiguration *(^)(CGFloat duration)) setUpPresentDuration;
@property (nonatomic,assign) CGFloat presentDuration;
/// 默认0.3
- (BasePresentViewControllerConfiguration *(^)(CGFloat duration)) setUpDismissDuration;
@property (nonatomic,assign) CGFloat dismissDuration;
/// 默认0
- (BasePresentViewControllerConfiguration *(^)(CGFloat duration)) setUpPresentDelayDuration;
@property (nonatomic,assign) CGFloat presentDelayDuration;
/// 默认0
- (BasePresentViewControllerConfiguration *(^)(CGFloat duration)) setUpDismissDelayDuration;
@property (nonatomic,assign) CGFloat dismissDelayDuration;

/**
 * 时间曲线函数
 * 默认UIViewAnimationOptionCurveEaseIn（缓入快出）
 */
- (BasePresentViewControllerConfiguration *(^)(UIViewAnimationOptions options)) setUpPresentAnimationOptions;
@property (nonatomic,assign)  UIViewAnimationOptions presentAnimationOptions;
/**
 * 时间曲线函数
 * 默认UIViewAnimationOptionCurveEaseIn（缓入快出）
 */
- (BasePresentViewControllerConfiguration *(^)(UIViewAnimationOptions options)) setUpDismissAnimationOptions;
@property (nonatomic,assign)  UIViewAnimationOptions dismissAnimationOptions;
/**
 * 背景蒙层颜色
 * 默认 [UIColor colorWithWhite:0 alpha:0.3];
 */
- (BasePresentViewControllerConfiguration *(^)(UIColor *color)) setUpBackgroundColor;
@property (nonatomic,strong) UIColor *backgroundColor;

/**
 * present动画开始的时候 animationView的alpha
 */
- (BasePresentViewControllerConfiguration *(^)(CGFloat alpha)) setUpPresentStartAlpha;
@property (nonatomic,assign) CGFloat presentStartAlpha;

/**
 * dismiss动画结束的时候 animationView的alpha
 */
- (BasePresentViewControllerConfiguration *(^)(CGFloat alpha)) setUpDismissEndAlpha;
@property (nonatomic,assign) CGFloat dismissEndAlpha;

/**
 * @brief 联动 在动画的时候 fromeView toView 会相协调的动画
 * @warning 只有在x，y有移动的模式下，才会生效
 * @warning 设置 presentFromViewX 配置x
 * @warning 设置 presentFromViewY 配置y
 * @warning 如果没有设置，那么将自适应 联动
 */
- (BasePresentViewControllerConfiguration *(^)(BOOL isLinkage)) setUpIsLinkage;
@property (nonatomic,assign) BOOL isLinkage;

/**
 * @brief 联动 在present 时 fromeview最终的x
 * @warning 只有在x，y有移动的模式下，才会生效
 * @warning 只有 isLinkage == true 才会生效
 */
- (BasePresentViewControllerConfiguration *(^)(CGFloat x)) setUpPresentFromViewX;
@property (nonatomic,assign) CGFloat presentFromViewX;

/**
 * @brief 联动 在present 时 fromeview最终的x
 * @warning 只有在x，y有移动的模式下，才会生效
 * @warning 只有 isLinkage == true 才会生效
 */
- (BasePresentViewControllerConfiguration *(^)(CGFloat y)) setUpPresentFromViewY;
@property (nonatomic,assign) CGFloat presentFromViewY;
@end


