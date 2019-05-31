//
//  ViewShadowConfigration.h
//  PYKit
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewShadowConfigration : NSObject

+ (ViewShadowConfigration *(^)(CALayer *layer)) create;

/**
  阴影动画 offset fromValue
 */
- (ViewShadowConfigration *(^)(CGSize size)) setUpFromShadowOffset;
@property (nonatomic,assign) CGSize shadowFromOffset;

/**
 阴影 透明度 动画 fromValue
 */
- (ViewShadowConfigration *(^)(CGFloat opacity)) setUpFromShadowOpacity;
@property (nonatomic,assign) CGFloat shadowFromOpacity;

/**
 阴影 color 动画 fromValue
 */
- (ViewShadowConfigration *(^)(UIColor *color)) setUpFromShadowColor;
@property (nonatomic,strong) UIColor *shadowFromColor;

/**
 阴影动画 offset toValue
 */
- (ViewShadowConfigration *(^)(CGSize size)) setUpToShadowOffset;
@property (nonatomic,assign) CGSize shadowToOffset;

/**
 阴影 透明度 动画  toValue
 */
- (ViewShadowConfigration *(^)(CGFloat opacity)) setUpToShadowOpacity;
@property (nonatomic,assign) CGFloat shadowToOpacity;

/**
 阴影 color 动画  toValue
 */
- (ViewShadowConfigration *(^)(UIColor *color)) setUpToShadowColor;
@property (nonatomic,strong) UIColor *shadowToColor;

// 组动画的动画时长
- (CAAnimationGroup *(^)(CGFloat duration)) beginAnimationWithDuration;
@end
