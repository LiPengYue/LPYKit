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
    .setUpIsLinkage(true);
    
    self.animationView = self.imageView;
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
