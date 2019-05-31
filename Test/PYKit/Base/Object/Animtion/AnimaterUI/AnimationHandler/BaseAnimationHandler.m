//
//  BaseAnimationHandler.m
//  Pods-PYTransitionAnimater_Example
//
//  Created by 李鹏跃 on 2018/11/5.
//

#import "BaseAnimationHandler.h"
#import "BasePresentViewControllerConfiguration.h"

@implementation BaseAnimationHandler
- (BOOL) isZeroRect: (CGRect)rect {
    return !rect.size.width && !rect.size.height;
}


- (CGRect) presentFromViewFrame {
    CGFloat x = self.presentConfig.presentFromViewX;
    CGFloat y = self.presentConfig.presentFromViewY;
    if (x >= 0 || y >= 0) {
        CGFloat w = self.fromView.frame.size.width;
        CGFloat h = self.fromView.frame.size.height;
        return CGRectMake(x, y, w, h);
    }
    return CGRectZero;
}

- (CGRect) getAnimationViewFrame {
    CGRect frame = self.animationView.frame;
    if (!frame.size.height || !frame.size.width) {
        [self.toView layoutIfNeeded];
        frame = self.animationView.frame;
    }
    return frame;
}
@end
