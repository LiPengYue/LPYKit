//
//  AppDelegate.h
//  StarAnimation
//
//  Created by 李鹏跃 on 17/1/24.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BaseGradientViewDrawRadialConfig.h"
#import "BaseGradientViewLineConfig.h"

@interface BaseGradientView : UIView
/// 线性绘制
- (void) drawLineGradient: (void(^)(BaseGradientViewLineConfig *lineConfig))drawLine;
/// 扩散绘制
- (void) drawRadialGradient: (void(^)(BaseGradientViewDrawRadialConfig *radialConfig))drawRadial;
@end
