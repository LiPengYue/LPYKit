//
//  DebugNetWorkDataViewController.m
//  PYkit
//
//  Created by 衣二三 on 2019/7/1.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import "DebugNetWorkDataViewController.h"
#import "DebugNetWorkMainView.h"
#import "BaseObjectHeaders.h"
#import "BaseViewHeaders.h"
#import "BaseSize.h"


@interface DebugNetWorkDataViewController ()
@property (nonatomic,strong) DebugNetWorkMainView *mainView;
@property (nonatomic,strong) BaseDebugNetWorkDataStepModel *model;
@property (nonatomic,strong) ScrollViewPanDirectionHandler *panHandler;

@property (nonatomic,assign) BOOL isChanged;
@end

@implementation DebugNetWorkDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    self.panObserverScrollView = self.mainView.tableView;
    self.animationView = self.mainView;
    [self setupProperty];
}
// MARK: - init


#pragma mark - func

// MARK: setupTable

// MARK: network
- (void) reloadDataWithID: (id)data {
    [self.mainView reloadWithData:data];
    self.model = [self.mainView getCurrentModel];
    [self reloadNaviTitle];
}

// MARK: handle views
- (void) setupViews {
    [self.view addSubview: self.mainView];
}

- (void) setupProperty {
    __weak typeof(self)weakSelf = self;
    [self setSearchBlock:^(NSString * _Nonnull key) {
         weakSelf.searchResultCount = [weakSelf.mainView.tableView searchAndOpenAllWithKey:key].count;
    }];
}

- (void) reloadNaviTitle {
    NSString *title =
    BaseStringHandler
    .handler(self.model.key)
    .setDefaultIfNull(@"网络数据")
    .getStr;
    self.titleStr = title;
}

// MARK: handle event


// MARK: get && set
- (ScrollViewPanDirectionHandler *)panHandler {
    if (!_panHandler) {
        _panHandler = [ScrollViewPanDirectionHandler new];
        _panHandler.scrollView = self.mainView.tableView;
    }
    return _panHandler;
}

- (DebugNetWorkMainView *)mainView {
    if (!_mainView) {
        _mainView = [DebugNetWorkMainView new];
    }
    return _mainView;
}

// MARK: systom functions

// MARK:life cycles


@end

