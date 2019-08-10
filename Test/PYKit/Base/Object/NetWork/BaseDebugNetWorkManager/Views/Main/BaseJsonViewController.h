//
//  BaseJsonViewManager.h
//  PYKit
//
//  Created by 李鹏跃 on 2019/9/11.
//  Copyright © 2019年 13lipengyue. All rights reserved.
//


#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

/// 必须保证 BaseJsonViewController 的NavigationController不为nil，否则会导致无法跳转新的控制器
@interface BaseJsonViewController : BaseViewController

/**
 刷新数据

 @param data 可以是 json串，可以是字典，也可以是一个普通的字符串
 */
- (void) reloadDataWithID: (id)data;

/// 把数据转成json，如果只是一个字符串，则返回字符串
- (NSString *) conversionToStr;

/**
 把数据 转成字典
 */
- (NSDictionary *) conversionToDic;

@end

NS_ASSUME_NONNULL_END
