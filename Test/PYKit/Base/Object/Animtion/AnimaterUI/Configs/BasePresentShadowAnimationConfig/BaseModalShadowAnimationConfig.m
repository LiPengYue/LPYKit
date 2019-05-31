//
//  BaseModalShadowAnimationConfig.m
//  Pods-PYTransitionAnimater_Example
//
//  Created by 李鹏跃 on 2018/11/2.
//

#import "BaseModalShadowAnimationConfig.h"

@interface BaseModalShadowAnimationConfig()

@end
@implementation BaseModalShadowAnimationConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.presentShadowRadius = 3;
        self.dismissShadowRadius = 3;
        self.presentShadowOpacity = 1;
        self.presentShadowColor = [UIColor colorWithWhite:0 alpha:0.06];
        
        self.dismissShadowOpacity = 1;
        self.dismissShadowColor = [UIColor colorWithWhite:0 alpha:0];
    }
    return self;
}

/// 开启动画 present 阴影动画
- (void) beginPresentAnimationWithDuration: (CGFloat) duration {
    [self present_animationViewShadowAnimation:duration];
}
/// 开启动画 dismiss 阴影动画
- (void) beginDismissAnimationWithDuration: (CGFloat) duration {
    [self dismiss_animationViewShadowAnimation:duration];
}

- (BaseModalShadowAnimationConfig *(^)(CGSize size)) setUpPresentShadowOffset {
    return ^(CGSize size) {
        self.presentShadowOffset = size;
        return self;
    };
}
- (BaseModalShadowAnimationConfig *(^)(CGFloat opacity)) setUpPresentShadowOpacity {
    return ^(CGFloat opacity) {
        self.presentShadowOpacity = opacity;
        return self;
    };
}

- (BaseModalShadowAnimationConfig *(^)(UIColor *color)) setUpPresentShadowColor {
    return ^(UIColor *color) {
        self.presentShadowColor = color;
        return self;
    };
}

- (BaseModalShadowAnimationConfig *(^)(CGSize size)) setUpDismissShadowOffset {
    return ^(CGSize size) {
        self.dismissShadowOffset = size;
        return self;
    };
}
- (BaseModalShadowAnimationConfig *(^)(CGFloat opacity)) setUpDismissShadowOpacity {
    return ^(CGFloat opacity) {
        self.dismissShadowOpacity = opacity;
        return self;
    };
}

- (BaseModalShadowAnimationConfig *(^)(UIColor *color)) setUpDismissShadowColor {
    return ^(UIColor *color) {
        self.dismissShadowColor = color;
        return self;
    };
}
- (BaseModalShadowAnimationConfig *(^)(CGFloat radius)) setUpPresentShadowRadius {
    return ^(CGFloat radius) {
        self.presentShadowRadius = radius;
        return self;
    };
}
- (BaseModalShadowAnimationConfig *(^)(CGFloat radius)) setUpDismissShadowRadius {
    return ^(CGFloat radius) {
        self.dismissShadowRadius = radius;
        return self;
    };
}

- (void) present_animationViewShadowAnimation: (CGFloat)duration {
    
    CAAnimationGroup *group = [[CAAnimationGroup alloc]init];
    
    CABasicAnimation *shadowOffset_anim;
    CABasicAnimation *opacity_anim;
    CABasicAnimation *color_anim;
    CABasicAnimation *radius_anim;
    
    
    CGSize toOffset = self.presentShadowOffset;
    CGSize fromOffset = self.dismissShadowOffset;
    shadowOffset_anim = [self shadowAnimationWithToOffset:toOffset
                                             andFromValue:fromOffset];
    CGFloat fromOpacity = self.dismissShadowOpacity;
    CGFloat toOpacity = self.presentShadowOpacity;
    opacity_anim = [self shadowAnimationWithToOpacity:toOpacity
                                       andFromOpacity:fromOpacity];
    
    UIColor *fromColor = self.dismissShadowColor;
    UIColor *toColor = self.presentShadowColor;
    color_anim = [self shadowAnimationWithColor:toColor
                                   andFromColor:fromColor];
    
    radius_anim = [self shadowAnimationWithToRadius:self.presentShadowRadius
                                      andFromRadius:self.dismissShadowRadius];
    
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:4];
    shadowOffset_anim ? [array addObject:shadowOffset_anim] : nil;
    opacity_anim ? [array addObject:opacity_anim] : nil;
    color_anim ? [array addObject:color_anim] : nil;
    radius_anim ? [array addObject:radius_anim] : nil;
    
    group.animations = array.copy;
    
    group.duration = duration;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.beginTime = 0;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.shadowAnimationView.layer addAnimation:group forKey:@"group"];
}


