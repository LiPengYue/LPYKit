//
//  BaseJsonViewManager.h
//  PYKit
//
//  Created by 李鹏跃 on 2019/9/11.
//  Copyright © 2019年 13lipengyue. All rights reserved.
//


#import "BaseJsonHeaderView.h"
#import "BaseJsonViewCommon.h"

@interface BaseJsonHeaderView()
@property (nonatomic,strong) BaseJsonViewSearchView *searchView;
@property (nonatomic,strong) BaseJsonViewEditHeaderView *editView;
@end

@implementation BaseJsonHeaderView


// MARK: - init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViewsFunc];
        self.layer.masksToBounds = true;
    }
    return self;
}

#pragma mark - func
// MARK: reload data
- (CGFloat) getHWithEditModel:(BaseJsonViewStepModel *)editModel andPathModel: (BaseJsonViewStepModel *)pathModel andMaxW: (CGFloat)maxW andIsSearch: (BOOL) isSearch andAnimation: (BOOL) isAnimation{
    self.width = maxW;
    self.editView.width = maxW;
    self.editModel = editModel;
    self.currentPathModel = pathModel;
    [self setIsSearch:isSearch andAnimation:true];
    return self.height;
}

- (void)setIsSearch:(BOOL)isSearch {
    [self setIsSearch:isSearch andAnimation:false];
}

- (void) setIsSearch: (BOOL) isSearch andAnimation:(BOOL) isAnimation {
    _isSearch = isSearch;
    CGFloat selfH = 0;
    if (isSearch) {
        [self addSubview:self.searchView];
        [self layoutWithWidth:self.width];
        selfH = self.searchView.height;
    }else{
        CGFloat h = [BaseJsonViewEditHeaderView getHeightWithWithModel:self.editModel];
        self.editView.height = h;
        [self addSubview:self.editView];
        selfH = h;
    }

    selfH += 2;
    if(isAnimation) {
        [UIView animateWithDuration:0.2 animations:^{
            self.height = selfH;
        }];
    }else{
        self.height = selfH;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

// MARK: handle views
- (void) setupSubViewsFunc {

}

// MARK: handle event
- (void) registerEventsFunc {
    
}

// MARK: get && set
- (BaseJsonViewSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[BaseJsonViewSearchView alloc]initWithFrame: CGRectMake(0, 0, 0, 0)];
        
        [_searchView layoutWithWidth:self.width]; _searchView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_searchView.bounds].CGPath;
        _searchView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.1].CGColor;
        _searchView.layer.shadowOffset = CGSizeMake(0, 3);
        _searchView.layer.shadowOpacity = 1;
        _searchView.layer.shadowRadius = 3;
    }
    return _searchView;
}

- (BaseJsonViewEditHeaderView *)editView  {
    if (!_editView) {
        _editView = [BaseJsonViewEditHeaderView createWithFrame:CGRectZero];
    }
    return _editView;
}

- (void)setEditModel:(BaseJsonViewStepModel *)editModel {
    _editModel = editModel;
    self.editView.editModel = editModel;
}

- (void)setCurrentPathModel:(BaseJsonViewStepModel *)currentPathModel {
    _currentPathModel = currentPathModel;
    self.searchView.currentPathModel = currentPathModel;
}

- (void)setMessageStr:(NSString *)messageStr {
    _messageStr = messageStr;
    self.searchView.messageStr = messageStr;
}

- (void)setSearchResultCount:(NSInteger)searchResultCount {
    _searchResultCount = searchResultCount;
    self.searchView.searchResultCount = searchResultCount;
}

- (void) layoutWithWidth: (CGFloat) w {
    [self.searchView layoutWithWidth:w];
}


- (void)setClickNext:(void (^)(void))clickNext {
    _clickNext = clickNext;
    self.searchView.clickNext = clickNext;
}
- (void)setClickFront:(void (^)(void))clickFront {
    _clickFront = clickFront;
    self.searchView.clickFront = clickFront;
}
- (void)setClickJumpResultVc:(void (^)(void))clickJumpResultVc {
    _clickJumpResultVc = clickJumpResultVc;
    self.searchView.clickJumpResultVc = clickJumpResultVc;
}
- (void)setClickAccurateSearchButton:(void (^)(BOOL))clickAccurateSearchButton {
    _clickAccurateSearchButton = clickAccurateSearchButton;
    self.searchView.clickAccurateSearchButton = clickAccurateSearchButton;
}
- (void)setSearchBlock:(void (^)(NSString * _Nonnull))searchBlock {
    _searchBlock = searchBlock;
    self.searchView.searchBlock = searchBlock;
    
}

- (void) setSearchEditingBlock:(void (^)(NSString * _Nonnull))searchEditingBlock {
    _searchEditingBlock = searchEditingBlock;
    self.searchView.searchEditingBlock = searchEditingBlock;
}

- (void)setPath:(NSString *)path {
    _path = path;
    self.searchView.path = path;
}


//MARK: edit
- (void)setClickShowIndexBlock:(void (^)(BOOL))clickShowIndexBlock {
    _clickShowIndexBlock = clickShowIndexBlock;
    self.editView.clickShowIndexBlock = clickShowIndexBlock;
}

// MARK: systom functions

// MARK:life cycles

@end


