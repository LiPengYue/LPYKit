//
//  BaseSize.h
//  Test
//
//  Created by 衣二三 on 2019/4/15.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseSize : NSObject
/// 导航条总高度  iphoneX 以下为64，以上为88
@property(class, nonatomic, readonly) CGFloat navTotalH;
/// 导航条高度
@property(class, nonatomic, readonly) CGFloat navBarH;
/// 电池栏高度
@property(class, nonatomic, readonly) CGFloat statusBarH;
/// 底部的homelBar高度
@property(class, nonatomic, readonly) CGFloat homeBarH;
/// 底部的导航栏高度
@property(class, nonatomic, readonly) CGFloat tabbarH;
/// 屏幕最大宽度
@property(class, nonatomic, readonly) CGFloat screenW;
/// 屏幕最大高度
@property(class, nonatomic, readonly) CGFloat screenH;
/// 祛除导航栏h 后的最大高度 screenH - NavTotalH
@property(class, nonatomic, readonly) CGFloat screen_navH;
/// 祛除导航栏与tabbar的高度
@property(class, nonatomic, readonly) CGFloat screen_nav_tabBarH;

+ (void) setNavTotalH: (CGFloat) h;
+ (void) setNavBarH: (CGFloat) h;
+ (void) setStatusBarH: (CGFloat) h;
+ (void) setHomeBarH: (CGFloat) h;
@end

NS_ASSUME_NONNULL_END
