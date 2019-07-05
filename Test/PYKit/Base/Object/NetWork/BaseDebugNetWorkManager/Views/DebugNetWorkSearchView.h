//
//  DebugNetWorkSearchView.h
//  PYkit
//
//  Created by 衣二三 on 2019/7/4.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseDebugNetWorkDataStepModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DebugNetWorkSearchView : UIView

@property (nonatomic,copy) NSString *massageStr;

@property (nonatomic,assign) NSInteger searchResultCount;
@property (nonatomic,strong) BaseDebugNetWorkDataStepModel *currentSearchModel;
- (void) layoutWithWidth: (CGFloat) w;

@property (nonatomic,copy) void(^clickNext)(void);
@property (nonatomic,copy) void(^clickFront)(void);
@property (nonatomic,copy) void(^clickJumpResultVc)(void);
@property (nonatomic,copy) void(^clickAccurateSearchButton)(BOOL isAccurateSearch);
@property (nonatomic,copy) void(^searchBlock)(NSString *key);
@end

NS_ASSUME_NONNULL_END
