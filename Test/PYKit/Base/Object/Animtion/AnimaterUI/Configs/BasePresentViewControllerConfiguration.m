//
//  BasePresentViewControllerConfiguration.m
//  Animation
//
//  Created by 李鹏跃 on 2018/8/24.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import "BasePresentViewControllerConfiguration.h"

@implementation BasePresentViewControllerConfiguration
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.presentDuration = 0.4;
        self.dismissDuration = 0.4;
        self.presentDelayDuration = 0;
        self.dismissDelayDuration = 0;
        
        self.presentStyle = PresentAnimationStyleNull;
        self.dismissStyle = DismissAnimationStyleNull;
       
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        
        self.presentAnimationOptions = UIViewAnimationOptionCurveEaseInOut;
        self.dismissAnimationOptions = UIViewAnimationOptionCurveEaseInOut;
        
        self.presentFromViewY = -1;
        self.presentFromViewX = -1;
        
        self.presentStartAlpha = 1;
        self.dismissEndAlpha = 1;
    }
    return self;
}

- (BasePresentViewControllerConfiguration *(^)(NSInteger style))setUpPresentStyle {
    return ^(NSInteger style) {
        self.presentStyle = style;
        return self;
    };
}
- (BasePresentViewControllerConfiguration *(^)(NSInteger style)) setUpDismissStyle {
    return ^(NSInteger style) {
        self.dismissStyle = style;
        return self;
    };
}
- (BasePresentViewControllerConfiguration *(^)(CGFloat duration)) setUpPresentDuration  {
    return ^(CGFloat duration) {
        self.presentDuration = duration;
        return self;
    };
}
- (BasePresentViewControllerConfiguration *(^)(CGFloat duration)) setUpDismissDuration  {
    return ^(CGFloat duration) {
        self.dismissDuration = duration;
        return self;
    };
}
- (BasePresentViewControllerConfiguration *(^)(CGFloat duration)) setUpPresentDelayDuration  {
    return ^(CGFloat duration) {
        self.presentDelayDuration = duration;
        return self;
    };
}
- (BasePresentViewControllerConfiguration *(^)(CGFloat duration)) setUpDismissDelayDuration {
    return ^(CGFloat duration) {
        self.dismissDelayDuration = duration;
        return self;
    };
}
- (BasePresentViewControllerConfiguration *(^)(UIViewAnimationOptions options)) setUpPresentAnimationOptions {
    return ^(UIViewAnimationOptions options) {
        self.presentAnimationOptions = options;
        return self;
    };
}
- (BasePresentViewControllerConfiguration *(^)(UIViewAnimationOptions options)) setUpDismissAnimationOptions {
    return ^(UIViewAnimationOptions options) {
        self.dismissAnimationOptions = options;
        return self;
    };
}
- (BasePresentViewControllerConfiguration *(^)(UIColor *color)) setUpBackgroundColor {
    return ^(UIColor *color) {
        self.backgroundColor = color;
        return self;
    };
}
- (BasePresentViewControllerConfiguration *(^)(CGFloat alpha)) setUpPresentStartAlpha {
    return ^(CGFloat alpha) {
        self.presentStartAlpha = alpha;
        return self;
    };
}
- (BasePresentViewControllerConfiguration *(^)(CGFloat alpha)) setUpDismissEndAlpha {
    return ^(CGFloat alpha) {
        self.dismissEndAlpha = alpha;
        return self;
    };
}
- (BasePresentViewControllerConfiguration *(^)(BOOL isLinkage)) setUpIsLinkage {
    return ^(BOOL isLinkage) {
        self.isLinkage = isLinkage;
        return self;
    };
}
- (BasePresentViewControllerConfiguration *(^)(CGFloat x)) setUpPresentFromViewX  {
    return ^(CGFloat x) {
        self.presentFromViewX = x;
        return self;
    };
}
- (BasePresentViewControllerConfiguration *(^)(CGFloat y)) setUpPresentFromViewY {
    return ^(CGFloat y) {
        self.presentFromViewY = y;
        return self;
    };
}
@end
