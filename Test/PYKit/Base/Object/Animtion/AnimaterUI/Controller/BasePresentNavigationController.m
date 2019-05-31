//
//  BasePresentNavigationController.m
//  yiapp
//
//  Created by 李鹏跃 on 2018/10/31.
//  Copyright © 2018年 yi23. All rights reserved.
//

#import "BasePresentNavigationController.h"
#import "BasePresentViewControllerConfiguration.h"
#import "BasePresentViewController.h"
#import "Animater.h"
#import "BaseDismissAnimationHandler.h"
#import "BasePresentAnimationHandler.h"

@interface BasePresentNavigationController ()
@property (nonatomic,strong) Animater *animation_animater;
@property (nonatomic,strong) UIButton *animation_backgroundButton;
@property (nonatomic,assign) CGRect animation_fromeViewFrame;
/// 在present 时 fromeview最终的frame
@property (nonatomic,assign) CGRect animation_presentFromViewFrame;
/// fromeView
@property (nonatomic,strong) UIView *animation_fromeView;

@property (nonatomic,copy) BOOL(^willDismissBlock)(BasePresentNavigationController *presentVC);
@property (nonatomic,copy) void(^didDismissBlock)(BasePresentNavigationController *presentVC);
@property (nonatomic,copy) BOOL(^clickBackgroundButtonCallBack)(BasePresentNavigationController *presentVC);
@property (nonatomic,copy) void(^presetionAnimationBeginBlock)(UIView *toView, UIView *fromeView);
@property (nonatomic,copy) void(^dismissAnimationBeginBlock)(UIView *toView,UIView *fromeView);
@property (nonatomic,copy) void(^dismissAnimatingCompletion)(UIView *toView, UIView *fromeView);
@property (nonatomic,copy) void(^presentAnimatingCompletion)(UIView *toView,UIView *fromeView);

// -------------

@property (nonatomic,strong) BasePresentAnimationHandler *presentAnimationHandler;
@property (nonatomic,strong) BaseDismissAnimationHandler *dismissAnimationHandler;

@end

@implementation BasePresentNavigationController

@synthesize animation_animater = _animation_animater;

- (void)dealloc {
    NSLog(@"✅ %@：被销毁",self);
}
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
    [self addChildViewController: self.presentViewController];
}


// MARK: properties get && set
- (Animater *) animation_animater {
    if (!_animation_animater) {
        _animation_animater = [[Animater alloc]initWithModalPresentationStyle:UIModalPresentationCustom];
    }
    return _animation_animater;
}

- (void) setAnimation_animater:(Animater *)animation_animater {
    _animation_animater = animation_animater;
    self.transitioningDelegate = self.animation_animater;
}
@end
