//
//  BaseJsonViewManager.h
//  PYKit
//
//  Created by 李鹏跃 on 2019/9/11.
//  Copyright © 2019年 13lipengyue. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BaseJsonViewStepModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseJsonViewSearchView : UIView

@property (nonatomic,copy) NSString *messageStr;

@property (nonatomic,assign) NSInteger searchResultCount;
@property (nonatomic,strong) BaseJsonViewStepModel *currentPathModel;
- (void) layoutWithWidth: (CGFloat) w;

@property (nonatomic,copy) void(^clickNext)(void);
@property (nonatomic,copy) void(^clickFront)(void);
@property (nonatomic,copy) void(^clickJumpResultVc)(void);
@property (nonatomic,copy) void(^clickAccurateSearchButton)(BOOL isAccurateSearch);
@property (nonatomic,copy) void(^searchBlock)(NSString *key);
@property (nonatomic,copy) void(^searchEditingBlock)(NSString *key);
@property (nonatomic,copy) NSString *path;

+ (CGFloat) getHeightWidthModel:(BaseJsonViewStepModel *)model;
@end

NS_ASSUME_NONNULL_END
