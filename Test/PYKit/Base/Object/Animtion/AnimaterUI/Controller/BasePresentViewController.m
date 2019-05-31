//
//  PresentViewController.m
//  Animation
//
//  Created by 李鹏跃 on 2018/8/24.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import "BasePresentViewController.h"
#import "BasePresentViewControllerConfiguration.h"
#import "BasePresentNavigationController.h"
#import "Animater.h"
#import "BaseModalShadowAnimationConfig.h"
#import "BasePresentAnimationHandler.h"
#import "BaseDismissAnimationHandler.h"
@interface BasePresentViewController ()

@property (nonatomic,strong) Animater *animation_animater;
@property (nonatomic,strong) UIButton *animation_backgroundButton;
@property (nonatomic,assign) CGRect animation_fromeViewFrame;
/// 在present 时 fromeview最终的frame
@property (nonatomic,assign) CGRect animation_presentFromViewFrame;
/// fromeView
@property (nonatomic,strong) UIView *animation_fromeView;
@property (nonatomic,strong) BasePresentAnimationHandler *presentAnimationHandler;
@property (nonatomic,strong) BaseDismissAnimationHandler *dismissAnimationHandler;

@property (nonatomic,copy) BOOL(^willDismissBlock)(BasePresentViewController *presentVC);
@property (nonatomic,copy) void(^didDismissBlock)(BasePresentViewController *presentVC);
@property (nonatomic,copy) BOOL(^clickBackgroundButtonCallBack)(BasePresentViewController *presentVC);

@property (nonatomic,copy) void(^presetionAnimationBeginBlock)(UIView *toView, UIView *fromeView);
@property (nonatomic,copy) void(^presentAnimatingCompletion)(UIView *toView,UIView *fromeView);

@property (nonatomic,copy) void(^dismissAnimationBeginBlock)(UIView *toView,UIView *fromeView);
@property (nonatomic,copy) void(^dismissAnimatingCompletion)(UIView *toView, UIView *fromeView);

@property (nonatomic,copy) BasicAnimationBlock presentBeginBasicAnimationBlock;
@property (nonatomic,copy) BasicAnimationBlock dismissBeginBasicAnimationBlock;

@end

@implementation BasePresentViewController

#pragma mark - init
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.transitioningDelegate = self.animation_animater;
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self animater_setup];
}

- (CGRect) getAnimationViewFrame {
    CGRect frame = self.animationView.frame;
    if (!frame.size.height || !frame.size.width) {
        [self.view layoutIfNeeded];
        frame = self.animationView.frame;
    }
    return frame;
}

#pragma mark - functions
- (void) animater_setup {
    [self animater_setupAnimater];
    [self animater_setupButton];
    [self animater_setUpNavigetion];
}

// MARK: handle views
- (void) animater_setupButton {
    [self.view addSubview:self.backgroundButton];
    self.backgroundButton.frame = self.view.bounds;
    [self.backgroundButton addTarget:self action:@selector(clickBackgroundButtonFunc) forControlEvents:UIControlEventTouchUpInside];
}

- (void) animater_setUpNavigetion {
    [self.view addSubview:self.navBarView];
    self.navBarView.titleButtonHeight = 40;
    self.navBarView.isHiddenBottomLine = false;
    self.navBarView.itemHeight = 40;
    self.navBarView.addLeftItemWithTitleAndImg(@"返回",nil);
    __weak typeof (self)weakSelf = self;
    
    [self.navBarView clickLeftButtonFunc:^(UIButton *button, NSInteger index) {
        [weakSelf.navigationController popViewControllerAnimated:true];
    }];
    
    [self.view addSubview:self.navBarView];
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    self.navBarView.frame = CGRectMake(0, 0, w, 64);
    [self.navBarView reloadView];
}

- (void) animater_setupAnimater {
    [self setUpContainerView];
    [self setupPresetnAnimation];
    [self setupDismissAnimation];
}

