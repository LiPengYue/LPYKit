//
//  DebugNetWorkTableView.m
//  Test
//
//  Created by 衣二三 on 2019/3/27.
//  Copyright © 2019年 衣二三. All rights reserved.
//

#import "DebugNetWorkTableView.h"
@interface DebugNetWorkTableView()
<
UITableViewDelegate,
UITableViewDataSource
>

@end
@implementation DebugNetWorkTableView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        [self setupViews];
    }
    return self;
}

- (void) setupViews {
    self.delegate = self;
    self.dataSource = self;
  
}

#pragma mark - dataSource


#pragma mark - delegate

@end
