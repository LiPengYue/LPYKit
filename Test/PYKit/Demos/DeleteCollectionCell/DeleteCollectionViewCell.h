//
//  DeleteCollectionViewCell.h
//  PYkit
//
//  Created by 衣二三 on 2019/5/22.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DelegateModel.h"


NS_ASSUME_NONNULL_BEGIN
@class DeleteCollectionViewCell;
@protocol DeleteCollectionViewCellDelegate <NSObject>

- (void) longPressGestureWithIndex: (NSIndexPath *)index;
- (void) deleteWithIndex: (NSIndexPath *)index;
@end

@interface DeleteCollectionViewCell : UICollectionViewCell
@property (nonatomic,weak) id <DeleteCollectionViewCellDelegate>delegate;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) DelegateModel *model;
@property (nonatomic,assign) BOOL isShowMaskView;
@end

NS_ASSUME_NONNULL_END
