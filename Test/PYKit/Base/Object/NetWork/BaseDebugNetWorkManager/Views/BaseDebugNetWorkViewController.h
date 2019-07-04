//
//  BaseDebugNetWorkViewController.h
//  PYkit
//
//  Created by 衣二三 on 2019/7/2.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseDebugNetWorkDataStepModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseDebugNetWorkViewController : BaseViewController

@property (nonatomic,copy) NSString *titleStr;


@property (nonatomic,strong) UIScrollView *panObserverScrollView;

/// 用于做动画的view
@property (nonatomic,strong) UIView *animationView;

@property (nonatomic,assign) NSInteger searchResultCount;

@property (nonatomic,copy) void(^clickNext)(void);
@property (nonatomic,copy) void(^clickFront)(void);
@property (nonatomic,copy) void(^clickJumpResultVc)(void);

@property (nonatomic,copy) void(^searchBlock)(NSString *key);
@end

NS_ASSUME_NONNULL_END