- (void) setUpContainerView{
    __weak typeof (self)weakSelf = self;
    [self.animation_animater setupContainerViewWithBlock:^(UIView *containerView) {
        [weakSelf setValue:containerView forKey:@"containerView"];
    }];
}

- (void) setupPresetnAnimation {
    
    __weak typeof (self)weakSelf = self;
    [self.animation_animater presentAnimaWithBlock:^(UIViewController *toVC, UIViewController *fromVC, UIView *toView, UIView *fromView) {
        
        if (!weakSelf.animationView) {
            NSLog(@"🌶 没有设置animationView 不能执行动画");
        }
        [weakSelf presetionAnimationBeginBlockFunc];
        
        fromView = fromView ? fromView : fromVC.view;
        toView = toView ? toView : toVC.view;
        
        weakSelf.animation_fromeView = fromView;
        weakSelf.animation_fromeViewFrame = fromView.frame;
        weakSelf.dismissAnimationHandler.originFromViewFrame = fromView.frame;
        
        [weakSelf setupAnimationHandler:weakSelf.presentAnimationHandler
                                andToVc:toVC
                              andToView:toView
                              andFromVc:fromVC
                            andFromView:fromView
                        andAnimaterView:weakSelf.animationView
                 andOriginFromViewFrame:fromView.frame];
        
        switch (weakSelf.presentConfig.presentStyle) {
            case PresentAnimationStyleNull:
                [weakSelf.presentAnimationHandler presentNullAnimationFunc];
                break;
            case PresentAnimationStyleZoom:
                [weakSelf.presentAnimationHandler presentZoomAnimationFunc];
                break;
            case PresentAnimationStyleBottom_up:
                [weakSelf.presentAnimationHandler presentBottom_upAnimationFunc];
                break;
            case PresentAnimationStyleUp_Bottom:
                [weakSelf.presentAnimationHandler presentAnimationStyleUp_BottomFunc];
                break;
            case PresentAnimationStyleRight_left:
                
                [weakSelf.presentAnimationHandler presentAnimationStyleLeftFunc];
                break;
            case PresentAnimationStyleLeft_right:
                [weakSelf.presentAnimationHandler presentAnimationStyleLeft_rightFunc];
                break;
            default:
                [weakSelf
                 customPresentAnimationFuncWithToVc:toVC
                 andToView:toView
                 andFromVc:fromVC
                 andFromView:fromView
                 andAnimaterView:weakSelf.animationView];
        }
    }];
}

- (void) setupDismissAnimation {
    __weak typeof(self) weakSelf = self;
    [self.animation_animater dismissAnimaWithBlock:^(UIViewController *toVC, UIViewController *fromVC, UIView *toView, UIView *fromView) {
        
        if (!weakSelf.animationView) {
            NSLog(@"🌶 没有设置animationView 不能执行动画");
        }
        
        fromView = fromView ? fromView : fromVC.view;
        toView = toView ? toView : toVC.view;
        
        [weakSelf dismissAnimationBeginBlockFunc];
        
        [weakSelf
         setupAnimationHandler:weakSelf.dismissAnimationHandler
         andToVc:toVC
         andToView:toView
         andFromVc:fromVC
         andFromView:fromView
         andAnimaterView:weakSelf.animationView
         andOriginFromViewFrame:weakSelf.animation_fromeViewFrame];
        
        switch (weakSelf.presentConfig.dismissStyle) {
            case DismissAnimationStyleNull:
                [weakSelf.dismissAnimationHandler dismissNullAnimationFunc];
                break;
            case DismissAnimationStyleZoom:
                [weakSelf.dismissAnimationHandler dismissZoomAnimationFunc];
                break;
            case DismissAnimationStyleUp_bottom:
                [weakSelf.dismissAnimationHandler dismissAnimationStyleUp_bottomAnimationFunc];
                break;
            case DismissAnimationStyleBottom_Up:
                [weakSelf.dismissAnimationHandler dismissAnimationStyleBottom_UpFunc];
                break;
            case DismissAnimationStyleLeft_Right:{
                
                [weakSelf.dismissAnimationHandler dismissAnimationStyleLeft_RightFunc];
            }
                break;
            case DismissAnimationStyleRight_Left:
                [weakSelf.dismissAnimationHandler dismissAnimationStyleRight_LeftFunc];
                break;
            default:
                [weakSelf
                 customDismissAnimationFuncWithToVc:toVC
                 andToView:toView
                 andFromVc:fromVC
                 andFromView:fromView
                 andAnimaterView:weakSelf.animationView];
        }
    }];
}

