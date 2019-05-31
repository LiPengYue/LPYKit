//
//  BasePresentNavigationController.h
//  yiapp
//
//  Created by 李鹏跃 on 2018/10/31.
//  Copyright © 2018年 yi23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

@class BasePresentViewControllerConfiguration;
@class BasePresentViewController;

typedef void(^ BasicAnimationBlock)(CABasicAnimation *animation);


@interface BasePresentNavigationController : BaseNavigationController

@property (nonatomic,strong,readonly) BasePresentViewController *presentViewController;
@end
