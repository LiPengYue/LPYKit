//
//  DebugNetWorkSearchTableView.h
//  PYkit
//
//  Created by 衣二三 on 2019/7/2.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableView.h"
#import "BaseDebugNetWorkDataStepModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DebugNetWorkSearchTableView : BaseTableView
@property (nonatomic,assign) BOOL isAutoClose;
@property (nonatomic,strong) NSArray <BaseDebugNetWorkDataStepModel *>*modelArray;
@end

NS_ASSUME_NONNULL_END
