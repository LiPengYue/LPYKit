//
//  BasePresentAnimationHandler.m
//  Pods-PYTransitionAnimater_Example
//
//  Created by 李鹏跃 on 2018/11/5.
//

#import "BasePresentAnimationHandler.h"
#import "BasePresentViewController.h"
#import "BasePresentViewControllerConfiguration.h"
#import "BasePresentViewController.h"


@implementation BasePresentAnimationHandler

// present animation func
- (void) presentAnimation: (void(^)(BasePresentAnimationHandler *weakSelf))block
       andCompletionBlock:(void(^)(BasePresentAnimationHandler *weakSelf))completion {
    
    __weak typeof(self)weakSelf = self;
    self.animationView.alpha = self.presentConfig.presentStartAlpha;
    self.toView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    
    [UIView animateWithDuration:self.presentConfig.presentDuration
                          delay:self.presentConfig.presentDelayDuration
                        options:self.presentConfig.presentAnimationOptions
                     animations:
     ^{
         
         weakSelf.animationView.alpha = 1;
         if (block) {
             block(weakSelf);
         }
         weakSelf.toView.backgroundColor = weakSelf.presentConfig.backgroundColor;
     } completion:^(BOOL finished) {
         
         if (completion) {
             completion(weakSelf);
         }
         
         [weakSelf presentCompletionFunc];
     }];
}

- (void) presentCompletionFunc {
    [self.presentViewController presentCompletionFunc];
}

- (void) presentNullAnimationFunc {
    [self presentAnimation:^(BasePresentAnimationHandler *weakSelf) {
    } andCompletionBlock:nil];
}

- (void) presentZoomAnimationFunc {
    
    self.animationView.transform = CGAffineTransformMakeScale(0, 0);
    [self presentAnimation:^(BasePresentAnimationHandler *weakSelf) {
        weakSelf.animationView.transform = CGAffineTransformMakeScale(1, 1);
    } andCompletionBlock:nil];
}

- (void) presentBottom_upAnimationFunc {
    CGRect originFrame = [self getAnimationViewFrame];
    CGRect frame = originFrame;
    frame.origin.y = CGRectGetMaxY(self.toView.frame);
    self.animationView.frame = frame;
    
    CGRect fromViewFrame = self.presentFromViewFrame;
    if ([self isZeroRect:fromViewFrame]) {
        fromViewFrame = self.fromView.frame;
        fromViewFrame.origin.y = -(frame.origin.y - originFrame.origin.y);
    }
    [self presentAnimation:^(BasePresentAnimationHandler *weakSelf) {
        weakSelf.animationView.frame = originFrame;
        if (weakSelf.presentConfig.isLinkage) {
            weakSelf.fromView.frame = fromViewFrame;
        }
    } andCompletionBlock:nil];
}

- (void) presentAnimationStyleLeftFunc {
    CGRect originFrame = [self getAnimationViewFrame];
    CGRect frame = originFrame;
    frame.origin.x = self.toView.frame.size.width;
    self.animationView.frame = frame;
    CGRect fromeViewFrame = self.presentFromViewFrame;
    if ([self isZeroRect:fromeViewFrame]) {
        fromeViewFrame = self.fromView.frame;
        
        fromeViewFrame.origin.x
        = CGRectGetMinX(originFrame)
        - CGRectGetWidth(fromeViewFrame)
        + CGRectGetMinX(fromeViewFrame);
    }
    [self presentAnimation:^(BasePresentAnimationHandler *weakSelf) {
        weakSelf.animationView.frame = originFrame;
        if (weakSelf.presentConfig.isLinkage) {
            weakSelf.fromView.frame = fromeViewFrame;
        }
    } andCompletionBlock:nil];
}

- (void) presentAnimationStyleUp_BottomFunc {
    
    CGRect originFrame = [self getAnimationViewFrame];
    CGRect frame = originFrame;
    frame.origin.y = -frame.size.height;
    self.animationView.frame = frame;
    
    CGRect fromeViewFrame = self.presentFromViewFrame;
    if ([self isZeroRect:fromeViewFrame]) {
        fromeViewFrame = self.fromView.frame;
        fromeViewFrame.origin.y = CGRectGetMaxY(originFrame);
    }
    [self presentAnimation:^(BasePresentAnimationHandler *weakSelf) {
        weakSelf.animationView.frame = originFrame;
        if (weakSelf.presentConfig.isLinkage) {
            weakSelf.fromView.frame = fromeViewFrame;
        }
    } andCompletionBlock:nil];
}

- (void) presentAnimationStyleLeft_rightFunc {
    CGRect originFrame = [self getAnimationViewFrame];
    CGRect frame = originFrame;
    frame.origin.x = -frame.size.width;
    self.animationView.frame = frame;
    CGRect fromeViewFrame = self.presentFromViewFrame;
    if ([self isZeroRect:fromeViewFrame]) {
        fromeViewFrame = self.fromView.frame;
        fromeViewFrame.origin.x = CGRectGetMaxX(originFrame);
    }
    [self presentAnimation:^(BasePresentAnimationHandler *weakSelf) {
        weakSelf.animationView.frame = originFrame;
        if (weakSelf.presentConfig.isLinkage) {
            weakSelf.fromView.frame = fromeViewFrame;
        }
    } andCompletionBlock:nil];
}


@end
