//
//  BaseJsonViewManager.h
//  PYKit
//
//  Created by 李鹏跃 on 2019/9/11.
//  Copyright © 2019年 13lipengyue. All rights reserved.
//

#import "BaseTableHeaderFooterView.h"
#import "BaseJsonViewStepModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseJsonViewSearchResultTableViewHeaderView : BaseTableHeaderFooterView
@property (nonatomic,copy) NSString *title;

+ (NSString *) getTitleWithModel: (BaseJsonViewStepModel *)model;

+ (CGFloat) getHWithString: (NSString *)str;
@end

NS_ASSUME_NONNULL_END
