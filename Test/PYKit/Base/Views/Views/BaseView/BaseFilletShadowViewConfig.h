//
//  BaseFilletShadowViewConfig.h
//  PYKit
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^BaseFilletShadowViewConfigPropertyChangedBlock)(BOOL isShapeChanged, BOOL isShadowChanged);
@interface BaseFilletShadowViewConfig : NSObject

/**圆形的半径*/
@property (nonatomic,assign) CGFloat radius;
- (BaseFilletShadowViewConfig *(^)(CGFloat radius)) setUpRadius;

/**四个角的半径控制接口*/
@property (nonatomic,assign) CGFloat leftTopAddRadius;
- (BaseFilletShadowViewConfig *(^)(CGFloat leftTopAddRadius)) setUpLeftTopAddRadius;

@property (nonatomic,assign) CGFloat leftBottomAddRadius;
- (BaseFilletShadowViewConfig *(^)(CGFloat leftBottomAddRadius)) setUpLeftBottomAddRadius;

@property (nonatomic,assign) CGFloat rightTopAddRadius;
- (BaseFilletShadowViewConfig *(^)(CGFloat rightTopAddRadius)) setUpRightTopAddRadius;

@property (nonatomic,assign) CGFloat rightBottomAddRadius;
- (BaseFilletShadowViewConfig *(^)(CGFloat rightBottomAddRadius)) setUpRightBottonAddRadius;


// MARK: - shadow
/// 阴影的透明度
@property (nonatomic,assign) CGFloat shadowAlpha;
- (BaseFilletShadowViewConfig *(^)(CGFloat alpha)) setUpShadowAlpha;

/// 设置阴影的offset
@property (nonatomic,assign) CGSize shadowOffset;
- (BaseFilletShadowViewConfig *(^)(CGSize offset)) setUpShadowOffset;

/// 设置阴影的color
@property (nonatomic,strong) UIColor *shadowColor;
- (BaseFilletShadowViewConfig *(^)(UIColor *color)) setUpShadowColor;

/// 设置阴影的渐变圆角
@property (nonatomic,assign) CGFloat shadowRadius;
- (BaseFilletShadowViewConfig *(^)(CGFloat radius)) setUpShadowRadius;

@end
NS_ASSUME_NONNULL_END