// present animation func
- (void) presentCompletionFunc {
    self.animation_animater.isAccomplishAnima = true;
    if (self.presentAnimatingCompletion) {
        self.presentAnimatingCompletion(self.animationView, self.animation_fromeView);
    }
}

- (void) presetionAnimationBeginBlockFunc {
    if (self.presetionAnimationBeginBlock) {
        self.presetionAnimationBeginBlock(self.animationView,
                                          self.animation_fromeView);
    }
}

// dismiss animation func
- (void) dismissAnimationBeginBlockFunc {
    if (self.dismissAnimationBeginBlock) {
        self.dismissAnimationBeginBlock(self.animation_fromeView,
                                        self.animationView);
    }
}

- (void) dismissAnimationCompletionFunc {
    self.animation_animater.isAccomplishAnima = true;
    if (self.dismissAnimatingCompletion) {
        self.dismissAnimatingCompletion(self.animation_fromeView,
                                        self.animationView);
    }
}

// MARK: handle event
- (void) willDismissFunc: (BOOL(^)(BasePresentViewController *presentVC))willDismissBlock {
    self.willDismissBlock = willDismissBlock;
}

- (void) didDismissFunc: (void(^)(BasePresentViewController *presentVC))didDismissBlock {
    self.didDismissBlock = didDismissBlock;
}

- (void) clickBackgroundButtonBlockFunc:(BOOL (^)(BasePresentViewController *))clickCallBack {
    self.clickBackgroundButtonCallBack = clickCallBack;
}

- (void) clickBackgroundButtonFunc {
    
    if (self.clickBackgroundButtonCallBack) {
        if (!self.clickBackgroundButtonCallBack(self)) {
            return;
        }
    }
    [self dismissViewControllerAnimated:true completion:nil];
}

// MARK: properties get && set
- (BaseModalShadowAnimationConfig *)shadowAnimationConfig {
    if (!_shadowAnimationConfig) {
        _shadowAnimationConfig = [[BaseModalShadowAnimationConfig alloc]init];
        _shadowAnimationConfig.shadowAnimationView = self.animationView;
    }
    return _shadowAnimationConfig;
}

- (void) setAnimationView:(UIView *)animationView {
    _animationView = animationView;
    _shadowAnimationConfig.shadowAnimationView = animationView;
}

- (Animater *) animation_animater {
    if (!_animation_animater) {
        _animation_animater = [[Animater alloc]initWithModalPresentationStyle:UIModalPresentationCustom];
    }
    return _animation_animater;
}

- (BasePresentViewControllerConfiguration *)presentConfig {
    if (!_presentConfig) {
        _presentConfig = [[BasePresentViewControllerConfiguration alloc] init];
    }
    return _presentConfig;
}

- (UIButton *)backgroundButton {
    if (!_animation_backgroundButton) {
        _animation_backgroundButton = [UIButton new];
    }
    return _animation_backgroundButton;
}

- (BasePresentAnimationHandler *)presentAnimationHandler {
    if (!_presentAnimationHandler) {
        _presentAnimationHandler = [BasePresentAnimationHandler new];
    }
    return _presentAnimationHandler;
}

- (BaseDismissAnimationHandler *)dismissAnimationHandler {
    if (!_dismissAnimationHandler) {
        _dismissAnimationHandler = [BaseDismissAnimationHandler new];
    }
    return _dismissAnimationHandler;
}

