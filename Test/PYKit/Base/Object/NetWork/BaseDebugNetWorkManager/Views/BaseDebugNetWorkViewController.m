//
//  BaseDebugNetWorkViewController.m
//  PYkit
//
//  Created by 衣二三 on 2019/7/2.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import "BaseDebugNetWorkViewController.h"
#import "BaseObjectHeaders.h"
#import "BaseViewHeaders.h"
#import "BaseSize.h"
#import "BaseDebugNetWorkCommon.h"

@interface BaseDebugNetWorkViewController ()
<
UITextFieldDelegate
>
@property (nonatomic,strong) ScrollViewPanDirectionHandler *panHandler;

@property (nonatomic,strong) UIView *topMenuView;
@property (nonatomic,strong) UITextField *searchTextView;
@property (nonatomic,strong) UIButton *textFildBottomButton;

@property (nonatomic,strong) UIView *messageMenuView;
@property (nonatomic,strong) UILabel *searchResultCountLabel;
@property (nonatomic,strong) UIButton *showResultVc;
@property (nonatomic,strong) UIButton *scrollToNext;
@property (nonatomic,strong) UIButton *scrollToFront;



@property (nonatomic,strong) UISwitch *showAllSwitch;

@end

@implementation BaseDebugNetWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.panHandler.scrollView = self.panObserverScrollView;
    [self.view addSubview:self.topMenuView];
    
    [self baseReloadNaviTitle];
    [self registerEvents];
}

- (void) baseReloadNaviTitle {
    
//    self.navBarView.addRightItemWithTitleAndImg(@"展开全部",nil);
    [self.navBarView reloadView];
//    [self.navBarView.rightItems enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        obj.layer.masksToBounds = true;
//        obj.layer.cornerRadius = obj.height/2.0f;
//    }];
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    [self setUpTitle];
}

- (void) setUpTitle {
    NSString *title =
    BaseStringHandler
    .handler(self.titleStr)
    .setDefaultIfNull(@"网络数据")
    .addObjc(@"↓")
    .getStr;
    
    [self.navBarView.titleButton setTitle:title forState:UIControlStateNormal];
    [self.navBarView reloadView];
}

// MARK: handle event
- (void) registerEvents {
    [self setupPanHandlerEvent];
    [self.navBarView.titleButton addTarget:self action:@selector(clickTitle:) forControlEvents:UIControlEventTouchUpInside];
    __weak typeof (self)weakSelf = self;
    [self.navBarView clickRightButtonFunc:^(UIButton *button, NSInteger index) {
        
    }];
    
}

- (void) clickTitle:(UIButton *)titleButton {
    titleButton.selected = !titleButton.selected;
    if (titleButton.selected) {
        [self showTopSearchView];
    }else{
        [self hiddenTopSearchView];
    }
}

- (void)setSearchResultCount:(NSInteger)searchResultCount {
    _searchResultCount = searchResultCount;
    
}
- (void) setupPanHandlerEvent {
    __weak typeof (self) weakSelf = self;
    self.panHandler.up = ^{
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.animationView.top = BaseSize.statusBarH;
            weakSelf.animationView.height = BaseSize.screenH - BaseSize.statusBarH;
            weakSelf.navBarView.bottom = weakSelf.view.top;
        }];
        [weakSelf hiddenTopSearchView];
    };
    self.panHandler.down = ^{
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.navBarView.top = weakSelf.view.top;
            weakSelf.animationView.top = weakSelf.navBarView.titleButton.selected ? weakSelf.topMenuView.bottom : weakSelf.navBarView.bottom;
            weakSelf.animationView.height = BaseSize.screen_navH;
        }];
        [weakSelf showTopSearchView];
    };
}

- (void) hiddenTopSearchView {
    self.navBarView.titleButton.selected = false;
    [self.view endEditing:true];
    [UIView animateWithDuration:0.2 animations:^{
        self.topMenuView.bottom = self.navBarView.top;
    }];
}

- (void) showTopSearchView {
    self.navBarView.titleButton.selected = true;
    [UIView animateWithDuration:0.2 animations:^{
        self.topMenuView.top = self.navBarView.bottom;
    }];
}
// MARK: - get set

- (void)setPanObserverScrollView:(UIScrollView *)panObserverScrollView {
    _panObserverScrollView = panObserverScrollView;
    self.panHandler.scrollView = panObserverScrollView;
}

- (ScrollViewPanDirectionHandler *)panHandler {
    if (!_panHandler) {
        _panHandler = [ScrollViewPanDirectionHandler new];
    }
    return _panHandler;
}

- (void)setAnimationView:(UIView *)animationView {
    _animationView = animationView;
    _animationView.frame = self.view.bounds;
    _animationView.top = BaseSize.navTotalH;
    _animationView.height = BaseSize.screen_navH;
}

- (UIView *)topMenuView {
    if (!_topMenuView) {
        _topMenuView = [UIView new];
        _topMenuView.backgroundColor = UIColor.whiteColor;
        _topMenuView.frame = CGRectMake(0, 0, BaseSize.screenW, 100);
        _topMenuView.bottom = 0;
        _topMenuView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_topMenuView.bounds].CGPath;
        _topMenuView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.1].CGColor;
        _topMenuView.layer.shadowOffset = CGSizeMake(0, 3);
        _topMenuView.layer.shadowOpacity = 1;
        _topMenuView.layer.shadowRadius = 10;
        
        [_topMenuView addSubview:self.searchTextView];
        [_topMenuView addSubview:self.textFildBottomButton];
        self.searchTextView.top = 10;
        self.searchTextView.left = 12;
        self.searchTextView.width = _topMenuView.width-24;
        self.searchTextView.height = 40;
        self.textFildBottomButton.top = self.searchTextView.bottom + 5;
        self.textFildBottomButton.left = self.searchTextView.left;
        self.textFildBottomButton.width = self.searchTextView.right;
        self.textFildBottomButton.height = 15;

        _topMenuView.height = self.textFildBottomButton.bottom + 10;
    }
    return _topMenuView;
}

