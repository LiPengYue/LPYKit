//
//  BaseJsonViewManager.h
//  PYKit
//
//  Created by 李鹏跃 on 2019/9/11.
//  Copyright © 2019年 13lipengyue. All rights reserved.
//


#import "BaseJsonEditViewController.h"

@interface BaseJsonEditViewController ()
@property (nonatomic,strong) BaseJsonViewStepModel *editingModel;
@end

@implementation BaseJsonEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNetWork];
    [self setupViews];
    [self registerEvents];
}
// MARK: - init


#pragma mark - func

// MARK: setupTable

// MARK: network
- (void) loadNetWork {
    
}
// MARK: handle views
- (void) setupViews {
    
}
// MARK: handle event
- (void) registerEvents {
    
}
// MARK: lazy loads

- (void)setOriginModel:(BaseJsonViewStepModel *)originModel {
    _originModel = originModel;
    self.editingModel = BaseJsonViewStepModel.createWithID([originModel conversionToDic]);
}

- (BaseJsonViewStepModel *) getChangedModel {
    return self.editingModel;
}

// MARK: systom functions

// MARK:life cycles


@end

