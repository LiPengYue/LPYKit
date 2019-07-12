//
//  BaseJsonViewController.m
//  PYkit
//
//  Created by 衣二三 on 2019/7/1.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import "BaseJsonViewController.h"
#import "BaseJsonViewSearchResultViewController.h"
#import "BaseJsonViewMainView.h"
#import "BaseJsonViewSearchView.h"
#import "BaseObjectHeaders.h"
#import "BaseViewHeaders.h"
#import "BaseSize.h"


@interface BaseJsonViewController ()
@property (nonatomic,strong) BaseJsonViewMainView *mainView;
@property (nonatomic,strong) BaseJsonViewStepModel *model;
@property (nonatomic,strong) ScrollViewPanDirectionHandler *panHandler;
@property (nonatomic,strong) BaseJsonViewSearchView *searchView;
@property (nonatomic,copy) NSString *searchKey;
@property (nonatomic,assign) BOOL isChanged;
@property (nonatomic,strong) NSArray <BaseJsonViewStepModel *>*searchResultModelArray;
@end

@implementation BaseJsonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self reloadNaviTitle];
    [self registerEvents];
    
    self.searchView.bottom = self.navBarView.top;
    self.mainView.top = self.navBarView.bottom;
    self.mainView.height = BaseSize.screenH - self.mainView.top;
}
// MARK: - init


#pragma mark - func

// MARK: setupTable

// MARK: network
- (void) reloadDataWithID: (id)data {
    [self.mainView reloadWithData:data];
    self.model = [self.mainView getCurrentModel];
}

- (void) registerEvents {
    [self registerSearchViewEvent];
    [self registerPanHandlerEvent];
}

- (void) registerPanHandlerEvent {
    __weak typeof (self) weakSelf = self;
    self.panHandler.up = ^{
        if (weakSelf.mainView.top != BaseSize.statusBarH || weakSelf.mainView.height != BaseSize.screenH -  BaseSize.statusBarH) {
            [weakSelf hiddenTopSearchView];
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.mainView.top = BaseSize.statusBarH;
                weakSelf.mainView.height = BaseSize.screenH -  BaseSize.statusBarH;
                weakSelf.navBarView.bottom = weakSelf.view.top;
                weakSelf.mainView.tableView.height = weakSelf.mainView.height;
            }];
        }
    };
    self.panHandler.down = ^{
        
        if (weakSelf.navBarView.rightItems.firstObject.isSelected) {
            [weakSelf showTopSearchView];
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.navBarView.top = weakSelf.view.top;
            weakSelf.mainView.top = weakSelf.navBarView.rightItems.firstObject.selected ? weakSelf.searchView.bottom : weakSelf.navBarView.bottom;
            weakSelf.mainView.height = BaseSize.screen_navH;
            weakSelf.mainView.tableView.height = weakSelf.mainView.height;
        }];
    };
}

// MARK: handle views
- (void) setupViews {
    [self.view addSubview: self.mainView];
    [self.view addSubview: self.searchView];
}

- (void) registerSearchViewEvent {
    __weak typeof(self)weakSelf = self;
    [self.searchView setSearchBlock:^(NSString * _Nonnull key) {
        weakSelf.searchKey = key;
        NSArray <BaseJsonViewStepModel *>*modelArray = [weakSelf.mainView.tableView searchAndOpenAllWithKey:key];
        weakSelf.searchResultModelArray = modelArray;
        weakSelf.searchView.searchResultCount = modelArray.count;
        weakSelf.searchView.currentSearchModel = modelArray.firstObject;
        if (modelArray.count > 0) {
            [weakSelf.mainView scrollToModel:weakSelf.searchView.currentSearchModel];
        }
        
    }];
    [self.searchView setClickAccurateSearchButton:^(BOOL isAccurateSearch) {
        weakSelf.mainView.isAccurateSearch = isAccurateSearch;
    }];
    [self.searchView setClickNext:^{
        [weakSelf scrollWtihIsNext:true];
    }];
    [self.searchView setClickFront:^{
        [weakSelf scrollWtihIsNext:false];
    }];
    [self.searchView setClickJumpResultVc:^{
        [weakSelf jumpResultVc];
    }];
}

