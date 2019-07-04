//
//  BaseDebugNetWorkManager.h
//  PYKit
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BaseDebugNetWorkManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface DebugNetWorkTableView : UITableView
/// 里面应该放的是字典 或者字符串
@property (nonatomic,strong) BaseDebugNetWorkDataStepModel *model;
@property (nonatomic,assign) BOOL isAutoClose;


- (NSMutableArray <BaseDebugNetWorkDataStepModel *>*) searchAndOpenAllWithKey: (NSString *)key;
@end

NS_ASSUME_NONNULL_END
