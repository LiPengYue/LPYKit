//
//  BaseJsonViewEditHeaderView.h
//  PYkit
//
//  Created by 衣二三 on 2019/7/24.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseJsonViewStepModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseJsonViewEditHeaderView : UIView
@property (nonatomic,copy) void(^clickInsertArrayBlock)(void);
@property (nonatomic,copy) void(^clickInsertDicBlock)(void);
@property (nonatomic,copy) void(^clickInsertStringBlock)(void);
@property (nonatomic,copy) void(^clickInsertNumberBlock)(void);
@property (nonatomic,copy) void(^clickInsertDownBlock)(void);
@property (nonatomic,copy) void(^clickInsertJsonBlock)(void);
@property (nonatomic,copy) void(^clickShowIndexBlock)(BOOL isShow);
@property (nonatomic,strong)BaseJsonViewStepModel *editModel;

+ (CGFloat) getHeightWithWithModel: (BaseJsonViewStepModel *)model;
+ (instancetype)createWithFrame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
