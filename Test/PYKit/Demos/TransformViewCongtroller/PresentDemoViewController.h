//
//  PresentViewController.h
//  PYkit
//
//  Created by 衣二三 on 2019/5/29.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import "BasePresentViewController.h"
#import "BaseAnimaterHeaders.h"

NS_ASSUME_NONNULL_BEGIN

@interface PresentDemoViewController : BasePresentViewController
@property (nonatomic,assign) PresentAnimationStyle presentStyle;
@property (nonatomic,assign) DismissAnimationStyle dismissStyle;
@property (nonatomic,assign) BOOL isShowNavigetion;
@property (nonatomic,assign) BOOL isHaveShadowAnimation;
@property (nonatomic,assign) BOOL isLinkage;
@end

NS_ASSUME_NONNULL_END
