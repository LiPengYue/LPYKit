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
typedef enum : NSUInteger {
    BaseJsonEditingTableViewCell_editing = 1,
    BaseJsonEditingTableViewCell_selecteEditType,
} BaseJsonEditingTableViewCell_style;

@interface BaseJsonEditingTableViewCell : UITableViewCell

@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) NSIndexPath *superPointIndexPath;
@property (nonatomic,copy) void(^clickInsertArrayBlock)(void);
@property (nonatomic,copy) void(^clickInsertDicBlock)(void);
@property (nonatomic,copy) void(^clickInsertStringBlock)(void);
@property (nonatomic,copy) void(^clickInsertNumberBlock)(void);
@property (nonatomic,copy) void(^clickInsertDownBlock)(void);
@property (nonatomic,copy) void(^clickCancellButtonBlock)(void);
@property (nonatomic,copy) void(^clickInsertJsonBlock)(void);
@property (nonatomic,copy) void(^clickShowIndexBlock)(BOOL isShow);

@property (nonatomic,copy) BOOL(^textViewShouldBeginEditingBlock)(BaseJsonEditingTableViewCell *cell);

/// style
@property (nonatomic,assign) BaseJsonViewStepCellStatus status;
@property (nonatomic,strong) BaseJsonViewStepModel *editingModel;
+ (CGFloat) getHeithWithModel: (BaseJsonViewStepModel *)model;
@end

NS_ASSUME_NONNULL_END
