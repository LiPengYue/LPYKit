//
//  BaseJsonHeaderView.h
//  PYkit
//
//  Created by 衣二三 on 2019/7/25.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseJsonViewEditHeaderView.h"
#import "BaseJsonViewSearchView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseJsonHeaderView : UIView

@property (nonatomic,assign) BOOL isSearch;
@property (nonatomic,strong) BaseJsonViewStepModel *editModel;
@property (nonatomic,strong) BaseJsonViewStepModel *currentPathModel;
- (CGFloat) getHWithEditModel:(BaseJsonViewStepModel *)editModel andPathModel: (BaseJsonViewStepModel *)pathModel andMaxW: (CGFloat)maxW andIsSearch: (BOOL) isSearch andAnimation: (BOOL) isAnimation;

// MARK: - searchView
@property (nonatomic,copy) NSString *messageStr;
@property (nonatomic,assign) NSInteger searchResultCount;
- (void) layoutWithWidth: (CGFloat) w;
@property (nonatomic,copy) void(^clickNext)(void);
@property (nonatomic,copy) void(^clickFront)(void);
@property (nonatomic,copy) void(^clickJumpResultVc)(void);
@property (nonatomic,copy) void(^clickAccurateSearchButton)(BOOL isAccurateSearch);
@property (nonatomic,copy) void(^searchBlock)(NSString *key);
@property (nonatomic,copy) NSString *path;

//MARK: - editView
@property (nonatomic,copy) void(^clickShowIndexBlock)(BOOL isShow);

@end

NS_ASSUME_NONNULL_END
