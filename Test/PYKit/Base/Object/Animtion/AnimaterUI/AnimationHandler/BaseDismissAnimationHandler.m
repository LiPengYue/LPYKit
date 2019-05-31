//
//  BaseDismissAnimationHandler.m
//  Pods-PYTransitionAnimater_Example
//
//  Created by 李鹏跃 on 2018/11/5.
//

#import "BaseDismissAnimationHandler.h"
#import "BasePresentViewController.h"
#import "BasePresentViewControllerConfiguration.h"
#import "BasePresentViewController.h"


@implementation BaseDismissAnimationHandler

- (void) dismissAnimation:(void(^)(BaseDismissAnimationHandler *weakSelf))block
       andCompletionBlock:(void(^)(BaseDismissAnimationHandler *weakSelf))completion {
    
    __weak typeof(self)weakSelf = self;
    [UIView
     animateWithDuration:self.presentConfig.dismissDuration
     delay:weakSelf.presentConfig.dismissDelayDuration
     options:weakSelf.presentConfig.dismissAnimationOptions
     animations:
     ^{
         self.animationView.alpha = weakSelf.presentConfig.dismissEndAlpha;
         if (block) {
             block(weakSelf);
         }
         self.fromView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
     } completion:^(BOOL finished) {
         if(completion) {
             completion(weakSelf);
         }
         [weakSelf dismissAnimationCompletionFunc];
     }];
}

- (void) dismissAnimationCompletionFunc {
    [self.presentViewController dismissAnimationCompletionFunc];
}

- (void) dismissNullAnimationFunc {
    CGRect toviewFrame = self.originFromViewFrame;
    if ([self isZeroRect:toviewFrame]) {
        toviewFrame = self.toView.frame;
        toviewFrame.origin.y = 0;
        toviewFrame.origin.x = 0;
    }
    
    [self dismissAnimation:^(BaseDismissAnimationHandler *weakSelf) {
        if (weakSelf.presentConfig.isLinkage) {
            weakSelf.toView.frame = toviewFrame;
        }
    } andCompletionBlock:nil];
}

- (void) dismissZoomAnimationFunc {
    CGRect toviewFrame = self.originFromViewFrame;
    if ([self isZeroRect:toviewFrame]) {
        toviewFrame = self.toView.frame;
        toviewFrame.origin.y = 0;
        toviewFrame.origin.x = 0;
    }
   
    [self dismissAnimation:^(BaseDismissAnimationHandler *weakSelf) {
        weakSelf.animationView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        if (weakSelf.presentConfig.isLinkage) {
            weakSelf.toView.frame = toviewFrame;
        }
    } andCompletionBlock:nil];
}

- (void) dismissAnimationStyleUp_bottomAnimationFunc {
    CGRect frame = [self getAnimationViewFrame];
    frame.origin.y = self.toView.frame.size.height;
    CGRect toviewFrame = self.originFromViewFrame;
    if ([self isZeroRect:toviewFrame]) {
        toviewFrame = self.toView.frame;
        toviewFrame.origin.y = 0;
    }
    [self dismissAnimation:^(BaseDismissAnimationHandler *weakSelf) {
        
        weakSelf.animationView.frame = frame;
        if (weakSelf.presentConfig.isLinkage) {
            weakSelf.toView.frame = toviewFrame;
        }
    } andCompletionBlock:nil];
}

- (void) dismissAnimationStyleBottom_UpFunc {
    CGRect frame = [self getAnimationViewFrame];
    frame.origin.y = -(frame.size.height);
    CGRect toviewFrame = self.originFromViewFrame;
    if ([self isZeroRect:toviewFrame]) {
        toviewFrame = self.toView.frame;
        toviewFrame.origin.y = 0;
    }
    [self dismissAnimation:^(BaseDismissAnimationHandler *weakSelf) {
        
        weakSelf.animationView.frame = frame;
        if (weakSelf.presentConfig.isLinkage) {
            weakSelf.toView.frame = toviewFrame;
        }
    } andCompletionBlock:nil];
}

- (void) dismissAnimationStyleLeft_RightFunc {
    CGRect originFrame = [self getAnimationViewFrame];
    originFrame.origin.x = self.toView.frame.size.width;
    
    CGRect toFrame = self.originFromViewFrame;
    if ([self isZeroRect:toFrame]) {
        toFrame = self.toView.frame;
        toFrame.origin.x = 0;
    }
    
    [self dismissAnimation:^(BaseDismissAnimationHandler *weakSelf) {
        if (weakSelf.presentConfig.isLinkage) {
            weakSelf.toView.frame = toFrame;
        }
        weakSelf.animationView.frame = originFrame;
        
    } andCompletionBlock:nil];
}

- (void) dismissAnimationStyleRight_LeftFunc {
    CGRect originFrame = [self getAnimationViewFrame];
    originFrame.origin.x = -CGRectGetWidth(originFrame);
    
    CGRect toFrame = self.originFromViewFrame;
    if ([self isZeroRect:toFrame]) {
        toFrame = self.toView.frame;
        toFrame.origin.x = 0;
    }
    
    [self dismissAnimation:^(BaseDismissAnimationHandler *weakSelf) {
        if (weakSelf.presentConfig.isLinkage) {
            weakSelf.toView.frame = toFrame;
        }
        weakSelf.animationView.frame = originFrame;
        
    } andCompletionBlock:nil];
}
@end
