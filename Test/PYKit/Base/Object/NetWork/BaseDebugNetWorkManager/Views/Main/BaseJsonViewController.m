//
//  BaseJsonViewManager.h
//  PYKit
//
//  Created by 李鹏跃 on 2019/9/11.
//  Copyright © 2019年 13lipengyue. All rights reserved.
//


#import "BaseJsonViewController.h"
#import "BaseJsonViewSearchResultViewController.h"
#import "BaseJsonViewMainView.h"
#import "BaseObjectHeaders.h"
#import "BaseViewHeaders.h"
#import "BaseSize.h"
#import "BaseJsonHeaderView.h"

typedef enum : NSUInteger {
    BaseJsonViewController_popVc_none = 0,
    BaseJsonViewController_popVc_searchVc = 1,
    BaseJsonViewController_popVc_childrenPointVc,
} BaseJsonViewController_popType;

@interface BaseJsonViewController ()
@property (nonatomic,strong) BaseJsonViewMainView *mainView;
@property (nonatomic,strong) BaseJsonViewStepModel *model;
@property (nonatomic,strong) ScrollViewPanDirectionHandler *panHandler;
@property (nonatomic,strong) BaseJsonHeaderView *headerView;
@property (nonatomic,copy) NSString *searchKey;
@property (nonatomic,assign) BOOL isChanged;
@property (nonatomic,strong) NSArray <BaseJsonViewStepModel *>*searchResultModelArray;

@property (nonatomic,assign) NSInteger currentLevelOffset;
@property (nonatomic,assign) BaseJsonViewController_popType popType;
@property (nonatomic,assign) BOOL isHiddenHeaderView;
/// 剪切板
@property (nonatomic,strong) UIPasteboard *pasteboard;
@end

@implementation BaseJsonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self reloadNaviTitle];
    [self registerEvents];
}

- (void)revertViewWillAppear {
    switch (self.popType) {
        case BaseJsonViewController_popVc_searchVc:
             [self.mainView scrollToModel:self.headerView.currentPathModel];
            break;
        case BaseJsonViewController_popVc_childrenPointVc:
            [self.mainView reloadWithData:self.model];
            break;
        case BaseJsonViewController_popVc_none:
            [self.mainView reloadWithData:self.model];
            break;
    }
    self.popType = BaseJsonViewController_popVc_none;
   
}

// MARK: - init

#pragma mark - func

// MARK: setupTable

// MARK: network
- (void) reloadDataWithID: (id)data {
    [self.mainView reloadWithData:data];
    self.model = [self.mainView getCurrentModel];
    self.headerView.path = [self.model getTreeLayer];
}

- (void) registerEvents {
    [self registerheaderViewEvent];
    [self registerPanHandlerEvent];
    [self registeMainViewEvent];
}

- (void) registeMainViewEvent {
    __weak typeof(self)weakSelf = self;
    [self.mainView setJumpNextLevelVc:^(BaseJsonViewStepModel * _Nonnull model) {
        [weakSelf pushChildrenVcWithModel:model];
    }];
    [self regesterTableViewAction];
}

- (void) pushChildrenVcWithModel:(BaseJsonViewStepModel *)model {
    BaseJsonViewController *vc = [BaseJsonViewController new];
    vc.currentLevelOffset = model.level;
    vc.mainView.currentLevelOffset = vc.currentLevelOffset;
    [vc reloadDataWithID:model];
    self.popType = BaseJsonViewController_popVc_childrenPointVc;
    [self.navigationController pushViewController:vc animated:true];
}

- (void) registerPanHandlerEvent {
    __weak typeof (self) weakSelf = self;
    self.panHandler.up = ^{
        if (weakSelf.mainView.top != BaseSize.statusBarH || weakSelf.mainView.height != BaseSize.screenH -  BaseSize.statusBarH) {
            [weakSelf hiddenTopheaderView];
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.mainView.top = BaseSize.statusBarH;
                weakSelf.mainView.height = BaseSize.screenH -  BaseSize.statusBarH;
                weakSelf.navBarView.bottom = weakSelf.view.top;
                weakSelf.mainView.tableView.height = weakSelf.mainView.height;
            }];
        }
    };
    self.panHandler.down = ^{
        __block BOOL isShowTopHeaderView = false;
        [weakSelf.view endEditing:true];
        [weakSelf.navBarView.rightItems enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            isShowTopHeaderView = obj.isSelected;
            *stop = isShowTopHeaderView;
        }];
        if (isShowTopHeaderView) {
            [weakSelf showTopheaderView];
        }
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.navBarView.top = weakSelf.view.top;
            weakSelf.mainView.top = isShowTopHeaderView ? weakSelf.headerView.bottom : weakSelf.navBarView.bottom;
            weakSelf.mainView.height = weakSelf.view.height - weakSelf.navBarView.bottom;
            weakSelf.mainView.tableView.height = weakSelf.mainView.height;
        }];
    };
}

