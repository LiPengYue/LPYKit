//
//  BaseTableTestCell2.h
//  Test
//
//  Created by 衣二三 on 2019/4/16.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseTableTestCell2 : BaseTableViewCell
/// titleLabel
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * subTitleLabel;
@property (nonatomic,strong) void(^clickCallBack)(void);
@end

NS_ASSUME_NONNULL_END