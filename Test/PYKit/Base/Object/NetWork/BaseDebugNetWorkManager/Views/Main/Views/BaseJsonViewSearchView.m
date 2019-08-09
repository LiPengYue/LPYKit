//
//  BaseJsonViewManager.h
//  PYKit
//
//  Created by 李鹏跃 on 2019/9/11.
//  Copyright © 2019年 13lipengyue. All rights reserved.
//


#import "BaseJsonViewSearchView.h"
#import "BaseJsonViewCommon.h"
#import "BaseObjectHeaders.h"
#import "BaseViewHeaders.h"
#import "BaseSize.h"

@interface BaseJsonViewSearchView ()
<
UITextFieldDelegate,
UIScrollViewDelegate
>

@property (nonatomic,strong) UITextField *searchTextView;
@property (nonatomic,strong) UIButton *textFildBottomButton;

@property (nonatomic,strong) UIButton *showResultVc;
@property (nonatomic,strong) UIButton *scrollToNext;
@property (nonatomic,strong) UIButton *scrollToFront;
@property (nonatomic,strong) UIButton *accurateSearchButton;
@property (nonatomic,strong) UIButton *searchEditingButton;
@property (nonatomic,strong) UILabel *currentLevelTreeLabel;
@property (nonatomic,strong) UIScrollView *currentLevelTreeLabelBackgroundScrollView;
@end

@implementation BaseJsonViewSearchView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSelfStyle];
        [self layoutWithWidth: CGRectGetWidth(frame)];
        [self addSubview:self.searchTextView];
        [self addSubview:self.textFildBottomButton];
        [self addSubview:self.showResultVc];
        [self addSubview:self.scrollToNext];
        [self addSubview:self.scrollToFront];
        [self addSubview:self.accurateSearchButton];
        [self addSubview:self.searchEditingButton];
        [self addSubview: self.currentLevelTreeLabelBackgroundScrollView];
        [self.currentLevelTreeLabelBackgroundScrollView addSubview:self.currentLevelTreeLabel];
        
    }
    return self;
}

- (void) layoutWithWidth: (CGFloat) w {
    self.width = w;
    [self setupViews];
}

- (void) setupViews {

    self.searchTextView.top = 10;
    self.searchTextView.left = 12;
    self.searchTextView.width = self.width-24;
    self.searchTextView.height = 40;
    
    self.textFildBottomButton.top = self.searchTextView.bottom + 5;
    self.textFildBottomButton.left = self.searchTextView.left;
    self.textFildBottomButton.height = 15;
    
    self.scrollToFront.top = self.textFildBottomButton.top;
    self.scrollToFront.right = self.width - 14;
    
    self.scrollToNext.top = self.scrollToFront.bottom + 8;
    self.scrollToNext.right = self.scrollToFront.right;
    
    self.showResultVc.top = self.scrollToNext.top;
    self.showResultVc.right = self.scrollToNext.left - 12;
    
    // 查看概览
    self.showResultVc.top = self.scrollToFront.top;
    self.textFildBottomButton.width = self.showResultVc.left - self.textFildBottomButton.left - 12;
    
    self.accurateSearchButton.top = self.showResultVc.bottom + 5;
    self.accurateSearchButton.right = self.showResultVc.right;
    self.searchEditingButton.bottom = self.scrollToNext.bottom;
    self.searchEditingButton.right = self.accurateSearchButton.right;
    
    self.currentLevelTreeLabelBackgroundScrollView.left = self.textFildBottomButton.left;
    self.currentLevelTreeLabelBackgroundScrollView.width = self.textFildBottomButton.width;
    self.currentLevelTreeLabelBackgroundScrollView.top = self.textFildBottomButton.bottom;
    self.currentLevelTreeLabelBackgroundScrollView.height = self.scrollToNext.bottom - self.currentLevelTreeLabelBackgroundScrollView.top;
    
    self.height = self.scrollToNext.bottom + 10;
}

- (void)setupSelfStyle {
    self.backgroundColor = UIColor.whiteColor;
    
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    self.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.1].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 3);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 10;
}

- (void)setCurrentPathModel:(BaseJsonViewStepModel *)currentPathModel {
    _currentPathModel = currentPathModel;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenErrorMessage) object:nil];
    if (self.currentLevelTreeLabel.alpha < 1) {
        [UIView animateWithDuration:0.2 animations:^{
            self.currentLevelTreeLabel.alpha = 1;
        }];
    }
    self.currentLevelTreeLabel.textColor = normalColor;
    self.currentLevelTreeLabel.text = [currentPathModel getTreeLayer];
    [self layoutCurrentLevelTreeLabelH];
    
}

- (void) layoutCurrentLevelTreeLabelH {
    [self.currentLevelTreeLabelBackgroundScrollView setZoomScale:1 animated:true];
    self.currentLevelTreeLabel.height = BaseStringHandler.handler(self.currentLevelTreeLabel.text).getHeightWithWidthAndFont(self.currentLevelTreeLabelBackgroundScrollView.width,self.currentLevelTreeLabel.font);
    self.currentLevelTreeLabel.width = self.currentLevelTreeLabelBackgroundScrollView.width;
    self.currentLevelTreeLabelBackgroundScrollView.contentSize = CGSizeMake(0, self.currentLevelTreeLabel.height);
}