// - dismiss
- (void) dismiss_animationViewShadowAnimation: (CGFloat) duration {
    CAAnimationGroup *group = [[CAAnimationGroup alloc]init];
    
    CABasicAnimation *shadowOffset_anim;
    CABasicAnimation *opacity_anim;
    CABasicAnimation *color_anim;
    CABasicAnimation *radius_anim;
    
    shadowOffset_anim = [self shadowAnimationWithToOffset:self.dismissShadowOffset
                                             andFromValue:self.presentShadowOffset];
    opacity_anim = [self shadowAnimationWithToOpacity:self.dismissShadowOpacity andFromOpacity:self.presentShadowOpacity];
    
    
    color_anim = [self shadowAnimationWithColor:self.dismissShadowColor andFromColor:self.presentShadowColor];
    
    radius_anim = [self shadowAnimationWithToRadius:self.dismissShadowRadius andFromRadius:self.presentShadowRadius];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:4];
    shadowOffset_anim ? [array addObject:shadowOffset_anim] : nil;
    opacity_anim ? [array addObject:opacity_anim] : nil;
    color_anim ? [array addObject:color_anim] : nil;
    radius_anim ? [array addObject:radius_anim] : nil;
    
    group.animations = array.copy;
    
    group.duration = duration;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.beginTime = 0;
    
    [self.shadowAnimationView.layer addAnimation:group forKey:@"group"];
}

// MARK: - create animation
- (CABasicAnimation *) createBasicAnimationWithKey: (NSString *)key {
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:key];
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    return anim;
}

- (CABasicAnimation *)shadowAnimationWithToRadius:(CGFloat) toRadius
                                    andFromRadius: (CGFloat) fromRadius {
    CABasicAnimation *radiusAnimation = [self createBasicAnimationWithKey:@"shadowRadius"];
    radiusAnimation.fromValue = @(fromRadius);
    radiusAnimation.toValue = @(toRadius);
    return radiusAnimation;
}

- (CABasicAnimation *) shadowAnimationWithToOffset: (CGSize)toOffset andFromValue: (CGSize) fromOffset {
    if (CGSizeEqualToSize(fromOffset, CGSizeZero)
        && CGSizeEqualToSize(toOffset, CGSizeZero)) {
        return nil;
    }
    
    CABasicAnimation *shadowOffset_anim = [self createBasicAnimationWithKey:@"shadowOffset"];
    shadowOffset_anim.fromValue = [NSValue valueWithCGSize:fromOffset];
    shadowOffset_anim.toValue = [NSValue valueWithCGSize:toOffset];
    return shadowOffset_anim;
}

- (CABasicAnimation *) shadowAnimationWithToOpacity: (CGFloat) toOpacity andFromOpacity: (CGFloat) fromOpacity{
    CABasicAnimation *opacity_anim = [self createBasicAnimationWithKey:@"shadowOpacity"];
    opacity_anim.fromValue = @(fromOpacity);
    opacity_anim.toValue = @(toOpacity);
    return opacity_anim;
}
- (CABasicAnimation *) shadowAnimationWithColor: (UIColor *)toColor andFromColor:(UIColor *)fromColor {
    CABasicAnimation *color_anim = [self createBasicAnimationWithKey:@"shadowColor"];
    color_anim.fromValue = (__bridge id)fromColor.CGColor;
    color_anim.toValue = ((__bridge id)toColor.CGColor);
    return color_anim;
}

@end