- (void) setupAnimationHandler: (BaseAnimationHandler *) handler
                       andToVc: (UIViewController *)toVc
                     andToView: (UIView *)toView
                     andFromVc: (UIViewController *)fromVc
                   andFromView: (UIView *)fromView
               andAnimaterView: (UIView *)animaterView
        andOriginFromViewFrame: (CGRect)originFromViewFrame  {
    
    handler.fromVc = fromVc;
    handler.fromView = fromView;
    handler.toVc = toVc;
    handler.toView = toView;
    handler.animationView = animaterView;
    handler.presentConfig = self.presentConfig;
    handler.originFromViewFrame = originFromViewFrame;
    [handler setValue:self forKey:@"presentViewController"];
}

// MARK:life cycles
- (void)dismissViewControllerAnimated:(BOOL)flag
                           completion:(void (^)(void))completion {
    if (self.willDismissBlock) {
        BOOL isDismiss = self.willDismissBlock(self);
        if (!isDismiss) return;
    }
    
    [super dismissViewControllerAnimated:flag completion:^{
        
        if (self.didDismissBlock) {
            self.didDismissBlock(self);
        }
        if (completion) {
            completion();
        }
    }];
}

- (CGRect) presentFromViewFrame {
    CGFloat x = self.presentConfig.presentFromViewX;
    CGFloat y = self.presentConfig.presentFromViewY;
    if (x >= 0 || y >= 0) {
        CGFloat w = self.animation_fromeViewFrame.size.width;
        CGFloat h = self.animation_fromeViewFrame.size.height;
        return CGRectMake(x, y, w, h);
    }
    return CGRectZero;
}

- (void) presentAnimationBegin:(void (^)(UIView *, UIView *))block andCompletion:(void (^)(UIView *, UIView *))completion{
    self.presetionAnimationBeginBlock = block;
    self.presentAnimatingCompletion = completion;
}

- (void) dismissAnimationBegin:(void (^)(UIView *, UIView *))block andCompletion:(void (^)(UIView *, UIView *))completion{
    self.dismissAnimationBeginBlock = block;
    self.dismissAnimatingCompletion = completion;
}

- (void) presentBeginBasicAnimation: (BasicAnimationBlock) present {
    self.presentBeginBasicAnimationBlock = present;
}

- (void) dismissBeginBasicAnimation: (BasicAnimationBlock) dismiss {
    self.dismissBeginBasicAnimationBlock = dismiss;
}

- (BasePresentNavigationController *) getPresentNavigationController {
    if ([self.navigationController isKindOfClass:[BasePresentNavigationController class]]) {
        return (BasePresentNavigationController *)self.navigationController;
    }
    return nil;
}

- (BasePresentNavigationController *)addNavigationController {
    BasePresentNavigationController *presentNavigationController = [[BasePresentNavigationController alloc]init];
    [presentNavigationController setValue:self forKey:@"presentViewController"];
    [presentNavigationController setValue:self.animation_animater forKey:@"animation_animater"];
    return presentNavigationController;
}

- (BasePresentNavigationController *)presentNavigationController {
    BasePresentNavigationController *vc = _presentNavigationController;
    if (!vc) {
        BasePresentNavigationController *presentNavigationController = [self addNavigationController];
        _presentNavigationController = presentNavigationController;
        vc = presentNavigationController;
        self.navBarView.alpha = 1;
    }
    return vc;
}

- (void)customPresentAnimationFuncWithToVc:(UIViewController *)toVc andToView:(UIView *)toView andFromVc:(UIViewController *)fromVc andFromView:(UIView *)fromView andAnimaterView:(UIView *)animaterView {
    [self presentCompletionFunc];
}

- (void) customDismissAnimationFuncWithToVc:(UIViewController *)toVc andToView:(UIView *)toView andFromVc:(UIViewController *)fromVc andFromView:(UIView *)fromView andAnimaterView:(UIView *)animaterView {
    [self dismissAnimationCompletionFunc];
}

- (BaseNavigationBarView *)navBarView {
    if (!_navBarView) {
        _navBarView = [BaseNavigationBarView new];
        _navBarView.alpha = 0;
    }
    return _navBarView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:true];
}
@end
