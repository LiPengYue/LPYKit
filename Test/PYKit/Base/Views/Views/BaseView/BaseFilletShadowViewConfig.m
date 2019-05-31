//
//  BaseFilletShadowViewConfig.m
//  PYKit
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import "BaseFilletShadowViewConfig.h"
@interface BaseFilletShadowViewConfig ()
@property (nonatomic,strong) BaseFilletShadowViewConfigPropertyChangedBlock propertyChangeCallBack;
@end;

@implementation BaseFilletShadowViewConfig

- (BaseFilletShadowViewConfig *(^)(CGFloat radius)) setUpRadius {
    return ^(CGFloat radius) {
        self.radius = radius;
        return self;
    };
}
- (BaseFilletShadowViewConfig *(^)(CGFloat leftTopRadius)) setUpLeftTopAddRadius  {
    return ^(CGFloat radius) {
        self.leftTopAddRadius = radius;
        return self;
    };
}
- (BaseFilletShadowViewConfig *(^)(CGFloat leftBottomRadius)) setUpLeftBottomAddRadius {
    return ^(CGFloat radius) {
        self.leftBottomAddRadius = radius;
        return self;
    };
}
- (BaseFilletShadowViewConfig *(^)(CGFloat rightTopRadius)) setUpRightTopAddRadius {
    return ^(CGFloat radius) {
        self.rightTopAddRadius = radius;
        return self;
    };
}
- (BaseFilletShadowViewConfig *(^)(CGFloat rightBottomRadius)) setUpRightBottonAddRadius {
    return ^(CGFloat radius) {
        self.rightBottomAddRadius = radius;
        return self;
    };
}
- (BaseFilletShadowViewConfig *(^)(CGFloat alpha)) setUpAlpha {
    return ^(CGFloat alpha) {
//        self.alpha = alpha;
        return self;
    };
}

- (BaseFilletShadowViewConfig *(^)(CGFloat alpha)) setUpShadowAlpha {
    return ^(CGFloat alpha) {
        self.shadowAlpha = alpha;
        return self;
    };
}
- (BaseFilletShadowViewConfig *(^)(CGSize offset)) setUpShadowOffset {
    return ^(CGSize offset) {
        self.shadowOffset = offset;
        return self;
    };
}
- (BaseFilletShadowViewConfig *(^)(UIColor *color)) setUpShadowColor {
    return ^(UIColor *color) {
        self.shadowColor = color;
        return self;
    };
}
- (BaseFilletShadowViewConfig *(^)(CGFloat radius)) setUpShadowRadius {
    return ^ (CGFloat radius) {
        self.shadowRadius = radius;
        return self;
    };
}

- (void) runBlockWithChangeShape: (BOOL) isChangedShape andIsChangedShadow: (BOOL) isChangedShadow {
    if (self.propertyChangeCallBack) {
        self.propertyChangeCallBack(isChangedShape, isChangedShadow);
    }
}

- (void)setRadius:(CGFloat)radius {
    _radius = radius;
    [self runBlockWithChangeShape:true andIsChangedShadow:false];
}
- (void)setLeftTopAddRadius:(CGFloat)leftTopAddRadius {
    _leftTopAddRadius = leftTopAddRadius;
    [self runBlockWithChangeShape:true andIsChangedShadow:false];
}
- (void)setLeftBottomAddRadius:(CGFloat)leftBottomAddRadius {
    _leftBottomAddRadius = leftBottomAddRadius;
    [self runBlockWithChangeShape:true andIsChangedShadow:false];
}
- (void)setRightTopAddRadius:(CGFloat)rightTopAddRadius {
    _rightTopAddRadius = rightTopAddRadius;
    [self runBlockWithChangeShape:true andIsChangedShadow:false];
}
- (void)setRightBottomAddRadius:(CGFloat)rightBottomAddRadius {
    _rightBottomAddRadius = rightBottomAddRadius;
    [self runBlockWithChangeShape:true andIsChangedShadow:false];
}

- (void)setShadowAlpha:(CGFloat)shadowAlpha {
    _shadowAlpha = shadowAlpha;
    [self runBlockWithChangeShape:false andIsChangedShadow:true];
}
- (void)setShadowOffset:(CGSize)shadowOffset {
    _shadowOffset = shadowOffset;
    [self runBlockWithChangeShape:false andIsChangedShadow:true];
}
- (void)setShadowColor:(UIColor *)shadowColor {
    _shadowColor = shadowColor;
    [self runBlockWithChangeShape:false andIsChangedShadow:true];
}
- (void)setShadowRadius:(CGFloat)shadowRadius {
    _shadowRadius = shadowRadius;
    [self runBlockWithChangeShape:false andIsChangedShadow:true];
}
@end