- (void) regesterTableViewAction {
    [self.mainView setDoubleClickCellBlock:^(BaseJsonViewStepModel * _Nonnull model) {
        
    }];
}

- (void) jumpResultVc {
    if (self.searchKey.length <= 0) {
        self.searchView.massageStr = @"🌶 请先输入搜索内容";
        return;
    }
    if (self.searchResultModelArray.count <= 0) {
        self.searchView.massageStr = @"🌶 搜索数据为空";
        return;
    }
    BaseJsonViewSearchResultViewController *vc = [BaseJsonViewSearchResultViewController new];
    vc.currentSearchModel = self.searchView.currentSearchModel;
    vc.modelArray = self.searchResultModelArray;
    __weak typeof(self)weakSelf = self;
    __weak typeof(vc) weakVc = vc;
    vc.searchKey = self.searchKey;
    [vc setClickCellBlock:^(BaseJsonViewStepModel * _Nonnull model) {
        [weakVc.navigationController popViewControllerAnimated:true];
        weakSelf.searchView.currentSearchModel = model;
        [weakSelf.mainView scrollToModel:model];
    }];
    [self.navigationController pushViewController:vc animated:true];
}

- (void) scrollWtihIsNext: (BOOL) isNext {
    if (self.searchKey.length <= 0) {
        self.searchView.massageStr = @"🌶 请先输入搜索内容";
        return;
    }
    if (self.searchResultModelArray.count <= 0) {
        self.searchView.massageStr = @"🌶 搜索数据为空";
        return;
    }
    NSInteger indexCurrent = [self.searchResultModelArray indexOfObject: self.searchView.currentSearchModel];
    NSInteger indexNext = isNext ? indexCurrent + 1 : indexCurrent - 1;
    if (indexNext < 0) {
        indexNext = self.searchResultModelArray.count -1;
    }
    if (indexNext >= self.searchResultModelArray.count) {
        indexNext = 0;
    }//0x1c42850a0
    self.searchView.currentSearchModel = [self.searchResultModelArray objectAtIndex:indexNext];
    
    [self.mainView scrollToModel:self.searchView.currentSearchModel];
}

- (void) reloadNaviTitle {
    NSString *title =
    BaseStringHandler
    .handler(self.model.key)
    .setDefaultIfNull(@"网络数据")
    .getStr;
    [self.navBarView.titleButton setTitle:title forState:UIControlStateNormal];
    
    self.navBarView.addRightItemWithTitleAndImg(@"🔍",nil);
    
    __weak typeof (self)weakSelf = self;
    [self.navBarView clickRightButtonFunc:^(UIButton *button, NSInteger index) {
        [weakSelf clickTitle:button];
    }];
    [self.navBarView reloadView];
}

- (void) clickTitle:(UIButton *)titleButton {
    titleButton.selected = !titleButton.selected;
    if (titleButton.selected) {
        [self showTopSearchView];
    }else{
        [self hiddenTopSearchView];
    }
}


- (void) hiddenTopSearchView {
    
    [self.view endEditing:true];
    [UIView animateWithDuration:0.25 animations:^{
        self.searchView.bottom = self.navBarView.top;
        if (self.mainView.top != self.navBarView.bottom) {
            self.mainView.top = self.navBarView.bottom;
            self.mainView.height = BaseSize.screenH - self.mainView.top;
        }
    }];
}

- (void) showTopSearchView {
    [UIView animateWithDuration:0.25 animations:^{
        self.searchView.top = self.navBarView.bottom;
        self.mainView.top = self.searchView.bottom;
        self.mainView.height = BaseSize.screenH - self.mainView.top;
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
        _mainView = [[BaseJsonViewMainView alloc]initWithFrame:self.view.bounds];
    }
    return _mainView;
}

- (BaseJsonViewSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[BaseJsonViewSearchView alloc]initWithFrame: CGRectMake(0, 0, self.view.width, 0)];
        
        [_searchView layoutWithWidth:self.view.width]; _searchView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_searchView.bounds].CGPath;
        _searchView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.1].CGColor;
        _searchView.layer.shadowOffset = CGSizeMake(0, 3);
        _searchView.layer.shadowOpacity = 1;
        _searchView.layer.shadowRadius = 3;
    }
    return _searchView;
}

// MARK: systom functions

// MARK:life cycles

@end

