//
//  DebugNetWorkSearchTableViewCell.h
//  PYkit
//
//  Created by 衣二三 on 2019/7/2.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import "BaseTableHeaderFooterView.h"
#import "BaseDebugNetWorkDataStepModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DebugNetWorkSearchTableViewHeaderView : BaseTableHeaderFooterView
@property (nonatomic,copy) NSString *title;

+ (NSString *) getTitleWithModel: (BaseDebugNetWorkDataStepModel *)model;

+ (CGFloat) getHWithString: (NSString *)str;
@end

NS_ASSUME_NONNULL_END