- (void)setMessageStr:(NSString *)messageStr {
    _messageStr = messageStr;
    [self errorMassage:messageStr];
}

- (void) errorMassage:(NSString *)str {
    self.currentLevelTreeLabel.textColor = errorColor;
    self.currentLevelTreeLabel.text = str;
    [self layoutCurrentLevelTreeLabelH];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenErrorMessage) object:nil];
    [self performSelector:@selector(hiddenErrorMessage) withObject:nil afterDelay:3];
}

- (void) hiddenErrorMessage {
    [UIView animateWithDuration:0.5 animations:^{
        self.currentLevelTreeLabel.alpha = 0;
    } completion:^(BOOL finished) {
        self.currentLevelTreeLabel.alpha = 1;
        self.currentPathModel = self.currentPathModel;
    }];
}

- (UITextField *)searchTextView {
    if (!_searchTextView) {
        _searchTextView = [[UITextField alloc]init];
        _searchTextView.delegate = self;
        _searchTextView.textColor = leftTitleColor;
        _searchTextView.returnKeyType = UIReturnKeySearch;
        _searchTextView.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchTextView.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        _searchTextView.placeholder = @"输入搜索内容";
        _searchTextView.layer.cornerRadius = 4;
        _searchTextView.layer.borderColor = messageColor.CGColor;
        _searchTextView.layer.borderWidth = 1;
        _searchTextView.leftViewMode = UITextFieldViewModeAlways;
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
        [_textFildBottomButton setTitle:@"搜索..." forState:UIControlStateNormal];
    }
    return _textFildBottomButton;
}

- (void) click_textFildBottomButton {
    // 跳转结果页
    [self endEditing:true];
}

