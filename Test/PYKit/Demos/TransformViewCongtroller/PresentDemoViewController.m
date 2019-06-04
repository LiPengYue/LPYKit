//
//  PresentViewController.m
//  PYkit
//
//  Created by 衣二三 on 2019/5/29.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import "PresentDemoViewController.h"
#import "BaseViewController.h"

@interface PresentDemoViewController ()

@property (nonatomic,strong) UIImageView *imageView;
@end

@implementation PresentDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self.view addSubview: self.imageView];
    self.imageView.frame = CGRectMake(0, 90, 100, self.view.frame.size.height-90);
    self.navBarView.alpha = self.isShowNavigetion;
    self
    .presentConfig
    .setUpPresentStyle(self.presentStyle)
    .setUpDismissStyle(self.dismissStyle)
    .setUpPresentStartAlpha(0)
    .setUpDismissEndAlpha(0)
    .setUpIsLinkage(self.isLinkage);
    
    self.shadowAnimationConfig
    .setUpDismissShadowOpacity(0.2)
    .setUpDismissShadowColor([UIColor colorWithWhite:0 alpha:0.06])
    .setUpPresentShadowColor([UIColor colorWithWhite:0 alpha:0.06])
    .setUpDismissShadowOffset(CGSizeMake(1, 1))
    .setUpPresentShadowOffset(CGSizeMake(10, 10));
    
    self.animationView = self.imageView;
    if (self.isHaveShadowAnimation) {
        [self setupAnimationLifeCycles];
    }
}

- (void) setupAnimationLifeCycles {
    __weak typeof(self)weakSelf = self;
    [self presentAnimationBegin:^(UIView *toView, UIView *fromeView) {
        // 转场动画将要开始
        //        NSLog(@"present 转场动画将要开始");
    } andCompletion:^(UIView *toView, UIView *fromeView) {
        //        NSLog(@"present 转场动画已经结束,开启阴影动画");
        [weakSelf.shadowAnimationConfig beginPresentAnimationWithDuration:0.5];
        
    }];
    
    [self dismissAnimationBegin:^(UIView *toView, UIView *fromeView) {
        //        NSLog(@"dismiss 转场动画将要开始,开启阴影动画");
        [weakSelf.shadowAnimationConfig beginDismissAnimationWithDuration:2];
    } andCompletion:^(UIView *toView, UIView *fromeView) {
        //        NSLog(@"dismiss 转场动画已经结束");
    }];
}

/// imageView
- (UIImageView *) imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.userInteractionEnabled = true;
        _imageView.backgroundColor = UIColor.whiteColor;
        _imageView.layer.cornerRadius = 6;
        _imageView.image = [UIImage imageNamed:@"1"];
    }
    return _imageView;
}


- (void) setupNav {
    self.navBarView.addRightItemWithTitleAndImg(nil,[UIImage imageNamed:@"arrow_right"]);
    __weak typeof(self)weakSelf = self;

    [self.navBarView clickRightButtonFunc:^(UIButton *button, NSInteger index) {
        BaseViewController *vc = [BaseViewController new];
        [weakSelf.navigationController pushViewController:vc animated:true];
    }];
    [self.navBarView reloadView];
}
@end