// MARK: handle views
- (void) setupViews {
    self.headerView.bottom = self.navBarView.top;
    self.headerView.width = self.view.width;
    [self.headerView layoutWithWidth:self.headerView.width];
    self.mainView.top = self.navBarView.bottom;
    
    self.mainView.height = BaseSize.screenH - self.mainView.top;
    self.mainView.width = self.view.width;
    [self.view addSubview: self.mainView];
    [self.view addSubview: self.headerView];
}

- (void) registerheaderViewEvent {
    __weak typeof(self)weakSelf = self;
    [self.headerView setSearchEditingBlock:^(NSString * _Nonnull key) {
        weakSelf.mainView.isEditingStatusSearch = key.length > 0;
    }];
    [self.headerView setSearchBlock:^(NSString * _Nonnull key) {
        weakSelf.searchKey = key;
        NSArray <BaseJsonViewStepModel *>*modelArray = [weakSelf.mainView.tableView searchAndOpenAllWithKey:key];
        weakSelf.searchResultModelArray = modelArray;
        weakSelf.headerView.searchResultCount = modelArray.count;
        weakSelf.headerView.currentPathModel = modelArray.firstObject;
        if (modelArray.count > 0) {
            [weakSelf.mainView scrollToModel:weakSelf.headerView.currentPathModel];
        }
        
    }];
    [self.headerView setClickAccurateSearchButton:^(BOOL isAccurateSearch) {
        weakSelf.mainView.isAccurateSearch = isAccurateSearch;
    }];
    [self.headerView setClickNext:^{
        [weakSelf scrollWtihIsNext:true];
    }];
    [self.headerView setClickFront:^{
        [weakSelf scrollWtihIsNext:false];
    }];
    [self.headerView setClickJumpResultVc:^{
        [weakSelf jumpResultVc];
    }];
}

- (void) regesterTableViewAction {
    __weak typeof(self)weakSelf = self;
    [self.mainView setDoubleClickCellBlock:^(BaseJsonViewStepModel * _Nonnull model) {
        
    }];
    [self.mainView setLongClickCellBlock:^(BaseJsonViewStepModel * _Nonnull model) {
        [weakSelf pushChildrenVcWithModel:model];
    }];
}

- (void) jumpResultVc {
    if (self.searchKey.length <= 0 && !self.mainView.isEditingStatusSearch) {
        self.headerView.messageStr = @"🌶 请先输入搜索内容";
        return;
    }
    if (self.searchResultModelArray.count <= 0) {
        self.headerView.messageStr = @"🌶 搜索数据为空";
        return;
    }
    BaseJsonViewSearchResultViewController *vc = [BaseJsonViewSearchResultViewController new];
    vc.currentSearchModel = self.headerView.currentPathModel;
    vc.modelArray = self.searchResultModelArray;
    __weak typeof(self)weakSelf = self;
    __weak typeof(vc) weakVc = vc;
    vc.searchKey = self.searchKey;
    [vc setClickCellBlock:^(BaseJsonViewStepModel * _Nonnull model) {
        [weakVc.navigationController popViewControllerAnimated:true];
        weakSelf.headerView.currentPathModel = model;
        [weakSelf.mainView scrollToModel:model];
    }];
    self.popType = BaseJsonViewController_popVc_searchVc;
    [self.navigationController pushViewController:vc animated:true];
}