- (UITextField *)searchTextView {
    if (!_searchTextView) {
        _searchTextView = [[UITextField alloc]init];
        _searchTextView.delegate = self;
        _searchTextView.textColor = leftTitleColor;
        _searchTextView.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchTextView.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        _searchTextView.placeholder = @"输入搜索内容";
        [self.searchTextView addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    }
    return _searchTextView;
}

- (UIButton *)textFildBottomButton {
    if (!_textFildBottomButton){
        _textFildBottomButton = [UIButton new];
        [_textFildBottomButton setTitleColor:leftTitleColor forState:UIControlStateNormal];
        _textFildBottomButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_textFildBottomButton addTarget:self action:@selector(click_textFildBottomButton) forControlEvents:UIControlEventTouchUpInside];
        _textFildBottomButton.titleLabel.font = BaseFont.fontSCL(12);
    }
    return _textFildBottomButton;
}

- (void) click_textFildBottomButton {
    // 跳转结果页
}

/// showResultWithTree
- (UIButton *) showResultVc {
    if (!_showResultVc) {
        _showResultVc = [UIButton new];
        [_showResultVc setTitle:@"在上级页面显示结果" forState:UIControlStateNormal];
        
        [_showResultVc setTitleColor:messageColor forState:UIControlStateNormal];
        
        [_showResultVc addTarget:self action:@selector(click_showResultWithTreeAction:) forControlEvents:UIControlEventTouchUpInside];
        _showResultVc.layer.cornerRadius = 20;
        _showResultVc.layer.borderColor = messageColor.CGColor;
        _showResultVc.layer.borderWidth = 1;
    }
    return _showResultVc;
}
- (void) click_showResultWithTreeAction:(UIButton *)button {
    /// 在页面中显示
    if (self.clickJumpResultVc) self.clickJumpResultVc();
}

/// scrollToNext
- (UIButton *) scrollToNext {
    if (!_scrollToNext) {
        _scrollToNext = [UIButton new];
        [_scrollToNext setTitle:@"下一个" forState:UIControlStateNormal];
        
        [_scrollToNext setTitleColor:messageColor forState:UIControlStateNormal];
        
        [_scrollToNext addTarget:self action:@selector(click_scrollToNextAction:) forControlEvents:UIControlEventTouchUpInside];
        _scrollToNext.layer.cornerRadius = 20;
        _scrollToNext.layer.borderColor = messageColor.CGColor;
        _scrollToNext.layer.borderWidth = 1;
    }
    return _scrollToNext;
}

- (void) click_scrollToNextAction:(UIButton *)button {
    if (self.clickNext) self.clickNext();
}

/// scrollToFront
- (UIButton *) scrollToFront {
    if (!_scrollToFront) {
        _scrollToFront = [UIButton new];
        [_scrollToFront setTitle:@"上一个" forState:UIControlStateNormal];
        
        [_scrollToFront setTitleColor:messageColor forState:UIControlStateNormal];
        
        [_scrollToFront addTarget:self action:@selector(click_scrollToFrontAction:) forControlEvents:UIControlEventTouchUpInside];
        _scrollToFront.layer.cornerRadius = 20;
        _scrollToFront.layer.borderColor = messageColor.CGColor;
        _scrollToFront.layer.borderWidth = 1;
    }
    return _scrollToFront;
}
- (void) click_scrollToFrontAction:(UIButton *)button {
    if (self.clickFront) self.clickFront();
}

/// searchResultCountLabel
- (UILabel *) searchResultCountLabel {
    if (!_searchResultCountLabel) {
        _searchResultCountLabel = [[UILabel alloc] init];
        _searchResultCountLabel.frame = CGRectMake(0,0,0,0);
        _searchResultCountLabel.backgroundColor = UIColor.whiteColor;
        _searchResultCountLabel.textAlignment = NSTextAlignmentLeft;
        _searchResultCountLabel.font = BaseFont.fontSCR(12);
        _searchResultCountLabel.textColor = messageColor;
    }
    return _searchResultCountLabel;
}

// MARK: - delegate

- (void) changedTextField: (UITextField *)textField {
    NSString *str = @"";
    
    if (textField.text.length > 0) {
        str =
        BaseStringHandler
        .handler(@"搜索：")
        .addObjc(textField.text)
        .getStr;
    }
    [self.textFildBottomButton setTitle:str forState:UIControlStateNormal];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayDidChangeText) object:nil];
    [self performSelector:@selector(delayDidChangeText) withObject:nil afterDelay:0.3];
}

- (void) delayDidChangeText  {
    if (self.searchBlock) {
        self.searchBlock(self.searchTextView.text);
    }
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

// MARK: - system
- (void) revertViewWillAppear {
    [self.view addSubview:self.topMenuView];
    [self.view addSubview:self.navBarView];
}
@end
