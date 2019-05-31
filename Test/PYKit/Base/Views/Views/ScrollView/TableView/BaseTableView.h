//
//  BaseTableView.h
//  Test
//
//  Created by 衣二三 on 2019/4/15.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewDelegate.h"
#import "BaseTableViewDataSource.h"
#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseTableView : UIView
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic,weak) id <BaseTableViewDelegate> tableViewDelegate;
@property (nonatomic,weak) id <BaseTableViewDataSource> tableViewDataSource;



@property (nonatomic,assign) UITableViewStyle tableViewStyle;
@property (nonatomic,strong,readonly) UITableView *tableView;

/// 如果是baseTableViewCell
@property (nonatomic,assign) BOOL isHiddenSeparatorLine;
@property (nonatomic,assign) CGFloat separatorLineH;
@property (nonatomic,strong) UIColor *separatorColor;
@property (nonatomic,assign) UIEdgeInsets separatorLineEdge;
@end

NS_ASSUME_NONNULL_END
