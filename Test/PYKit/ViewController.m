//
//  ViewController.m
//  PYKit
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import "ViewController.h"
#import "BaseObjectHeaders.h"
#import "BaseViewHeaders.h"
#import "BaseSize.h"
#import "MainView.h"

@interface ViewController ()
@property (nonatomic,strong) MainView *mainView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self registerEvents];

//    [self setupNav];
}

- (void) setupNav {
    BaseNavigationBarView *barView = [BaseNavigationBarView new];
    barView.titleButtonHeight = 40;
    //    barView.titleButtonWidth = 40;
    barView.isHiddenBottomLine = false;
    barView.itemHeight = 40;
    barView
    .addTitleItemWithTitleAndImg(@"导航条",nil)
    .addLeftItemWithTitleAndImg(@"zuo",nil)
    .addLeftItemWithTitleAndImg(@"左sg边",nil)
    .addRightItemWithTitleAndImg(@"右sg边",nil)
    .addRightItemWithTitleAndImg(@"右sd边",nil);
    
    [barView clickLeftButtonFunc:^(UIButton *button, NSInteger index) {
        NSLog(@"✅左边%ld",index);
    }];
    [barView clickRightButtonFunc:^(UIButton *button, NSInteger index) {
        NSLog(@"✅右边%ld",index);
    }];
    
    [barView clickTitleButtonFunc:^(UIButton *button) {
        NSLog(@"✅ title");
    }];
    
    [self.view addSubview:barView];
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    barView.frame = CGRectMake(0, 0, w, 64);
    [barView reloadView];
}

- (void) setupView {
    CGRect rect = self.view.bounds;
    rect.origin.y = BaseSize.navTotalH;
    rect.size.height = BaseSize.screen_navH;
    self.mainView = [[MainView alloc] initWithFrame:rect];
    [self.view addSubview:self.mainView];
}

- (void) registerEvents {
    __weak typeof (self)weakSelf = self;
    [NSObject receivedWithSender:self.mainView andSignal:^id(NSString *key, id message) {
        if ([key isEqualToString:kClickMainView]) {
            if ([message isKindOfClass:UIViewController.class]) {
                UIViewController *vc = message;
                [weakSelf.navigationController pushViewController:vc animated:true];
            }
        }
        return nil;
    }];
}

@end