/// showResultWithTree
- (UIButton *) showResultVc {
    if (!_showResultVc) {
        _showResultVc = [UIButton new];
        _showResultVc.height = 26;
        _showResultVc.width = 70;
        _showResultVc.layer.borderColor = normalColor.CGColor;
        
        [_showResultVc setTitle:@"在上级页面显示结果" forState:UIControlStateNormal];
        
        [_showResultVc setTitleColor:normalColor forState:UIControlStateNormal];
        
        [_showResultVc addTarget:self action:@selector(click_showResultWithTreeAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _showResultVc.layer.cornerRadius = 13;
        _showResultVc.layer.borderColor = messageColor.CGColor;
        _showResultVc.layer.borderWidth = 1;
        
        [_showResultVc setTitle:@"查看总览" forState:UIControlStateNormal];
        _showResultVc.titleLabel.font = BaseFont.fontSCL(12);
        
    }
    return _showResultVc;
}
- (void) click_showResultWithTreeAction:(UIButton *)button {
    [self endEditing:true];
    /// 在页面中显示
    if (self.clickJumpResultVc) self.clickJumpResultVc();
}

/// scrollToNext
- (UIButton *) scrollToNext {
    if (!_scrollToNext) {
        _scrollToNext = [UIButton new];
        _scrollToNext.width = 60;
        _scrollToNext.height = 40;
        [_scrollToNext setTitle:@"下一个" forState:UIControlStateNormal];
        
        [_scrollToNext setTitleColor:normalColor forState:UIControlStateNormal];
        
        [_scrollToNext addTarget:self action:@selector(click_scrollToNextAction:) forControlEvents:UIControlEventTouchUpInside];
        _scrollToNext.layer.cornerRadius = 6;
        _scrollToNext.layer.borderColor = messageColor.CGColor;
        _scrollToNext.layer.borderWidth = 1;
        
        _scrollToNext.titleLabel.font = BaseFont.fontSCL(12);
    }
    return _scrollToNext;
}

- (void) click_scrollToNextAction:(UIButton *)button {
    //    button.selected = !button.selected;
    //    button.backgroundColor = button.selected ? messageColor : UIColor.whiteColor;
    [self endEditing:true];
    if (self.clickNext) self.clickNext();
}

/// scrollToFront
- (UIButton *) scrollToFront {
    if (!_scrollToFront) {
        _scrollToFront = [UIButton new];
        _scrollToFront.width = 60;
        _scrollToFront.height = 40;
        [_scrollToFront setTitle:@"上一个" forState:UIControlStateNormal];
        
        [_scrollToFront setTitleColor:normalColor forState:UIControlStateNormal];
        
        [_scrollToFront addTarget:self action:@selector(click_scrollToFrontAction:) forControlEvents:UIControlEventTouchUpInside];
        _scrollToFront.layer.cornerRadius = 6;
        _scrollToFront.layer.borderColor = messageColor.CGColor;
        _scrollToFront.layer.borderWidth = 1;
        _scrollToFront.titleLabel.font = BaseFont.fontSCL(12);
    }
    return _scrollToFront;
}
- (void) click_scrollToFrontAction:(UIButton *)button {
    [self endEditing:true];
    if (self.clickFront) self.clickFront();
}

/// currentLevelTreeLabel
- (UILabel *) currentLevelTreeLabel {
    if (!_currentLevelTreeLabel) {
        _currentLevelTreeLabel = [[UILabel alloc] init];
        _currentLevelTreeLabel.frame = CGRectMake(0,0,0,0);
        _currentLevelTreeLabel.backgroundColor = UIColor.whiteColor;
        _currentLevelTreeLabel.textAlignment = NSTextAlignmentLeft;
        _currentLevelTreeLabel.font = BaseFont.fontSCL(9);
        _currentLevelTreeLabel.textColor = normalColor;
        _currentLevelTreeLabel.numberOfLines = 0;
    }
    return _currentLevelTreeLabel;
}

- (void) setPath:(NSString *)path {
    _path = path;
    [self setSearchResultCount:0];
}

- (void) setupMessage {
    NSString *str = @"";
    NSString *searchKey = self.searchTextView.text;
    if (self.searchEditingButton.selected) {
        searchKey = @"编辑中状态的数据";
    }
    if (searchKey.length > 0) {
        str =
        BaseStringHandler
        .handler(@"搜索：“")
        .addObjc(searchKey)
        .addObjc(@"”共 ")
        .addInt(self.searchResultCount)
        .addObjc(@" 个结果")
        .getStr;
    }else if (self.path.length > 0 && !self.searchTextView.editing){
        str = self.path;
    }else{
        str = @"搜索...";
    }
    [self.textFildBottomButton setTitle:str forState:UIControlStateNormal];
}

- (void)setSearchResultCount:(NSInteger)searchResultCount {
    _searchResultCount = searchResultCount;
    [self setupMessage];
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
    }else{
        str = @"搜索...";
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
    [self setSearchResultCount:0];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    [self setSearchResultCount:self.searchResultCount];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endEditing:false];
    [self delayDidChangeText];
    return YES;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.currentLevelTreeLabel;
}

/// accurateSearchButton;
- (UIButton *) accurateSearchButton {
    if (!_accurateSearchButton) {
        _accurateSearchButton = [UIButton new];
        [_accurateSearchButton setTitle:@"精准搜索" forState:UIControlStateNormal];
        [_accurateSearchButton setTitleColor:normalColor forState:UIControlStateNormal];
        
        _accurateSearchButton.layer.cornerRadius = 13;
        _accurateSearchButton.layer.borderColor = messageColor.CGColor;
        _accurateSearchButton.layer.borderWidth = 1;
        _accurateSearchButton.titleLabel.font = BaseFont.fontSCL(12);
        _accurateSearchButton.width = 70;
        _accurateSearchButton.height = 26;
        
        [_accurateSearchButton addTarget:self action:@selector(click_accurateSearchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _accurateSearchButton;
}

- (void) click_accurateSearchButtonAction:(UIButton *)button {
    button.selected = !button.selected;
    button.backgroundColor = button.selected ? messageColor : UIColor.whiteColor;
    [self endEditing:true];
    self.clickAccurateSearchButton(button.isSelected);
    if (self.clickAccurateSearchButton) {
        if (self.searchBlock) {
            self.searchBlock(self.searchTextView.text);
        }
    }
}

- (UIButton *)searchEditingButton {
    if (!_searchEditingButton) {
        _searchEditingButton = [UIButton new];
        [_searchEditingButton setTitle:@"搜Editing" forState:UIControlStateNormal];
        [_searchEditingButton setTitleColor:normalColor forState:UIControlStateNormal];
        
        _searchEditingButton.layer.cornerRadius = 13;
        _searchEditingButton.layer.borderColor = messageColor.CGColor;
        _searchEditingButton.layer.borderWidth = 1;
        _searchEditingButton.titleLabel.font = BaseFont.fontSCL(12);
        _searchEditingButton.width = 70;
        _searchEditingButton.height = 26;
        
        [_searchEditingButton addTarget:self action:@selector(click_searchEditingButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchEditingButton;
}

- (void) click_searchEditingButtonAction:(UIButton *)button {
    button.selected = !button.selected;
    button.backgroundColor = button.selected ? messageColor : UIColor.whiteColor;
    [self endEditing:true];

    NSString *key = @"";
    if (button.selected) {
        key = BaseJsonViewCommon_searchEditingKey;
        
    }
    if (self.searchEditingBlock) {
        self.searchEditingBlock(key);
    }
    if (self.searchBlock) {
        self.searchBlock(self.searchTextView.text);
    }
}

- (UIScrollView *)currentLevelTreeLabelBackgroundScrollView {
    if (!_currentLevelTreeLabelBackgroundScrollView) {
        _currentLevelTreeLabelBackgroundScrollView = [[UIScrollView alloc]init];
        _currentLevelTreeLabelBackgroundScrollView.delegate = self;
        _currentLevelTreeLabelBackgroundScrollView.minimumZoomScale = 1;
        _currentLevelTreeLabelBackgroundScrollView.maximumZoomScale = 3;
    }
    return _currentLevelTreeLabelBackgroundScrollView;
}
@end
