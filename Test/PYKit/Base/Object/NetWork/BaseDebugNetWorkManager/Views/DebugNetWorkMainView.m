//
//  DebugNetWorkMainView.m
//  PYkit
//
//  Created by 衣二三 on 2019/7/1.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import "DebugNetWorkMainView.h"
#import "DebugNetWorkTableView.h"

@interface DebugNetWorkMainView()

@property (nonatomic,strong) BaseDebugNetWorkDataStepModel *model;

@end


@implementation DebugNetWorkMainView

// MARK: - init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViewsFunc];
    }
    return self;
}

#pragma mark - func
// MARK: reload data


// MARK: handle views
- (void) setupSubViewsFunc {
    [self addSubview:self.tableView];
}

// MARK: handle event
- (void) registerEventsFunc {
    
}

// MARK: get && set

- (void) reloadWithData:(id) data {
    if ([data isEqual:BaseDebugNetWorkDataStepModel.class]) {
        self.model = data;
    } else{
        self.model = BaseDebugNetWorkDataStepModel.createWithID(data);
    }
}

- (void) setModel:(BaseDebugNetWorkDataStepModel *)model {
    _model = model;
    self.tableView.model = model;
    [self.tableView reloadData];
}

- (DebugNetWorkTableView *)tableView {
    if (!_tableView) {
        _tableView = [[DebugNetWorkTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return _tableView;
}

- (BaseDebugNetWorkDataStepModel *) getCurrentModel {
    return self.model;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}

@end