- (void) scrollWtihIsNext: (BOOL) isNext {
    if (self.searchKey.length <= 0 && !self.mainView.isEditingStatusSearch) {
        self.headerView.messageStr = @"🌶 请先输入搜索内容";
        return;
    }
    if (self.searchResultModelArray.count <= 0) {
        self.headerView.messageStr = @"🌶 搜索数据为空";
        return;
    }
    NSInteger indexCurrent = [self.searchResultModelArray indexOfObject: self.headerView.currentPathModel];
    NSInteger indexNext = isNext ? indexCurrent + 1 : indexCurrent - 1;
    if (indexNext < 0) {
        indexNext = self.searchResultModelArray.count -1;
    }
    if (indexNext >= self.searchResultModelArray.count) {
        indexNext = 0;
    }//0x1c42850a0
    self.headerView.currentPathModel = [self.searchResultModelArray objectAtIndex:indexNext];
    
    [self.mainView scrollToModel:self.headerView.currentPathModel];
}

- (void) reloadNaviTitle {
    NSString *title =
    BaseStringHandler
    .handler(self.model.key)
    .setDefaultIfNull([self.model getSuperPointKey])
    .setDefaultIfNull(@"Json视图")
    .getStr;
    [self.navBarView.titleButton addTarget:self action:@selector(clickTitleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView.titleButton setTitle:title forState:UIControlStateNormal];
    self.navBarView
    .addRightItemWithTitleAndImg(@"🔍",nil)
    .addRightItemWithTitleAndImg(@"👀",nil);
    
    UIButton * button = self.navBarView.rightItems.lastObject;
    [button setTitle:@"👀all" forState:UIControlStateNormal];
    [button setTitle:@"🦆..." forState:UIControlStateSelected];
    
    __weak typeof (self)weakSelf = self;
    [self.navBarView clickRightButtonFunc:^(UIButton *button, NSInteger index) {
        [weakSelf.navBarView.rightItems enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if(![obj isEqual:button]) {
//                obj.selected = false;
//            }
        }];
        if (index == 0) {
            
            [weakSelf clickSearch:button];
        }else{
            [weakSelf clickEditing:button];
        }
    }];
    [self.navBarView reloadView];
}

- (void) clickTitleButtonAction: (UIButton *) button {
    [self.pasteboard setString:[self.model conversionToJson]];
}

- (void) clickSearch:(UIButton *)button {
    button.selected = !button.selected;
    [self.headerView getHWithEditModel:self.model andPathModel:self.headerView.currentPathModel andMaxW:self.view.width andIsSearch:true andAnimation:true];
    if (!button.selected) {
        [self hiddenTopheaderView];
    } else {
        [self showTopheaderView];
    }
    self.headerView.isSearch = true;
}

- (void) clickEditing: (UIButton *)button {
    if (self.model.type == BaseJsonViewStepModelType_String || self.model.type == BaseJsonViewStepModelType_Number) {
        return;
    }
    button.selected = !button.selected;
    if(button.selected) {
        [self.mainView openAll];
    }else{
        [self.mainView closeAll];
    }
    return;
    button.selected = !button.selected;
    [self.headerView getHWithEditModel:self.model andPathModel:self.headerView.currentPathModel andMaxW:self.view.width andIsSearch:false andAnimation:true];
    if (!button.isSelected) {
        [self hiddenTopheaderView];
    } else {
        [self showTopheaderView];
    }
    self.headerView.isSearch = false;
}

- (void) hiddenTopheaderView {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.headerView.bottom = self.navBarView.top;
        if (self.mainView.top != self.navBarView.bottom) {
            self.mainView.top = self.navBarView.bottom;
            self.mainView.height = BaseSize.screenH - self.mainView.top;
        }
    }];
}

- (void) showTopheaderView {
    self.isHiddenHeaderView = true;
    if (self.headerView.top == self.navBarView.bottom && self.headerView.bottom == self.mainView.top) {
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.headerView.top = self.navBarView.bottom;
        self.mainView.top = self.headerView.bottom;
        self.mainView.height = self.view.height - self.mainView.top;
        self.mainView.tableView.height = self.mainView.height;
    }];
}

- (NSString *) conversionToStr {
    return [self.model conversionToJson];
}

- (NSDictionary *) conversionToDic {
    return [self.model conversionToDic];
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

- (BaseJsonViewMainView *)mainView {
    if (!_mainView) {
        _mainView = [[BaseJsonViewMainView alloc]initWithFrame:CGRectZero];
    }
    return _mainView;
}

- (BaseJsonHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [BaseJsonHeaderView new];
    }
    return _headerView;
}

- (UIPasteboard *)pasteboard {
    if (!_pasteboard) {
        _pasteboard = [UIPasteboard generalPasteboard];
    }
    return _pasteboard;
}

@end

