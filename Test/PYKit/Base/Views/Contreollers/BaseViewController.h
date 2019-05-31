//
//  BaseViewController.h
//  PYKit
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationBarView.h"
NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

@property (nonatomic,strong) BaseNavigationBarView *navBarView;
/// 是否穿透translucent
@property (nonatomic,assign) BOOL isTranslucent;

- (void)revertViewWillAppear;
- (void)revertViewDidAppear;
- (void)revertViewWillDisappear;
- (void)revertViewDidDisappear;
- (void)revertDealloc;
@end

NS_ASSUME_NONNULL_END
