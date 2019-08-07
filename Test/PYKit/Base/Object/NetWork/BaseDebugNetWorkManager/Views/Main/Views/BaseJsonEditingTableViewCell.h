//
//  BaseJsonEditingTableViewCell.h
//  PYkit
//
//  Created by 衣二三 on 2019/7/27.
//  Copyright © 2019 衣二三. All rights reserved.
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

/// style
@property (nonatomic,assign) BaseJsonViewStepCellStatus status;
@property (nonatomic,strong) BaseJsonViewStepModel *editingModel;
+ (CGFloat) getHeithWithModel: (BaseJsonViewStepModel *)model;
@end

NS_ASSUME_NONNULL_END
